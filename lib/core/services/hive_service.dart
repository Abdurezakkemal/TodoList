import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list/core/models/priority.dart';
import 'package:todo_list/core/models/settings.dart';
import 'package:todo_list/core/models/task.dart';
import 'package:todo_list/core/models/category.dart';

class HiveService {
  static const String _tasksBox = 'tasks';
  static const String _settingsBox = 'settings';
  static const String _categoriesBox = 'categories';
  static const String _backupBox = 'backup';

  static bool _isInitialized = false;
  static Directory? _appDocumentDir;

  // Getters for boxes
  static Box<Task> get tasksBox => Hive.box<Task>(_tasksBox);
  static Box<AppSettings> get settingsBox => Hive.box<AppSettings>(_settingsBox);
  static Box<Category> get categoriesBox => Hive.box<Category>(_categoriesBox);
  static Box<String> get backupBox => Hive.box<String>(_backupBox);

  /// Initializes Hive and opens all boxes
  static Future<void> init() async {
    if (_isInitialized) return;
    
    _appDocumentDir = await getApplicationDocumentsDirectory();
    
    // Initialize Hive with the app's document directory
    await Hive.initFlutter(_appDocumentDir?.path);

    // Register all adapters
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(AppSettingsAdapter());
    Hive.registerAdapter(PriorityAdapter());
    Hive.registerAdapter(CategoryAdapter());

    // Open all boxes
    await Future.wait([
      Hive.openBox<Task>(_tasksBox),
      Hive.openBox<AppSettings>(_settingsBox),
      Hive.openBox<Category>(_categoriesBox),
      Hive.openBox<String>(_backupBox),
    ]);

    _isInitialized = true;
  }

  /// Closes all open boxes and Hive
  static Future<void> close() async {
    if (!_isInitialized) return;
    
    await Hive.close();
    _isInitialized = false;
  }

  /// Clears all data from all boxes (for testing or reset)
  static Future<void> clearAllData() async {
    await tasksBox.clear();
    await settingsBox.clear();
    await categoriesBox.clear();
    await backupBox.clear();
  }

  /// Creates a backup of all data
  static Future<String> createBackup() async {
    final backup = <String, dynamic>{
      'tasks': tasksBox.toMap(),
      'settings': settingsBox.toMap(),
      'categories': categoriesBox.toMap(),
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    final backupString = backup.toString();
    await backupBox.put('last_backup', backupString);
    return backupString;
  }

  /// Restores data from a backup string
  static Future<bool> restoreFromBackup(String backupString) async {
    try {
      // TODO: Implement backup parsing and restoration
      // This is a simplified version - you'll need to parse the backup string
      // and properly restore each box's data
      return false;
    } catch (e) {
      return false;
    }
  }

  // Task operations
  static Future<void> saveTask(Task task) async {
    await tasksBox.put(task.id, task);
  }

  static Task? getTask(String id) {
    return tasksBox.get(id);
  }

  static List<Task> getAllTasks() {
    return tasksBox.values.toList();
  }

  static Future<void> deleteTask(String id) async {
    await tasksBox.delete(id);
  }

  // Category operations
  static Future<void> saveCategory(Category category) async {
    await categoriesBox.put(category.id, category);
  }

  static Category? getCategory(String id) {
    return categoriesBox.get(id);
  }

  static List<Category> getAllCategories() {
    return categoriesBox.values.toList();
  }

  static Future<void> deleteCategory(String id) async {
    await categoriesBox.delete(id);
  }

  // Settings operations
  static Future<void> saveSettings(AppSettings settings) async {
    await settingsBox.put('app_settings', settings);
  }

  static AppSettings getSettings() {
    return settingsBox.get('app_settings', 
      defaultValue: AppSettings()
    ) ?? AppSettings();
  }
}
