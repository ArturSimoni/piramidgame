// lib/data/services/theme_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const _key = 'pyramidgame_dark_mode';

  Future<bool> carregarTema() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  Future<void> salvarTema(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isDark);
  }
}
