import 'package:flutter/material.dart';
import 'package:todo_list/core/widgets/animated_checkbox.dart';
import 'package:get/get.dart';
import 'package:todo_list/core/models/priority.dart';
import 'package:todo_list/features/tasks/controllers/task_list_controller.dart';
import 'package:todo_list/app/routes/app_routes.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({Key? key}) : super(key: key);

  @override
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> with TickerProviderStateMixin {
  final TaskListController controller = Get.find<TaskListController>();

  // Helper function to get priority display name
  String getPriorityDisplayName(Priority priority) {
    switch (priority) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
    }
  }

  // Helper function to get priority color
  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  // Builds the AppBar, which includes the search functionality and tabbed view
  AppBar _buildAppBar() {
    return AppBar(
      title: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: controller.isSearchActive.value
              ? TextField(
                  key: const ValueKey('searchField'),
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search tasks...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: controller.setSearchQuery,
                )
              : const Text(
                  'To-Do List',
                  key: ValueKey('titleText'),
                ),
        ),
      ),
      actions: [
        Obx(() => IconButton(
              icon: Icon(controller.isSearchActive.value ? Icons.close : Icons.search),
              onPressed: () {
                controller.toggleSearch();
              },
            )),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value.startsWith('sort_')) {
              final sort = TaskSort.values.firstWhere(
                (s) => s.toString() == 'TaskSort.${value.replaceFirst('sort_', '')}',
              );
              controller.setSort(sort);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'sort',
              enabled: false,
              child: Text('SORT BY', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ...TaskSort.values.map((sort) => PopupMenuItem(
                  value: 'sort_${sort.name}',
                  child: Obx(() => Row(
                        children: [
                          if (controller.currentSort.value == sort)
                            const Icon(Icons.check, size: 20),
                          const SizedBox(width: 8),
                          Text(sort.name.split('.').last),
                        ],
                      )),
                )),
          ],
          icon: const Icon(Icons.sort),
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Get.toNamed(Routes.SETTINGS);
          },
        ),
      ],
      bottom: TabBar(
        controller: controller.tabController,
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Pending'),
          Tab(text: 'Completed'),
        ],
      ),
    );
  }

  late final AnimationController _animationController;
  late final Animation<double> _animation;



  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.tasks.isEmpty) {
          return Center(
            child: Text(
              controller.searchQuery.value.isEmpty
                  ? 'No tasks yet!\nTap the + button to add one.'
                  : 'No tasks found for "${controller.searchQuery.value}"',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.tasks.length,
          itemBuilder: (context, index) {
            final task = controller.tasks[index];
            return Dismissible(
              key: Key(task.id),
              onDismissed: (direction) {
                final item = controller.tasks[index];
                if (direction == DismissDirection.endToStart) {
                  controller.deleteTask(item.id);
                } else if (direction == DismissDirection.startToEnd) {
                  controller.updateTaskStatus(item.id, !item.isCompleted);
                }
              },
              background: Container(
                color: Colors.green,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.check_circle_outline, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0), // Smoother, more circular radius
                ),
                child: ListTile(
                  onLongPress: () {
                    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                    final RenderBox card = context.findRenderObject() as RenderBox;
                    final position = RelativeRect.fromRect(
                      Rect.fromPoints(
                        card.localToGlobal(const Offset(100, 100), ancestor: overlay),
                        card.localToGlobal(card.size.bottomRight(Offset.zero), ancestor: overlay),
                      ),
                      Offset.zero & overlay.size,
                    );
                    showMenu(
                      context: context,
                      position: position,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 8.0,
                      items: <PopupMenuEntry>[
                        const PopupMenuItem(
                          value: 'duplicate',
                          child: ListTile(leading: Icon(Icons.copy), title: Text('Duplicate')),
                        ),
                        const PopupMenuItem(
                          value: 'share',
                          child: ListTile(leading: Icon(Icons.share), title: Text('Share')),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete_outline, color: Colors.red),
                            title: Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ),
                      ],
                    ).then((value) {
                      if (value == 'duplicate') controller.duplicateTask(task.id);
                      if (value == 'share') controller.shareTask(task);
                      if (value == 'delete') controller.deleteTask(task.id);
                    });
                  },
                  onTap: () {
                    Get.toNamed(Routes.ADD_TASK, arguments: task);
                  },
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      color: task.isCompleted ? Colors.white60 : null,
                      fontWeight: FontWeight.w500, // Increased font weight
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (task.notes != null && task.notes!.isNotEmpty)
                        Text(
                          task.notes!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            color: task.isCompleted ? Colors.grey : null,
                            fontWeight: FontWeight.w500, // Increased font weight
                          ),
                        ),
                      if (task.dueDate != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: Colors.white60),
                            const SizedBox(width: 4),
                            Text(
                              '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                              style: const TextStyle(fontSize: 12, color: Colors.white60, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  leading: AnimatedCheckbox(
                    isChecked: task.isCompleted,
                    onChanged: (value) {
                      controller.updateTaskStatus(task.id, value);
                    },
                  ),
                ),
              ),
            );

          },
        );
      }),
      floatingActionButton: ScaleTransition(
        scale: _animation,
        child: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.ADD_TASK);
        },
        child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

