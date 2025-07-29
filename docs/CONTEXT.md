# ✅ To-Do App – Functional Context & Feature Guide

A modern, modular To-Do List app designed for clarity, productivity, and a seamless user experience.

---

Tech Stack:
Frontend: Flutter
Database: Hive
UI Framework: Flutter
state management: GetX

## 1. 🚀 Splash & Onboarding

### 🌀 Splash Screen

- Animated checkmark or dynamic task list icon
- Auto-transitions to onboarding after a short delay

### 🎯 Onboarding Screens

- Highlights core benefits:
  - Task organization
  - Smart reminders
  - Priority labeling
  - Cross-device sync (if implemented)
- Final screen:  
  **Start** or **Skip** button → Navigates to Task List

---

## 2. 📋 Task List Screen

### 🔎 Task Views

- Tabs/filters: **All**, **Pending**, **Completed**

### 🗂 Task Display

Each task shows:

- **Title**
- **Due Date**
- **Priority** (color-coded):  
  🔴 High 🟡 Medium 🟢 Low

### 📱 Interactions

- **Swipe left:** Delete task  
  (shows Snackbar with Undo)
- **Swipe right:** Mark as complete
- **Tap:** Edit/View Task
- **Long Press:** Options  
  (Duplicate, Share, Delete)

### 🔍 Search & Sort

- **Search bar:** Filter by keywords
- **Sort options:**  
  By due date, priority, or alphabetically

---

## 3. ✏️ Add / Edit Task

### Form UI

- Modal or full-screen

#### Fields

- **Title** (required)
- **Notes** (optional)
- **Due Date:** Date picker
- **Priority:** Dropdown or toggle (High/Medium/Low)

#### Actions

- **Save:** Validates input, shows toast on success (e.g., “Task saved ✅”)
- **Cancel:** Discards changes immediately

---

## 4. ✅ Task Interaction Logic

- **Checkbox:** Instantly toggles completion status and updates list
- **Tap:** Opens details or edit form
- **Long Press:** Duplicate, Share, or Delete

---

## 5. 🔔 Notifications & Reminders

- **Push Notifications:**
  - Reminders (1 hour before due, or configurable)
  - Daily summary at 8:00 AM (optional)
- **Settings:**
  - Toggle notifications
  - Choose reminder time
  - Enable/disable sound and vibration

---

## 6. ⚙️ Settings Screen

### App Preferences

- **Theme:** Light/Dark
- **Default Priority** for new tasks

### Notifications

- Toggle sound & vibration
- Set daily summary time
- Enable/disable reminders

### Backup & Restore

- Manual/automatic backup to cloud/local storage
- Restore tasks on new device or reinstall

---

## 7. 🧩 Additional Notes

- Responsive design for all mobile sizes
- Snappy interactions with feedback (toasts, animations)
- Tasks stored locally (Hive)

---

## 🧠 Developer Notes

- Modularize: `TaskCard`, `TaskForm`, `TaskList`, `NotificationService`
- Ensure accessibility and internationalization
- Maintain clean MVVM or layered architecture
- Test edge cases: missing fields, overdue tasks, empty states

---

## 📄 Core Screens Summary

| Screen        | Purpose                                |
| ------------- | -------------------------------------- |
| Splash        | Branded intro animation                |
| Onboarding    | Intro to key features and benefits     |
| Task List     | View, filter, and manage all tasks     |
| Add/Edit Task | Create or update a task                |
| Task Details  | View full task info and options        |
| Settings      | Configure app preferences and behavior |
| Notifications | System-level reminders for due tasks   |

---

## 8. 🗄️ Database Schema (Hive)

### Task Model
```dart
@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;                    // Unique identifier (UUID)
  
  @HiveField(1)
  String title;                 // Task title (required)
  
  @HiveField(2)
  String? notes;                // Additional notes (optional)
  
  @HiveField(3)
  DateTime? dueDate;            // Due date and time (nullable)
  
  @HiveField(4)
  Priority priority;            // enum: high, medium, low
  
  @HiveField(5)
  bool isCompleted;             // Completion status
  
  @HiveField(6)
  DateTime createdAt;           // Creation timestamp
  
  @HiveField(7)
  DateTime updatedAt;           // Last update timestamp
  
  @HiveField(8)
  DateTime? reminderTime;       // When to send reminder (nullable)
  
  @HiveField(9)
  bool isDeleted;               // Soft delete flag (for undo)
}
```

