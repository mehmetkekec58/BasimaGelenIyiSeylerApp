import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'language';
  static const List<String> _supportedLanguages = ['en', 'tr'];
  String _currentLanguage = 'en';

  LanguageProvider() {
    _loadLanguage();
  }

  String get currentLanguage => _currentLanguage;

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);

    if (savedLanguage == null) {
      // İlk kez açılıyor, cihaz dilini kontrol et
      final deviceLocale = WidgetsBinding.instance.window.locale.languageCode;
      _currentLanguage = _supportedLanguages.contains(deviceLocale) ? deviceLocale : 'en';
      await prefs.setString(_languageKey, _currentLanguage);
    } else {
      _currentLanguage = savedLanguage;
    }
    
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    if (_currentLanguage != languageCode && _supportedLanguages.contains(languageCode)) {
      _currentLanguage = languageCode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      notifyListeners();
    }
  }
} 