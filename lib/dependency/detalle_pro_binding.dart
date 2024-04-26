import 'package:get/instance_manager.dart';
import 'package:inventariosnew/controller/detalle_pro_controller.dart';

class DetalleProBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => DetalleProController(
        databaseRepositoryInterface: Get.find(),
      ),
    );
  }
}
