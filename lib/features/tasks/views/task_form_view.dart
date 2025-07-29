import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/core/models/priority.dart';
import 'package:todo_list/core/models/category.dart';
import 'package:todo_list/features/tasks/controllers/task_form_controller.dart';

class TaskFormView extends StatefulWidget {
  const TaskFormView({Key? key}) : super(key: key);

  @override
  _TaskFormViewState createState() => _TaskFormViewState();
}

class _TaskFormViewState extends State<TaskFormView> with TickerProviderStateMixin {

  final TaskFormController controller = Get.find<TaskFormController>();
  late final AnimationController _saveButtonController;
  late final Animation<double> _saveButtonAnimation;
  late final AnimationController _cancelButtonController;
  late final Animation<double> _cancelButtonAnimation;

  @override
  void initState() {
    super.initState();
    _saveButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _saveButtonAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _saveButtonController, curve: Curves.easeInOut),
    );

    _cancelButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _cancelButtonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cancelButtonController, curve: Curves.easeIn),
    );
    _cancelButtonController.forward();
  }

  @override
  void dispose() {
    _saveButtonController.dispose();
    _cancelButtonController.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    _saveButtonController.forward().then((_) {
      _saveButtonController.reverse();
      controller.saveTask();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing ? 'Edit Task' : 'Add New Task'),

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: controller.titleController,
                maxLength: 100,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                minLines: 3,
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.grey[900],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Priority', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white70)),
                      const SizedBox(height: 8.0),
                      Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: Priority.values.map((priority) {
                              final isSelected = controller.selectedPriority.value == priority;
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: ElevatedButton(
                                    onPressed: () => controller.setPriority(priority),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isSelected ? Colors.grey[700] : Colors.grey[850],
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    child: Text(priority.displayName),
                                  ),
                                ),
                              );
                            }).toList(),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<Category?>(
                    value: controller.selectedCategory.value,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('No Category'),
                      ),
                      ...controller.availableCategories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: Color(category.colorValue),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(category.name),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      controller.setCategory(value);
                    },
                  )),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: controller.selectedDueDate.value == null
                      ? ''
                      : DateFormat.yMMMd().format(controller.selectedDueDate.value!),
                ),
                decoration: const InputDecoration(
                  labelText: 'Due Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => controller.pickDueDate(context),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FadeTransition(
                    opacity: _cancelButtonAnimation,
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ScaleTransition(
                    scale: _saveButtonAnimation,
                    child: ElevatedButton(
                      onPressed: _onSavePressed,
                      child: const Text('Save'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
