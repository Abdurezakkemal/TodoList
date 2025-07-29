import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/core/services/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  // Reactive variable to hold the dark mode state
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load the current theme setting when the controller starts
    loadThemeSetting();
  }

  void loadThemeSetting() {
    final settings = _storageService.getSettings();
    // We consider the theme dark if it's explicitly set to dark.
    // We default to 'false' (light mode) if it's system or light.
    isDarkMode.value = settings.theme == ThemeMode.dark;
  }

  void changeTheme(bool isDark) {
    isDarkMode.value = isDark;

    final newTheme = isDark ? ThemeMode.dark : ThemeMode.light;

    // Apply the theme change instantly using GetX
    Get.changeThemeMode(newTheme);

    // Get the current settings, modify the theme, and save it back
    final settings = _storageService.getSettings();
    settings.theme = newTheme;
    _storageService.saveSettings(settings);
  }
}
