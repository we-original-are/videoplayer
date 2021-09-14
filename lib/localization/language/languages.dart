import 'package:flutter/material.dart';

abstract class Languages {
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }
  String get labelSelectLanguage;

  String get title;

  String get subTitle;

  String get accessDenied;

  String get notFound;

  String get tryAgain;

  String get listIconText;

  String get refreshIconText;

  String get options;

  String get share;

  String get info;

  String get delete;

  String get deleteMessage;

  String get yes;

  String get ok;

  String get cancel;

  String get close;

  String get video;

  String get details;

  String get fileName;

  String get resolution;

  String get fileSize;

  String get location;

  String get attention;

  String get pleaseWaiting;
}