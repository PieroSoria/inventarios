import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/core/routes/routes.dart';
import 'package:inventariosnew/domain/model/productos/inventarios.dart';
import 'package:inventariosnew/domain/repository/database_repository_interface.dart';
import 'package:inventariosnew/domain/repository/excel_repository_interface.dart';

class DetalleInventarioController extends GetxController {
  final DatabaseRepositoryInterface databaseRepositoryInterface;
  final ExcelRepositoryInterface excelRepositoryInterface;
  DetalleInventarioController({
    required this.databaseRepositoryInterface,
    required this.excelRepositoryInterface,
  });

  var estadoinve = false.obs;

  final nombreexcel = TextEditingController();
  final keyform = GlobalKey<FormState>();

  Future<void> exportarExcel(Inventarios inventario) async {
    String name = nombreexcel.text.trim().replaceAll(' ', '_');
    String nombretabla = inventario.nombre;
    final tabla = await databaseRepositoryInterface.obtenerbasedatos(
        tablanombre: nombretabla);
    final data = await databaseRepositoryInterface.queryDatabase(table: tabla!);
    await excelRepositoryInterface.convertTableToExcel(
      name: name,
      tabledata: data,
    );
  }

  Future<void> activarinventario(Inventarios inventario) async {
    bool rep4 = await databaseRepositoryInterface.updatedata(
        query: "UPDATE inventarios SET activo = ?", arguments: ["CERRADO"]);
    if (estadoinve.value) {
      bool rep3 = await databaseRepositoryInterface.updatedata(
          query: "UPDATE inventarios SET activo = ? WHERE nombre = ?",
          arguments: ["ABIERTO", inventario.nombre]);
      if (rep4 && rep3) {
        Get.snackbar("Exito", "Se Abrio el inventario");
      } else {
        Get.snackbar("Opps!", "Hubo un problema");
      }
    } else {
      Get.snackbar("Exito", "Se cerro el inventario");
    }
  }

  Future<void> eliminarinventario(Inventarios inventario) async {
    bool rep = await databaseRepositoryInterface.deletedatabyid(
      tabla: "inventarios",
      id: inventario.id.toString(),
    );
    bool rep2 = await databaseRepositoryInterface.deletedatabyid(
      tabla: inventario.basedatos.toString(),
      id: null,
    );

    debugPrint("$rep y $rep2");
    if (rep && rep2) {
      Get.snackbar("Exito", "Se elimino el inventario ${inventario.nombre}");
      Get.offAllNamed(Routes.index);
    }
  }
}
