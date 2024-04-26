import 'package:get/instance_manager.dart';
import 'package:inventariosnew/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(
        databaseRepositoryInterface: Get.find(),
        localRepositoryInterface: Get.find(),
      ),
    );
  }
}
