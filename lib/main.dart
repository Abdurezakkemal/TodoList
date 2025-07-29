import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/app/routes/app_pages.dart';
import 'package:todo_list/app/routes/app_routes.dart';
import 'package:todo_list/app/theme/app_theme.dart';
import 'package:todo_list/core/services/app_initializer.dart';
import 'package:todo_list/shared/bindings/initial_binding.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize all services
    await Get.putAsync(() => AppInitializer.init());
    
    // Run the app
    runApp(const MyApp());
  } catch (e) {
    // Handle initialization errors gracefully
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Failed to initialize app: $e'),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'To-Do List App',
      theme: AppTheme.monochromeTheme, // Apply the new monochrome theme
      initialBinding: InitialBinding(),
      initialRoute: Routes.SPLASH,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      opaqueRoute: Get.isOpaqueRouteDefault,
      popGesture: Get.isPopGestureEnable,
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
