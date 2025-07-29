import 'package:get/get.dart';
import 'package:todo_list/app/routes/app_routes.dart';

// Splash
import 'package:todo_list/app/modules/splash/splash_binding.dart';
import 'package:todo_list/app/modules/splash/splash_view.dart';

// Tasks
import 'package:todo_list/features/tasks/views/task_list_view.dart';
import 'package:todo_list/features/tasks/views/task_form_view.dart';
import 'package:todo_list/features/tasks/bindings/task_list_binding.dart';
import 'package:todo_list/features/tasks/bindings/task_form_binding.dart';

// Onboarding
import 'package:todo_list/features/onboarding/views/onboarding_view.dart';
import 'package:todo_list/features/onboarding/bindings/onboarding_binding.dart';

// Settings
import 'package:todo_list/features/settings/views/settings_view.dart';
import 'package:todo_list/features/settings/bindings/settings_binding.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const TaskListView(),
      binding: TaskListBinding(),
    ),
    GetPage(
      name: Routes.ADD_TASK,
      page: () => const TaskFormView(),
      binding: TaskFormBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}

