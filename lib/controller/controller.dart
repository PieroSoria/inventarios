import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/connection/function/usertoken.dart';
import 'package:inventarios/database/createdb/database.dart';
import 'package:inventarios/database/function/funciones_basicas.dart';
import 'package:inventarios/models/productos/almacen.dart';
import 'package:inventarios/models/productos/productos.dart';
import 'package:inventarios/models/productos/ubicacioneslet.dart';
import 'package:inventarios/settings/token.dart';
import 'package:sqflite/sqflite.dart';

class Controller extends GetxController {
  SQLdb funciones = SQLdb();
  final funcioness = FuncionesBasic();
  TokenGet x = TokenGet();
  RxBool cargando = false.obs;
  RxString xubicacion = "".obs;
  RxString xsububicacion = "".obs;
  RxString conteo = "".obs;
  RxString imagenPath = "".obs;
  RxString nombreuser = "".obs;
  RxString emailuser = "".obs;
  RxString apellidouser = "".obs;
  RxBool loginanregis = false.obs;
  RxList<Almacenes> almacenes = <Almacenes>[].obs;
  RxList<Ubicacioneslet> ubicacion = <Ubicacioneslet>[].obs;
  RxList<Productos> productostotal = <Productos>[].obs;
  RxList dropdownitemubicacion = [].obs;
  RxList dropdownitemsububicacion = [].obs;
  RxList<Productos> resultbus = <Productos>[].obs;

  Future<void> getAllProducts(String table, {String? searchText}) async {
    String query = "SELECT * FROM $table";
    if (searchText != null && searchText.isNotEmpty) {
      query += " WHERE nombre LIKE '%$searchText%'";
    }
    if (table == "almacenes") {
      List<Map<String, dynamic>> products = await funciones.getdata(query);
      almacenes.assignAll(
        products.map((map) => Almacenes.fromMap(map)).toList(),
      );
    } else if (table == "ubicaciones") {
      List<Map<String, dynamic>> products = await funciones.getdata(query);
      ubicacion.assignAll(
          products.map((map) => Ubicacioneslet.fromMap(map)).toList());
    }
  }

  Future<void> usardatonombre() async {
    String token = await x.usartoken();
    if (token != "") {
      final respon = await mostrarDato();
      if (respon.error == null) {
        nombreuser.value = respon.data!.nombre;
        apellidouser.value = respon.data!.apellido;
        emailuser.value = respon.data!.email;
      } else {
        Get.snackbar("Mensaje", "Error es : ${respon.error}");
      }
    } else {
      return;
    }
  }

  Future<void> initDropdownItemsubicacion() async {
    final dropdownItems = await funcioness.captureData(
        "ubicaciones", "ubicacion", "SELECCIONAR UBICACION", null);
    dropdownitemubicacion.assignAll(dropdownItems);
    debugPrint("Es $dropdownitemubicacion");
  }

  Future<void> initDropdownItemssububicacion(String where) async {
    final dropdownItems = await funcioness.captureData(
        "ubicaciones", "sububicacion", "SELECCIONAR SUBUBICACION", where);
    dropdownitemsububicacion.assignAll(dropdownItems);
  }

  Future<void> cargarDatosInventarios(String? searchTerm) async {
    Database? mydb = await funciones.db;
    List<Map<String, Object?>> inventarios =
        await mydb!.query('inventarios', columns: ['basedatos']);
    List<String> nombresBasesDeDatos =
        inventarios.map((e) => e['basedatos'] as String).toList();
    debugPrint(nombresBasesDeDatos.toString());

    for (String nombreBaseDatos in nombresBasesDeDatos) {
      List<Map<String, dynamic>> datosTabla = await mydb.query(nombreBaseDatos);
      List<Productos> productos =
          datosTabla.map((e) => Productos.fromMap(e)).toList();

      if (searchTerm != null && searchTerm.isNotEmpty) {
        // Filtrar solo si hay un término de búsqueda
        productos = productos
            .where((producto) =>
                producto.descripcion
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()) ||
                producto.codbarra
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()))
            .toList();
      }

      productostotal.assignAll(productos);
    }
  }
}
