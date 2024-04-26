import 'package:get/instance_manager.dart';
import 'package:inventariosnew/controller/index_controller.dart';

class IndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => IndexController(
        localRepositoryInterface: Get.find(),
        databaseRepositoryInterface: Get.find(),
        excelRepositoryInterface: Get.find(),
      ),
    );
  }
}
