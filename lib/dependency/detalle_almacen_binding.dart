import 'package:get/instance_manager.dart';
import 'package:inventariosnew/controller/detalle_almacen_controller.dart';

class DetalleAlmacenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => DetalleAlmacenController(
        databaseRepositoryInterface: Get.find(),
      ),
    );
  }
}