### Settings Model
```dart
@HiveType(typeId: 1)
class AppSettings extends HiveObject {
  @HiveField(0)
  ThemeMode theme;              // light, dark, system
  
  @HiveField(1)
  Priority defaultPriority;     // Default priority for new tasks
  
  @HiveField(2)
  bool notificationsEnabled;    // Enable/disable notifications
  
  @HiveField(3)
  int reminderOffsetMinutes;    // Minutes before due for reminders
  
  @HiveField(4)
  TimeOfDay? dailySummaryTime;  // Time for daily summary (nullable)
  
  @HiveField(5)
  bool soundEnabled;            // Enable/disable sound
  
  @HiveField(6)
  bool vibrationEnabled;        // Enable/disable vibration
  
  @HiveField(7)
  bool autoBackupEnabled;       // Enable/disable auto backup
}
```

### Priority Enum
```dart
@HiveType(typeId: 2)
enum Priority {
  @HiveField(0)
  low,
  
  @HiveField(1)
  medium,
  
  @HiveField(2)
  high,
}
```

### Hive Boxes
- **tasks**: Box<Task> - Stores all tasks
- **settings**: Box<AppSettings> - Stores app settings (singleton)
- **backup**: Box<String> - Stores backup data (optional)

---

## 9. 📁 Optimal Folder Structure (Flutter + GetX + Hive)

```
lib/
│
├── main.dart
├── app/
│   ├── app.dart                    # App entry, theme, routing
│   ├── routes/
│   │   ├── app_pages.dart          # GetX route definitions
│   │   └── app_routes.dart         # Route constants
│   └── theme/
│       ├── app_theme.dart          # Light/dark themes
│       └── app_colors.dart         # Color constants
│
├── core/
│   ├── models/
│   │   ├── task.dart               # Task Hive model
│   │   ├── settings.dart           # Settings Hive model
│   │   └── priority.dart           # Priority enum
│   ├── services/
│   │   ├── hive_service.dart       # Hive initialization & management
│   │   ├── notification_service.dart
│   │   ├── backup_service.dart
│   │   └── storage_service.dart    # Hive box operations
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── hive_constants.dart     # Box names, type IDs
│   └── utils/
│       ├── date_utils.dart
│       ├── validators.dart
│       └── extensions.dart
│
├── features/
│   ├── splash/
│   │   ├── controllers/
│   │   │   └── splash_controller.dart
│   │   └── views/
│   │       └── splash_view.dart
│   ├── onboarding/
│   │   ├── controllers/
│   │   │   └── onboarding_controller.dart
│   │   └── views/
│   │       └── onboarding_view.dart
│   ├── tasks/
│   │   ├── controllers/
│   │   │   ├── task_list_controller.dart
│   │   │   ├── task_form_controller.dart
│   │   │   └── task_details_controller.dart
│   │   ├── views/
│   │   │   ├── task_list_view.dart
│   │   │   ├── task_form_view.dart
│   │   │   └── task_details_view.dart
│   │   └── widgets/
│   │       ├── task_card.dart
│   │       ├── task_filter_bar.dart
│   │       ├── priority_selector.dart
│   │       └── date_picker_field.dart
│   └── settings/
│       ├── controllers/
│       │   └── settings_controller.dart
│       └── views/
│           └── settings_view.dart
│
├── shared/
│   ├── widgets/
│   │   ├── custom_app_bar.dart
│   │   ├── loading_widget.dart
│   │   ├── empty_state_widget.dart
│   │   └── custom_snackbar.dart
│   └── bindings/
│       └── initial_binding.dart    # GetX dependency injection
│
└── generated/
    └── hive_adapters.dart          # Generated Hive type adapters
```

### Additional Files
- **pubspec.yaml**: Dependencies (flutter, get, hive, etc.)
- **analysis_options.yaml**: Linting rules
- **assets/**: Images, animations, icons
- **test/**: Unit and widget tests

---

## 10. 📝 GetX Architecture Notes

### Controllers
- Use `GetxController` for state management
- Implement reactive variables with `.obs`
- Handle business logic and Hive operations

### Services
- Register services in `InitialBinding`
- Use `Get.find<ServiceName>()` for dependency injection
- Services handle cross-feature functionality

### Navigation
- Use `Get.toNamed()` for navigation
- Define routes in `app_routes.dart`
- Configure pages in `app_pages.dart`

---

**End of Functional Context File**
