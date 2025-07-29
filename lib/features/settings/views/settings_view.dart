import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/features/settings/controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Obx(() => ListTile(
                  title: const Text('Dark Mode'),
                  trailing: Switch(
                    value: controller.isDarkMode.value,
                    onChanged: controller.changeTheme,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
