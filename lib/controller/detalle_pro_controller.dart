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
  final tipoproducto = TextEditingController();
  final valor = TextEditingController();
  final fechapro = TextEditingController();
  final fechacad = TextEditingController();
  final comentario = TextEditingController();

  var dropitemalmacen = [].obs;

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
    tipoproducto.text = productos.tipoproducto ?? '';
    valor.text = productos.valor ?? '';
    fechapro.text = productos.fechapro ?? '';
    fechacad.text = productos.fechacad ?? '';
    comentario.text = productos.comentario ?? '';

    loteserie(tipoproducto.text);
  }

  void loteserie(String tipoproducto) {
    if (tipoproducto == '1') {
      selectmode("Lote");
    } else if (tipoproducto == "2") {
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
                    medida = ?,
                    categoria = ?,
                    precio = ?,
                    stock_inicial = ?,
                    conteo = ?,
                    diferencia = ?,
                    tipoproducto = ?,
                    valor = ?,
                    fecha_pro = ?,
                    fecha_cad = ?,
                    comentario = ?,
                    WHERE id = ?
                    ''', arguments: [
      codbarra.text,
      producto.text,
      almacen.text,
      medida.text,
      categoria.text,
      precio.text,
      stock.text,
      conteo.text,
      diferencia.text,
      tipoproducto.text,
      valor.text,
      fechapro.text,
      fechacad.text,
      comentario.text,
      id
    ]);
    if (rep) {
      Get.snackbar("Exito", "Se actualizo correctamente el producto");
    }
  }

  Future<void> cargarlistaalmacen() async {
    final result =
        await databaseRepositoryInterface.listadelamacenes();
    dropitemalmacen.assignAll(result);
  }
}
