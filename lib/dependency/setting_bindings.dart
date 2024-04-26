import 'package:get/instance_manager.dart';
import 'package:inventariosnew/controller/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SettingController(
        localRepositoryInterface: Get.find(),
      ),
    );
  }
}
