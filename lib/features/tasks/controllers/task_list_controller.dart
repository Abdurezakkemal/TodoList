import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todo_list/core/models/priority.dart';
import 'package:todo_list/core/models/task.dart';
import 'package:todo_list/core/services/storage_service.dart';

enum TaskFilter {
  all,
  active,
  completed,
  highPriority,
  mediumPriority,
  lowPriority,
}

enum TaskSort {
  createdAtNewest,
  createdAtOldest,
  dueDateEarliest,
  dueDateLatest,
  priorityHighToLow,
  priorityLowToHigh,
}

class TaskListController extends GetxController with GetSingleTickerProviderStateMixin {
  final StorageService _storageService = Get.find<StorageService>();
  final RxList<Task> _allTasks = <Task>[].obs;
  final Rx<TaskFilter> currentFilter = TaskFilter.all.obs;
  final Rx<TaskSort> currentSort = TaskSort.createdAtNewest.obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final Rx<Task?> lastDeletedTask = Rx<Task?>(null);
    final RxInt taskCount = 0.obs;
    final RxString searchQuery = ''.obs;
  final RxBool isSearchActive = false.obs;
  late TabController tabController;

  List<Task> get tasks {
    // Apply filter
    var filteredTasks = _allTasks.where((task) {
      switch (currentFilter.value) {
        case TaskFilter.active:
          return !task.isCompleted;
        case TaskFilter.completed:
          return task.isCompleted;
        case TaskFilter.highPriority:
          return task.priority == Priority.high;
        case TaskFilter.mediumPriority:
          return task.priority == Priority.medium;
        case TaskFilter.lowPriority:
          return task.priority == Priority.low;
        case TaskFilter.all:
        default:
          return true;
      }
    }).toList();

    // Apply search query
    if (searchQuery.value.isNotEmpty) {
      filteredTasks = filteredTasks.where((task) {
        final query = searchQuery.value.toLowerCase();
        return task.title.toLowerCase().contains(query) ||
               (task.notes != null && task.notes!.toLowerCase().contains(query));
      }).toList();
    }

    // Apply sort
    filteredTasks.sort((a, b) {
      switch (currentSort.value) {
        case TaskSort.createdAtNewest:
          return b.createdAt.compareTo(a.createdAt);
        case TaskSort.createdAtOldest:
          return a.createdAt.compareTo(b.createdAt);
        case TaskSort.dueDateEarliest:
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        case TaskSort.dueDateLatest:
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return b.dueDate!.compareTo(a.dueDate!);
        case TaskSort.priorityHighToLow:
          return _priorityToInt(b.priority).compareTo(_priorityToInt(a.priority));
        case TaskSort.priorityLowToHigh:
          return _priorityToInt(a.priority).compareTo(_priorityToInt(b.priority));
      }
    });

    return filteredTasks;
  }

  int _priorityToInt(Priority priority) {
    switch (priority) {
      case Priority.high:
        return 2;
      case Priority.medium:
        return 1;
      case Priority.low:
        return 0;
    }
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        switch (tabController.index) {
          case 0:
            setFilter(TaskFilter.all);
            break;
          case 1:
            setFilter(TaskFilter.active);
            break;
          case 2:
            setFilter(TaskFilter.completed);
            break;
        }
      }
    });
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final tasks = _storageService.getAllTasks();
      _allTasks.assignAll(tasks);
      taskCount.value = _allTasks.where((t) => !t.isCompleted).length;
    } catch (e) {
      errorMessage.value = 'Failed to load tasks: $e';
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void setFilter(TaskFilter filter) {
    currentFilter.value = filter;
  }

  void setSort(TaskSort sort) {
    currentSort.value = sort;
  }

    void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void toggleSearch() {
    isSearchActive.value = !isSearchActive.value;
    if (!isSearchActive.value) {
      setSearchQuery('');
    }
  }

  Future<bool> updateTaskStatus(String taskId, bool isCompleted) async {
    try {
      final task = _storageService.getTask(taskId);
      if (task == null) return false;
      
      final updatedTask = task.copyWith(
        isCompleted: isCompleted,
      );
      updatedTask.updatedAt = DateTime.now();
      
      await _storageService.saveTask(updatedTask);

      // Find and update the task in the local list to trigger UI refresh
      final taskIndex = _allTasks.indexWhere((t) => t.id == taskId);
      if (taskIndex != -1) {
        _allTasks[taskIndex] = updatedTask;
      }

      taskCount.value = _allTasks.where((t) => !t.isCompleted).length;
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to update task status: $e';
      return false;
    }
  }

  Future<bool> deleteTask(String taskId, {bool permanent = false}) async {
    try {
      final taskIndex = _allTasks.indexWhere((t) => t.id == taskId);
      if (taskIndex == -1) return false;

      final task = _allTasks[taskIndex];
      lastDeletedTask.value = task;

      // Remove from UI list immediately
      _allTasks.removeAt(taskIndex);

      if (permanent) {
        await _storageService.permanentlyDeleteTask(taskId);
      } else {
        await _storageService.deleteTask(taskId); // This is a soft delete
        _showUndoSnackbar(task, taskIndex);
      }

      taskCount.value = _allTasks.where((t) => !t.isCompleted).length;
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to delete task: $e';
      // If deletion fails, add the task back to the list
      if (lastDeletedTask.value != null) {
        _allTasks.add(lastDeletedTask.value!);
      }
      return false;
    }
  }
  
  Future<void> duplicateTask(String taskId) async {
    try {
      final taskToDuplicate = _allTasks.firstWhere((task) => task.id == taskId);
      final duplicatedTask = Task(
        title: 'Copy of ${taskToDuplicate.title}',
        notes: taskToDuplicate.notes,
        dueDate: taskToDuplicate.dueDate,
        priority: taskToDuplicate.priority,
        category: taskToDuplicate.category,
        isCompleted: false, // Duplicated tasks are not completed by default
      );
      await _storageService.saveTask(duplicatedTask);
      _allTasks.add(duplicatedTask);
    } catch (e) {
      errorMessage.value = 'Failed to duplicate task: $e';
    }
  }

  void _showUndoSnackbar(Task task, int index) {
    Get.snackbar(
      'Task Moved to Trash',
      'The task has been moved to trash',
      mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
          undoDelete(task, index);
        },
        child: const Text('UNDO'),
      ),
      duration: const Duration(seconds: 5),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  Future<bool> undoDelete(Task task, int index) async {
    try {
      final restoredTask = task.copyWith(
        isDeleted: false,
      );
      await _storageService.saveTask(restoredTask);

      // Add the task back to the list at its original position
      _allTasks.insert(index, restoredTask);

      taskCount.value = _allTasks.where((t) => !t.isCompleted).length;
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to restore task: $e';
      return false;
    }
  }

  Future<void> shareTask(Task task) async {
    final String taskDetails = 'Task: ${task.title}\n' + 
                               (task.notes != null ? 'Notes: ${task.notes}\n' : '') + 
                               (task.dueDate != null ? 'Due: ${task.dueDate.toString().substring(0, 10)}' : '');
    
    await Share.share(taskDetails, subject: 'Task Details: ${task.title}');
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}

