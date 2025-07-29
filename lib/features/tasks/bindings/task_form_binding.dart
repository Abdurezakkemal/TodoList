import 'package:get/get.dart';
import 'package:todo_list/core/models/task.dart';
import 'package:todo_list/features/tasks/controllers/task_form_controller.dart';

class TaskFormBinding implements Bindings {
  @override
  void dependencies() {
    // Retrieve the task from arguments. It can be null if creating a new task.
    final Task? task = Get.arguments as Task?;

    Get.lazyPut<TaskFormController>(
      () => TaskFormController(initialTask: task),
    );
  }
}
