import 'package:get/get.dart';
import 'package:todo_list/features/onboarding/controllers/onboarding_controller.dart';

class OnboardingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(() => OnboardingController());
  }
}
