import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/core/routes/routes.dart';
import 'package:inventariosnew/domain/model/productos/almacen.dart';
import 'package:inventariosnew/domain/repository/database_repository_interface.dart';

class DetalleAlmacenController extends GetxController {
  final DatabaseRepositoryInterface databaseRepositoryInterface;
  DetalleAlmacenController({
    required this.databaseRepositoryInterface,
  });

  final almacencon = TextEditingController();

  void insertaralmacen(Almacenes almacen) {
    almacencon.text = almacen.almacen.toString();
  }

  Future<void> actualizaralmacen(String id) async {
    final result = await databaseRepositoryInterface.updatedata(
      query: 'UPDATE almacenes SET almacen = ? WHERE id = ?',
      arguments: [
        almacencon.text,
        id,
      ],
    );
    if (result) {
      almacencon.clear();

      Get.snackbar("Exito", "Se Actualizo el almacen");
      Get.offAllNamed(Routes.index);
    } else {
      Get.snackbar("Opps!", "No se Actualizo");
    }
  }
}
