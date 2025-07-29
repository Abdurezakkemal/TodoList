import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'priority.dart';
import 'category.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  late String id;
  
  @HiveField(1)
  late String title;
  
  @HiveField(2)
  String? notes;
  
  @HiveField(3)
  DateTime? dueDate;
  
  @HiveField(4)
  late Priority priority;
  
  @HiveField(5)
  late bool isCompleted;
  
  @HiveField(6)
  late DateTime createdAt;
  
  @HiveField(7)
  late DateTime updatedAt;
  
  @HiveField(8)
  DateTime? reminderTime;
  
  @HiveField(9)
  late bool isDeleted;

  @HiveField(10)
  Category? category;

  Task({
    String? id,
    required this.title,
    this.notes,
    this.dueDate,
    this.priority = Priority.medium,
    this.isCompleted = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.reminderTime,
    this.isDeleted = false,
    this.category,
  }) {
    this.id = id ?? const Uuid().v4();
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
  }

  // Copy with method for updates
  Task copyWith({
    String? title,
    String? notes,
    DateTime? dueDate,
    Priority? priority,
    bool? isCompleted,
    DateTime? reminderTime,
    bool? isDeleted,
    Category? category,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      reminderTime: reminderTime ?? this.reminderTime,
      isDeleted: isDeleted ?? this.isDeleted,
      category: category ?? this.category,
    );
  }

  // Check if task is overdue
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  // Check if task is due today
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final due = dueDate!;
    return now.year == due.year && 
           now.month == due.month && 
           now.day == due.day;
  }
}
