import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final GetStorage _themeBox = GetStorage();
  final String _themeKey = 'isDarkMode';

  Future<void> _saveThemeToBox(bool isDarkMode) async =>
      await _themeBox.write(_themeKey, isDarkMode);

  bool loadThemeFromBox() => _themeBox.read<bool>(_themeKey) ?? false;

  ThemeMode get themeMode =>
      loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  Future<void> switchTheme() async {
    Get.changeThemeMode(loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    await _saveThemeToBox(!loadThemeFromBox());
  }
}
