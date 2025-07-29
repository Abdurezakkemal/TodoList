import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/app/routes/app_routes.dart';
import 'package:todo_list/core/services/storage_service.dart';

class OnboardingInfo {
  final IconData icon;
  final String title;
  final String description;

  OnboardingInfo({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class OnboardingController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  late PageController pageController;
  final RxInt currentPage = 0.obs;

  final List<OnboardingInfo> onboardingPages = [
    OnboardingInfo(
      icon: Icons.lightbulb_outline_rounded,
      title: 'Welcome to Your To-Do App',
      description: 'Get organized and boost your productivity. Let\'s start by creating your first task.',
    ),
    OnboardingInfo(
      icon: Icons.checklist_rtl_rounded,
      title: 'Manage Tasks with Ease',
      description: 'Swipe right to complete, swipe left to delete. Long-press for more options like duplicating tasks.',
    ),
    OnboardingInfo(
      icon: Icons.notifications_active_outlined,
      title: 'Stay on Track',
      description: 'Set due dates and priorities to never miss a deadline. Get reminders for your important tasks.',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void completeOnboarding() {
    final settings = _storageService.getSettings();
    settings.onboardingCompleted = true;
    _storageService.saveSettings(settings);
    Get.offAllNamed(Routes.HOME);
  }
}
