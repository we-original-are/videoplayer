import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({Key? key, required this.videoPlayerControllerX})
      : super(key: key);
  final VideoPlayerController videoPlayerControllerX;

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;

  late ChewieController _chewieController;

  @override
  void dispose() {
    _videoPlayerController.pause();
    _chewieController.pause();
    super.dispose();
  }

  @override
  void initState() {
    _videoPlayerController = widget.videoPlayerControllerX..initialize();
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        looping: true,
        autoPlay: true,
        aspectRatio: 3 / 2,
        autoInitialize: true,
        customControls: CupertinoControls(
            backgroundColor: Colors.black.withOpacity(.6),
            iconColor: Colors.white),
        cupertinoProgressColors: ChewieProgressColors(
          playedColor: Colors.blue,
          bufferedColor: Colors.white38,
          handleColor: Colors.blue,
        ),
        placeholder: Container(
          color: Colors.black,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
            child: Container(
                color: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Chewie(controller: _chewieController))));
  }
}
