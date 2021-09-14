import 'package:flutter/material.dart';
import 'package:videoplayer/localization/language/languages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage('images/pic1.jpg'), fit: BoxFit.cover)),
        child: Container(
          width: width,
          height: height,
          color: Colors.black.withOpacity(.4),
          padding: EdgeInsets.only(top: 10, bottom: 20, right: 10, left: 10),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              leading: Icon(
                Icons.slow_motion_video_outlined,
                color: Colors.white,
                size: 60,
              ),
              title: Text(
                Languages.of(context)!.title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                Languages.of(context)!.subTitle,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
