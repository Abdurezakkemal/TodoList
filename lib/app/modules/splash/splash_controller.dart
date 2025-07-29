import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/app/routes/app_routes.dart';

class SplashController extends GetxController {
  static const String _boxName = 'app_preferences';
  static const String _isFirstLaunchKey = 'is_first_launch';
  late final Box _box;

  @override
  void onInit() async {
    super.onInit();
    _box = await Hive.openBox(_boxName);
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    await Future.delayed(const Duration(seconds: 3));
    
    final isFirstLaunch = _box.get(_isFirstLaunchKey, defaultValue: true);
    
    if (isFirstLaunch) {
      await _box.put(_isFirstLaunchKey, false);
      Get.offAllNamed(Routes.ONBOARDING);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }
}
