class LanguageData {
  late final String flag;
  late final String name;
  late final String languageCode;

  LanguageData(this.name, this.flag, this.languageCode);

  static List<LanguageData> languageList() {
    return <LanguageData>[
      LanguageData('us', "English", 'en'),
      LanguageData('ir', "فارسی", 'fa'),
    ];
  }
}
