import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'priority.dart';

part 'settings.g.dart';

@HiveType(typeId: 1)
class AppSettings extends HiveObject {
  @HiveField(0)
  late int themeMode; // 0: system, 1: light, 2: dark
  
  @HiveField(1)
  late Priority defaultPriority;
  
  @HiveField(2)
  late bool notificationsEnabled;
  
  @HiveField(3)
  late int reminderOffsetMinutes;
  
  @HiveField(4)
  String? dailySummaryTime; // Stored as "HH:mm" format
  
  @HiveField(5)
  late bool soundEnabled;
  
  @HiveField(6)
  late bool vibrationEnabled;
  
  @HiveField(7)
  late bool autoBackupEnabled;

  @HiveField(8)
  late bool onboardingCompleted;

  AppSettings({
    this.themeMode = 0, // System default
    this.defaultPriority = Priority.medium,
    this.notificationsEnabled = true,
    this.reminderOffsetMinutes = 60, // 1 hour before
    this.dailySummaryTime,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.autoBackupEnabled = false,
    this.onboardingCompleted = false,
  });

  // Convert theme mode to ThemeMode enum
  ThemeMode get theme {
    switch (themeMode) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  // Set theme mode from ThemeMode enum
  set theme(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        themeMode = 1;
        break;
      case ThemeMode.dark:
        themeMode = 2;
        break;
      default:
        themeMode = 0;
    }
  }

  // Convert daily summary time string to TimeOfDay
  TimeOfDay? get dailySummaryTimeOfDay {
    if (dailySummaryTime == null) return null;
    final parts = dailySummaryTime!.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  // Set daily summary time from TimeOfDay
  set dailySummaryTimeOfDay(TimeOfDay? time) {
    if (time == null) {
      dailySummaryTime = null;
    } else {
      dailySummaryTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  // Create default settings
  static AppSettings defaultSettings() {
    return AppSettings(
      dailySummaryTime: '08:00', // 8:00 AM default
    );
  }
}
