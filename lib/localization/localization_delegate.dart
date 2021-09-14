import 'package:flutter/cupertino.dart';
import 'package:videoplayer/localization/language/language_en.dart';
import 'package:videoplayer/localization/language/languages.dart';

import 'language/language_fa.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<Languages> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['fa', 'en'].contains(locale.languageCode);

  @override
  Future<Languages> load(Locale locale) => _load(locale);

  static Future<Languages> _load(Locale locale) async {
    if (locale.languageCode == 'fa') {
      return LanguageFa();
    } else if (locale.languageCode == 'en') {
      return LanguageEn();
    } else {
      return LanguageFa();
    }
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<Languages> old) => false;
}
