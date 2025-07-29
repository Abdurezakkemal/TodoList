import 'package:get/get.dart';
import 'package:todo_list/features/tasks/controllers/task_list_controller.dart';

class TaskListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskListController>(() => TaskListController());
  }
}
