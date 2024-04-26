import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/domain/model/productos/productos.dart';
import 'package:inventariosnew/domain/repository/database_repository_interface.dart';

class DetalleProController extends GetxController {
  final DatabaseRepositoryInterface databaseRepositoryInterface;
  DetalleProController({
    required this.databaseRepositoryInterface,
  });

  final codbarra = TextEditingController();
  final producto = TextEditingController();
  final medida = TextEditingController();
  final categoria = TextEditingController();
  final precio = TextEditingController();
  final stock = TextEditingController();
  final conteo = TextEditingController();
  final diferencia = TextEditingController();
  final almacen = TextEditingController();
  final subalmacen = TextEditingController();
  final lote = TextEditingController();
  final numlote = TextEditingController();
  final fechapro = TextEditingController();
  final fechacad = TextEditingController();
  final serie = TextEditingController();
  final numserie = TextEditingController();

  var dropitemalmacen = [].obs;
  var dropitemsubalmacen = [].obs;
  DateTime? selectedDate;
  var selectedItem = ''.obs;
  var selectedItem2 = ''.obs;
  var selectmode = ''.obs;

  void insertardata(Productos productos) async {
    codbarra.text = productos.codbarra ?? '';
    producto.text = productos.producto ?? '';
    medida.text = productos.medida ?? '';
    categoria.text = productos.categoria ?? '';
    precio.text = productos.precio ?? '';
    stock.text = productos.stock ?? '';
    conteo.text = productos.conteo ?? '';
    diferencia.text = productos.diferencia ?? '';
    almacen.text = productos.almacen ?? '';
    subalmacen.text = productos.subalmacen ?? '';
    lote.text = productos.lote ?? '';
    numlote.text = productos.numlote ?? '';
    fechapro.text = productos.fechapro ?? '';
    fechacad.text = productos.fechacad ?? '';
    serie.text = productos.serie ?? '';
    numserie.text = productos.numserie ?? '';

    loteserie(lote.text, serie.text);
  }

  void loteserie(String lote, String serie) {
    if (lote == '1') {
      selectmode("Lote");
    } else if (serie == "1") {
      selectmode("Serie");
    } else {
      selectmode("Ninguno");
    }
  }

  Future<void> actualizarproductobyid(
      {required String id, required String tabla}) async {
    bool rep = await databaseRepositoryInterface.updatedata(query: '''
                  UPDATE $tabla SET
                    codbarra = ?,
                    producto = ?,
                    almacen = ?,
                    subalmacen = ?,
                    medida = ?,
                    categoria = ?,
                    precio = ?,
                    stock_inicial = ?,
                    conteo = ?,
                    diferencia = ?,
                    lote = ?,
                    num_lote = ?,
                    fecha_pro = ?,
                    fecha_cad = ?,
                    serie = ?,
                    num_serie = ?
                    WHERE id = ?
                    ''', arguments: [
      codbarra.text,
      producto.text,
      almacen.text,
      subalmacen.text,
      medida.text,
      categoria.text,
      precio.text,
      stock.text,
      conteo.text,
      diferencia.text,
      lote.text,
      numlote.text,
      fechapro.text,
      fechacad.text,
      serie.text,
      numserie.text,
      id
    ]);
    if (rep) {
      Get.snackbar("Exito", "Se actualizo correctamente el producto");
    }
  }

  Future<void> cargarlistaalmacen() async {
    final result =
        await databaseRepositoryInterface.listadelamacenes(where: null);
    dropitemalmacen.assignAll(result);
  }

  Future<void> cargarlistasubalmacen({required String where}) async {
    final result =
        await databaseRepositoryInterface.listadelamacenes(where: where);
    dropitemsubalmacen.assignAll(result);
  }
}
