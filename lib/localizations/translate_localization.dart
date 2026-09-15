import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TranslateLocalization {
  Locale locale;

  TranslateLocalization({required this.locale});

  static TranslateLocalization? of(BuildContext context) {
    return Localizations.of<TranslateLocalization>(
      context,
      TranslateLocalization,
    );
  }

  static const LocalizationsDelegate<TranslateLocalization> delegate =
      _TranslateLocalization();

  late Map<String, String> translateMap;

  Future<void> loadJsonLang() async {
    final stringJson = await rootBundle.loadString(
      'assets/lang/${locale.languageCode}.json',
    );
    Map<String, dynamic> jsonMap = json.decode(stringJson);
    translateMap = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  String translate(String key) {
    return translateMap[key] ?? '';
  }
}

class _TranslateLocalization
    extends LocalizationsDelegate<TranslateLocalization> {
  const _TranslateLocalization();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<TranslateLocalization> load(Locale locale) async {
    TranslateLocalization translateLocalization = TranslateLocalization(
      locale: locale,
    );
    await translateLocalization.loadJsonLang();
    return translateLocalization;
  }

  @override
  bool shouldReload(
    covariant LocalizationsDelegate<TranslateLocalization> old,
  ) {
    return false;
  }
}

extension Translate on String {
  String t(BuildContext context) {
    return TranslateLocalization.of(context)!.translate(this);
  }
}
