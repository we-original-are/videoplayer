import 'dart:io';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';
import 'package:videoplayer/home_screen.dart';
import 'package:videoplayer/localization/language/languages.dart';
import 'package:videoplayer/video_screens/video_player.dart';

class VidListView extends StatefulWidget {
  const VidListView(
      {Key? key, required this.videosInfo, required this.viewStyle})
      : super(key: key);
  final List<VideoData> videosInfo;
  final bool viewStyle;

  @override
  _VidListViewState createState() => _VidListViewState();
}

class _VidListViewState extends State<VidListView> {
  late VideoPlayerController videoPlayerController;
  List<String> videoPaths = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: GridView.count(
          padding: EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 10),
          crossAxisCount: 1,
          childAspectRatio: 2.5,
          mainAxisSpacing: 2.5,
          crossAxisSpacing: 2.5,
          children: List.generate(widget.videosInfo.length, (index) {
            videoPlayerController = VideoPlayerController.file(
                File(widget.videosInfo[index].path.toString()))
              ..initialize();
            var control = videoPlayerController;
            return _videoListView(index, control);
          }),
        ),
      ),
    );
  }

  _videoListView(int index, VideoPlayerController control) {
    double width = MediaQuery.of(context).size.width;
    var vidTime =
        Duration(milliseconds: widget.videosInfo[index].duration!.round())
            .inSeconds;
    var hour = vidTime / 3600;
    var hourPlus = hour.toString().split('.');
    int hourFinal = int.parse(hourPlus[0]);
    var hourX = vidTime % 3600;
    var min = hourX / 60;
    var minPlus = min.toString().split('.');
    int minFinal = int.parse(minPlus[0]);
    var minX = hourX % 60;
    var sec = minX;
    var hourT =
        (hourFinal >= 10 ? hourFinal : ("0" + hourFinal.toString())).toString();
    var minT =
        (minFinal >= 10 ? minFinal : ("0" + minFinal.toString())).toString();
    var secT = (sec >= 10 ? sec : ("0" + sec.toString())).toString();

    var _videoTime = ("$hourT:$minT:$secT");

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onLongPress: () {
          _optionsDialog(index);
        },
        onTap: () {
          Route route = MaterialPageRoute(builder: (context) {
            return VideoPlayerPage(videoPlayerControllerX: control);
          });
          Navigator.push(context, route);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: (width / 2) - 8,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: VideoPlayer(videoPlayerController)),
            ),
            SizedBox(
              width: (width / 2) - 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: (width / 2) - 8,
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      widget.videosInfo[index].title.toString().length > 45
                          ? widget.videosInfo[index].title
                                  .toString()
                                  .substring(0, 45) +
                              "..."
                          : widget.videosInfo[index].title.toString(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.only(left: 8.0),
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            _videoTime.toString(),
                            style: TextStyle(
                                color: Theme.of(context).primaryIconTheme.color),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            _optionsDialog(index);
                          },
                          icon: Icon(Icons.more_vert))
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

   _optionsDialog(int index) {
    double width = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.zero,
            title: Container(
              width: width,
              child: Text(Languages.of(context)!.options,
                  style: TextStyle(
                      color: Theme.of(context).primaryIconTheme.color)),
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
            ),
            content: SizedBox(
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      shareFile(index);
                    },
                    leading: Icon(Icons.share),
                    title: Text(
                      Languages.of(context)!.share,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      showInfo(index);
                    },
                    leading: Icon(Icons.info_outline),
                    title: Text(Languages.of(context)!.info),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      deleteFile(widget.videosInfo[index].path.toString());
                    },
                    leading: Icon(Icons.delete),
                    title: Text(Languages.of(context)!.delete),
                  ),
                ],
              ),
            ),
            actions: [
              SizedBox(
                width: width,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(Languages.of(context)!.cancel)),
              )
            ],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
          );
        });
  }

  shareFile(int index) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    if (Platform.isAndroid) {
      File videoFile = new File(widget.videosInfo[index].path.toString());
      setState(() {
        videoPaths.add(videoFile.path);
      });
      if (videoPaths.isNotEmpty) {
        await Share.shareFiles(videoPaths,
            text: widget.videosInfo[index].title,
            subject: Languages.of(context)!.video,
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Error Video ',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    }
    setState(() {
      videoPaths.clear();
    });
  }

  showInfo(int index) {
    double width = MediaQuery.of(context).size.width;
    Map<String, dynamic> vidInfo = {
      "name": widget.videosInfo[index].title,
      "width": widget.videosInfo[index].width!.round(),
      "height": widget.videosInfo[index].height!.round(),
      "fileSize": filesize(widget.videosInfo[index].filesize),
      "location": widget.videosInfo[index].path,
    };
    print(widget.videosInfo[index].filesize);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            titlePadding: EdgeInsets.zero,
            title: Container(
              width: width,
              child: Text(Languages.of(context)!.details,
                  style:TextStyle(
                      color: Theme.of(context).primaryIconTheme.color)),
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(Languages.of(context)!.fileName +
                      vidInfo["name"].toString()),
                  Divider(
                    thickness: 2,
                  ),
                  Text(Languages.of(context)!.resolution +
                      "${vidInfo["width"].toString()}x${vidInfo["height"].toString()}"),
                  Divider(
                    thickness: 2,
                  ),
                  Text(Languages.of(context)!.fileSize +
                      vidInfo["fileSize"].toString()),
                  Divider(
                    thickness: 2,
                  ),
                  Text(Languages.of(context)!.location +
                      vidInfo["location"].toString()),
                ],
              ),
            ),
            actions: [
              SizedBox(
                width: width,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(Languages.of(context)!.close)),
              )
            ],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
          );
        });
  }

  deleteFile(String path) async {
    double width = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            titlePadding: EdgeInsets.zero,
            title: Container(
              width: width,
              child: Text(Languages.of(context)!.attention,
                  style: TextStyle(
                      color: Theme.of(context).primaryIconTheme.color)),
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
            ),
            content: Text(Languages.of(context)!.deleteMessage),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    _deleteFile(path);
                    Route route = MaterialPageRoute(builder: (context) {
                      return HomeScreen(
                        viewStyle: widget.viewStyle,
                      );
                    });
                    Navigator.pushAndRemoveUntil(
                        context, route, (route) => false);
                  },
                  child: Text(Languages.of(context)!.yes)),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(Languages.of(context)!.cancel)),
            ],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
          );
        });
  }

  _deleteFile(String path) async {
    final dir = Directory(path);
    dir.deleteSync(recursive: true);
  }
}
