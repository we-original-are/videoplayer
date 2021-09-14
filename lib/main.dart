import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:videoplayer/splash_screen.dart';
import 'home_screen.dart';
import 'localization/local_constant.dart';
import 'localization/localization_delegate.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('fa', '');
  late bool _viewStyle = true;
  int homeNumber = 0;
  late int _index = 0;
  Random random = new Random();
  List<MaterialColor> _colors = <MaterialColor>[
    Colors.purple,
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.pink,
    Colors.teal,
    Colors.deepPurple,
    Colors.cyan,
    Colors.blueGrey
  ];

  void setLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });
  }

  void _getLocal() async {
    await getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
  }

  void _getStyleShow() async {
    await getStyleShow().then((viewStyle) {
      if (viewStyle != null) {
        setState(() {
          _viewStyle = viewStyle;
        });
      }
    });
  }

  void _replacePage() async {
    Timer(Duration(seconds: 8), () {
      setState(() {
        homeNumber = 1;
      });
    });
  }

  void _changeIndex() async {
    setState(() {
      _index = random.nextInt(_colors.length - 1);
    });
  }

  @override
  void initState() {
    _getStyleShow();
    _getLocal();
    _changeIndex();
    _replacePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!);
        },
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('fa', ''),
          Locale('en', ''),
        ],
        locale: _locale,
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        theme: ThemeData(primarySwatch: _colors[_index], fontFamily: "fontFa1"),
        home: homeNumber == 0
            ? SplashScreen()
            : HomeScreen(
          viewStyle: _viewStyle,
        ));
  }
}
