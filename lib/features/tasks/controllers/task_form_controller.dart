import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/core/models/priority.dart';
import 'package:todo_list/core/models/task.dart';
import 'package:todo_list/core/models/category.dart';
import 'package:todo_list/core/services/storage_service.dart';
import 'package:todo_list/features/tasks/controllers/task_list_controller.dart';

class TaskFormController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final Task? initialTask; // Make task optional for editing

  TaskFormController({this.initialTask});

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Text editing controllers
  late TextEditingController titleController;
  late TextEditingController notesController;

  // Reactive variables for form state
  final Rx<Priority> selectedPriority = Priority.medium.obs;
  final Rx<DateTime?> selectedDueDate = Rx<DateTime?>(null);
  final Rx<Category?> selectedCategory = Rx<Category?>(null);
  final RxList<Category> availableCategories = <Category>[].obs;

  bool get isEditing => initialTask != null; // Add this line to fix the missing getter error

  @override
  void onInit() {
    super.onInit();
    titleController = TextEditingController(text: initialTask?.title);
    notesController = TextEditingController(text: initialTask?.notes);
    if (isEditing) {
      selectedPriority.value = initialTask!.priority;
      selectedDueDate.value = initialTask!.dueDate;
      selectedCategory.value = initialTask!.category;
    }
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = _storageService.getAllCategories();
    availableCategories.assignAll(categories);
    
    // If no categories exist, initialize default ones
    if (categories.isEmpty) {
      await _storageService.initializeDefaultCategories();
      availableCategories.assignAll(_storageService.getAllCategories());
    }
    
    // If editing and task has a category, ensure it's in the available categories
    if (isEditing && initialTask?.category != null) {
      final categoryExists = availableCategories.any((cat) => cat.id == initialTask!.category!.id);
      if (!categoryExists) {
        availableCategories.add(initialTask!.category!);
      }
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    notesController.dispose();
    super.onClose();
  }

  void setPriority(Priority priority) {
    selectedPriority.value = priority;
  }

  Future<void> pickDueDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDueDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      selectedDueDate.value = pickedDate;
    }
  }

  void saveTask() {
    if (formKey.currentState?.validate() ?? false) {
      if (isEditing) {
        // Update existing task
        final updatedTask = initialTask!.copyWith(
          title: titleController.text,
          notes: notesController.text.isNotEmpty ? notesController.text : null,
          priority: selectedPriority.value,
          dueDate: selectedDueDate.value,
          category: selectedCategory.value,
        );
        _storageService.saveTask(updatedTask).then((_) {
          Get.find<TaskListController>().loadTasks();
          Get.back();
          Get.snackbar('Success', 'Task updated successfully!', snackPosition: SnackPosition.BOTTOM);
        });
      } else {
        // Create new task
        final newTask = Task(
          title: titleController.text,
          notes: notesController.text.isNotEmpty ? notesController.text : null,
          priority: selectedPriority.value,
          dueDate: selectedDueDate.value,
          category: selectedCategory.value,
        );
        _storageService.saveTask(newTask).then((_) {
          Get.find<TaskListController>().loadTasks();
          Get.back();
          Get.snackbar('Success', 'Task added successfully!', snackPosition: SnackPosition.BOTTOM);
        });
      }
    }
  }
  
  // Method to update the selected category
  void setCategory(Category? category) {
    selectedCategory.value = category;
  }
}

