import 'package:get/instance_manager.dart';
import 'package:inventariosnew/controller/detalle_inventario_controller.dart';

class DetalleInventarioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => DetalleInventarioController(
        databaseRepositoryInterface: Get.find(),
        excelRepositoryInterface: Get.find(),
      ),
    );
  }
}
