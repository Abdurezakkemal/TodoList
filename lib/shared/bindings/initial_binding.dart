import 'package:get/get.dart';
import 'package:todo_list/core/services/storage_service.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Use lazyPut with fenix:true to ensure the service is always available.
    Get.lazyPut<StorageService>(() => StorageService(), fenix: true);
  }
}
