import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/core/services/hive_service.dart';

class AppInitializer extends GetxService {
  static Future<AppInitializer> init() async {
    final initializer = Get.put(AppInitializer());
    await initializer._initServices();
    return initializer;
  }

  Future<void> _initServices() async {
    try {
      // Initialize Hive and open boxes
      await HiveService.init();
      
      // Initialize default settings if first run
      await _initializeDefaultSettings();
      
      debugPrint('✅ All services initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing services: $e');
      rethrow;
    }
  }

  Future<void> _initializeDefaultSettings() async {
    final settings = HiveService.getSettings();
    
    // Only save if no settings exist yet
    if (!HiveService.settingsBox.values.any((s) => s.key == 'app_settings')) {
      await HiveService.saveSettings(settings);
      debugPrint('ℹ️ Initialized default app settings');
    }
  }

  @override
  void onClose() {
    // Clean up resources when the app is closing
    HiveService.close();
    super.onClose();
  }
}
