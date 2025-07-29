import 'package:flutter/material.dart';
import 'package:todo_list/core/models/settings.dart';
import 'package:todo_list/core/models/task.dart';
import 'package:todo_list/core/models/category.dart';
import 'hive_service.dart';

class StorageService {
  // Task Operations
  List<Task> getAllTasks() {
    return HiveService.tasksBox.values.where((task) => !task.isDeleted).toList();
  }

  Future<void> saveTask(Task task) async {
    await HiveService.tasksBox.put(task.id, task);
  }

  Future<void> deleteTask(String taskId) async {
    final task = HiveService.tasksBox.get(taskId);
    if (task != null) {
      task.isDeleted = true;
      task.updatedAt = DateTime.now();
      await task.save();
    }
  }

  Future<void> permanentlyDeleteTask(String taskId) async {
    await HiveService.tasksBox.delete(taskId);
  }

  Task? getTask(String taskId) {
    return HiveService.tasksBox.get(taskId);
  }

  // Settings Operations
  AppSettings getSettings() {
    // There should only be one settings object, stored at a known key.
    if (HiveService.settingsBox.isEmpty) {
      final defaultSettings = AppSettings.defaultSettings();
      HiveService.settingsBox.put(0, defaultSettings);
      return defaultSettings;
    }
    return HiveService.settingsBox.getAt(0)!;
  }

  Future<void> saveSettings(AppSettings settings) async {
    await HiveService.settingsBox.put(0, settings);
  }

  // Backup Operations
  Future<void> saveBackup(String backupJson) async {
    await HiveService.backupBox.put('last_backup', backupJson);
  }

  String? getBackup() {
    return HiveService.backupBox.get('last_backup');
  }

  // Category Operations
  List<Category> getAllCategories() {
    return HiveService.categoriesBox.values.toList();
  }

  Future<void> saveCategory(Category category) async {
    await HiveService.categoriesBox.put(category.id, category);
  }

  Future<void> deleteCategory(String categoryId) async {
    // First, remove this category from all tasks that have it
    final tasks = HiveService.tasksBox.values.where((task) => task.category?.id == categoryId);
    for (final task in tasks) {
      task.category = null;
      await task.save();
    }
    
    // Then delete the category
    await HiveService.categoriesBox.delete(categoryId);
  }

  Category? getCategory(String categoryId) {
    return HiveService.categoriesBox.get(categoryId);
  }

  // Get default categories (called during first app launch)
  List<Category> getDefaultCategories() {
    return [
      Category(
        id: 'work',
        name: 'Work',
        colorValue: Colors.blue.value,
      ),
      Category(
        id: 'personal',
        name: 'Personal',
        colorValue: Colors.green.value,
      ),
      Category(
        id: 'shopping',
        name: 'Shopping',
        colorValue: Colors.orange.value,
      ),
      Category(
        id: 'health',
        name: 'Health',
        colorValue: Colors.red.value,
      ),
    ];
  }

  // Initialize default categories if none exist
  Future<void> initializeDefaultCategories() async {
    if (HiveService.categoriesBox.isEmpty) {
      final defaultCategories = getDefaultCategories();
      for (final category in defaultCategories) {
        await saveCategory(category);
      }
    }
  }
}
