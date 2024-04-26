import 'package:get/instance_manager.dart';
import 'package:inventariosnew/controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SplashController(
        localRepositoryInterface: Get.find(),
      ),
    );
  }
}
