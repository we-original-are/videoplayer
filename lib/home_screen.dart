import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:videoplayer/localization/language/languages.dart';
import 'package:videoplayer/video_screens/video_gridView.dart';
import 'package:videoplayer/video_screens/video_listview.dart';

import 'language_data.dart';
import 'localization/local_constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.viewStyle}) : super(key: key);
  final bool viewStyle;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController videoPlayerController;
  PermissionStatus _permissionStatus = PermissionStatus.limited;

  bool onData = true;
  late bool onList;
  bool progress = false;
  Set<String> _videos = {};
  List<VideoData> videosInfo = [];

  Future<List<StorageInfo>?> initPlatformState() async {
    List<StorageInfo> storageInfo = [];
    try {
      storageInfo = await PathProviderEx.getStorageInfo();
    } on PlatformException {}
    if (!mounted) return null;

    return storageInfo;
  }

  Future<PermissionStatus?> requestPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status;
    } else {
      return null;
    }
  }

  void _listenForPermissionStatus() async {
    final status = await requestPermission();
    setState(() {
      _permissionStatus = status!;
    });
    if (_permissionStatus.isGranted) {
      getVideoFromDirectory();
    }
  }

  void getVideoFromDirectory() async {
    var _storageInfo = await initPlatformState();
    String internalStorageRoot = "";
    String sdCardRoot = "";
    setState(() {
      _videos.clear();
      videosInfo.clear();
    });

    if (_storageInfo!.length > 0) {
      internalStorageRoot = _storageInfo[0].rootDir;
      if (_storageInfo.length > 1) {
        sdCardRoot = _storageInfo[1].rootDir;
      }
      Directory dirStorage = Directory('$internalStorageRoot');
      Directory dirSD = Directory('$sdCardRoot');
      List<FileSystemEntity> _files;
      _files = dirStorage.listSync(recursive: true, followLinks: false);
      _files += dirSD.listSync(recursive: true, followLinks: false);
      for (FileSystemEntity entity in _files) {
        String path = entity.path;
        if (path.endsWith('.mp4')) {
          setState(() {
            _videos.add(path);
          });
        }
      }
      var videos = _videos.toList();
      final videoInfo = FlutterVideoInfo();
      for (String path in videos) {
        String videoFilePath = path;
        var info = await videoInfo.getVideoInfo(videoFilePath);
        setState(() {
          videosInfo.add(info!);
          progress = false;
        });
      }
      testData();
    }
  }

  void testData() async {
    Timer(Duration(seconds: 7), () {
      if (videosInfo.length == 0 && _permissionStatus.isGranted) {
        setState(() {
          onData = false;
          progress = false;
        });
      }
    });
  }

  @override
  void initState() {
    setState(() {
      onList = widget.viewStyle;
    });
    _listenForPermissionStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _permissionStatus.isGranted
              ? IconButton(
                  tooltip: Languages.of(context)!.refreshIconText,
                  onPressed: () {
                    _listenForPermissionStatus();
                    setState(() {
                      progress = true;
                      testData();
                    });
                  },
                  icon: Icon(Icons.refresh))
              : Text(""),
          IconButton(
              tooltip: Languages.of(context)!.listIconText,
              onPressed: () {
                if (onList) {
                  setState(() {
                    onList = false;
                  });
                  setStyleShow(false);
                } else {
                  setState(() {
                    onList = true;
                  });
                  setStyleShow(true);
                }
              },
              icon: onList
                  ? Icon(Icons.view_agenda_outlined)
                  : Icon(Icons.grid_view)),
          PopupMenuButton<LanguageData>(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            icon: Icon(Icons.more_vert),
            tooltip: Languages.of(context)!.labelSelectLanguage,
            onSelected: (LanguageData? language) {
              changeLanguage(context, language!.languageCode);
            },
            itemBuilder: (context) => LanguageData.languageList()
                .map<PopupMenuItem<LanguageData>>((e) =>
                    PopupMenuItem<LanguageData>(value: e, child: Text(e.flag)))
                .toList(),
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.slow_motion_video_outlined),
            SizedBox(
              width: 10,
            ),
            Text(Languages.of(context)!.title),
          ],
        ),
      ),
      body: Center(child: _bodyView()),
    );
  }

  _bodyView() {
    if (_permissionStatus.isDenied) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Languages.of(context)!.accessDenied,
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
              onPressed: () {
                _listenForPermissionStatus();
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  Languages.of(context)!.tryAgain,
                ),
              )),
        ],
      );
    } else if (_permissionStatus.isLimited) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            Languages.of(context)!.pleaseWaiting,
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            width: 15,
          ),
          CircularProgressIndicator(),
        ],
      );
    } else if (_permissionStatus.isGranted) {
      if (videosInfo.length > 0) {
        if (onList) {
          return VidListView(
            videosInfo: videosInfo,
            viewStyle: onList,
          );
        } else {
          return VidGridView(
            videosInfo: videosInfo,
            viewStyle: onList,
          );
        }
      } else if (!onData) {
        if (progress) {
          return CircularProgressIndicator();
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_rounded,
                size: 100,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                Languages.of(context)!.notFound,
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  _listenForPermissionStatus();
                  setState(() {
                    progress = true;
                    testData();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    Languages.of(context)!.tryAgain,
                  ),
                ),
              ),
            ],
          );
        }
      } else {
        return CircularProgressIndicator();
      }
    } else {
      return Text("");
    }
  }
}
