import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videoplayer/main.dart';

const String prefSelectLanguageCode = "SelectedLanguageCode";
const String prefSelectShow = "SelectStyleShow";

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(prefSelectLanguageCode, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(prefSelectLanguageCode) ?? "fa";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  return languageCode != null && languageCode.isNotEmpty
      ? Locale(languageCode, '')
      : Locale('fa', '');
}

void changeLanguage(BuildContext context, String selectLanguageCode) async {
  var _locale = await setLocale(selectLanguageCode);
  MyApp.setLocale(context, _locale);
}

Future setStyleShow(bool style) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(prefSelectShow, style);
}

Future<bool?> getStyleShow() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? style = prefs.getBool(prefSelectShow);
  return style;
}
