import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:tabee/utils/pref_manager.dart';

//const String _storageKey = "MyApplication_";

const List<String> _supportedLanguages = ['en', 'ar'];
const Map<String, String> supportedLanguagesFull = {
  "en": "English",
  "ar": "العربية",
  "tr": "Türkçe"
};

// TODO: This class used for translations

class GlobalTranslations {
  Locale _locale;
  Map<dynamic, dynamic> _localizedValues;
  VoidCallback _onLocaleChangedCallback;
  bool isSet = false;

  Iterable<Locale> supportedLocales() {
    return _supportedLanguages.map((supportedLanguage) {
      return new Locale(supportedLanguage);
    });
  }

  String text(String key) {
    if (_localizedValues == null || _localizedValues[key] == null) {
      return key;
    } else {
      return _localizedValues[key];
    }
  }

  get currentLanguage {
    if (_locale == null)
      return 'en';
    else
      return _locale.languageCode;
  }

  get currentLanguageFull =>
      _locale == null ? 'en' : supportedLanguagesFull[_locale.languageCode];

  get locale => _locale;

  bool isRtl() {
    return currentLanguage.contains('ar');
  }

  Future<Null> init([String language]) async {
    if (_locale == null) {
      await setNewLanguage(language);
    }
    return null;
  }

  getPreferredLanguage() {
    return PrefManager().get('language', 'en');
  }

  setPreferredLanguage(String lang) {
    return PrefManager().set('language', lang);
  }

  Future<Null> setNewLanguage(
      [String newLanguage, bool saveInPrefs = true]) async {
    String language = newLanguage;
    if (language == null) {
      language = await getPreferredLanguage();
    }
    if (language == "") {
      language = "en";
    }
    _locale = Locale(language, "");

    String jsonContent =
        await rootBundle.loadString("i18n/i18n_${_locale.languageCode}.json");
    _localizedValues = json.decode(jsonContent);

    // If we are asked to save the new language in the application preferences
    if (saveInPrefs) {
      await setPreferredLanguage(language);
    }

    // If there is a callback to invoke to notify that a language has changed
    if (_onLocaleChangedCallback != null) {
      _onLocaleChangedCallback();
    }
    isSet = true;
    return null;
  }

  ///
  /// Callback to be invoked when the user changes the language
  ///
  set onLocaleChangedCallback(VoidCallback callback) {
    _onLocaleChangedCallback = callback;
  }

  ///
  /// Singleton Factory
  ///
  static final GlobalTranslations _translations =
      new GlobalTranslations._internal();

  factory GlobalTranslations() {
    return _translations;
  }

  GlobalTranslations._internal();
}

GlobalTranslations lang = new GlobalTranslations();
