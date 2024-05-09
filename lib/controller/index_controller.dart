import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventariosnew/core/routes/routes.dart';
import 'package:inventariosnew/domain/model/productos/almacen.dart';
import 'package:inventariosnew/domain/model/productos/inventarios.dart';
import 'package:inventariosnew/domain/model/productos/productos.dart';
import 'package:inventariosnew/domain/repository/database_repository_interface.dart';
import 'package:inventariosnew/domain/repository/excel_repository_interface.dart';
import 'package:inventariosnew/domain/repository/local_repository_interface.dart';
import 'package:inventariosnew/screen/detalle_producto_page/detalle_pro_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexController extends GetxController {
  final LocalRepositoryInterface localRepositoryInterface;
  final DatabaseRepositoryInterface databaseRepositoryInterface;
  final ExcelRepositoryInterface excelRepositoryInterface;
  IndexController({
    required this.localRepositoryInterface,
    required this.databaseRepositoryInterface,
    required this.excelRepositoryInterface,
  });

  var indexpage = 0.obs;
  var indexpagedashboard = 0.obs;
  var cargando = false.obs;
  var openset = false.obs;
  var opcionedit = false.obs;

  var imagenPath = "".obs;
  var nombreuser = "".obs;
  var emailuser = "".obs;
  var apellidouser = "".obs;
  var selectfilename = "".obs;
  var xalmacen = ''.obs;
  var xsubalmacen = ''.obs;
  var almacenes = <Almacenes>[].obs;
  var listalmacenes = <String>[].obs;
  var listsubalmacenes = <String>[].obs;
  var productostotal = <Productos>[].obs;
  var listadeinventarios = <Inventarios>[].obs;
  RxList<String> dropdownItems = <String>[].obs;
  var resultbus = Rx<Productos?>(null);
  var nameexcel = TextEditingController();
  final searchalmacen = TextEditingController();
  final searchsubalmacen = TextEditingController();
  final stockController = TextEditingController();
  final selectalmacen = TextEditingController();
  final selectconteo = TextEditingController();
  final tablenameinventario = TextEditingController();
  final buscarController = TextEditingController();
  final fechaproconteo = TextEditingController();
  final fechacadconteo = TextEditingController();
  var searchText = ''.obs;
  var selectedItem = ''.obs;
  var selectedItem2 = ''.obs;
  var selectalmacenfiltro = ''.obs;
  var selectsubalmacenfiltro = ''.obs;
  var currentDateTime = ''.obs;
  var isDisposed = false.obs;

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isDisposed.value) {
        currentDateTime(
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));
      }
    });
  }

  void guardarindex(int index) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('index', index);
  }

  void usarindex() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    indexpage(pref.getInt('index') ?? 0);
  }

  @override
  void onInit() {
    usarindex();
    verificaropcionedit();
    super.onInit();
  }

  void verificaropcionedit() async {
    final result = await localRepositoryInterface.usarOpcionEdit();
    opcionedit(result);
  }

  Future<void> getAllProducts({required String selectalmacen}) async {
    String? tabla = await databaseRepositoryInterface
        .obtenernombredelinventarioactivomydb();
    productostotal.clear();
    String query = "SELECT * FROM '$tabla'";
    if (searchText.value == '' && selectalmacen == "TODOS") {
      query;
    } else if (searchText.value == '' && selectalmacen == "CONTADOS") {
      query += " WHERE conteo IS NOT NULL AND conteo != '0'";
    } else if (searchText.value == '' && selectalmacen == "NO CONTADOS") {
      query += " WHERE conteo IS NULL OR conteo = '0'";
    } else if (searchText.value != "" && selectalmacen == "TODOS") {
      query += " WHERE codbarra LIKE '%${searchText.value}%'";
    } else if (searchText.value != "" && selectalmacen == "NO CONTADOS") {
      query +=
          " WHERE codbarra LIKE '%${searchText.value}%' AND conteo IS NULL OR conteo = '0'";
    } else if (searchText.value != "" && selectalmacen == "CONTADOS") {
      query +=
          " WHERE codbarra LIKE '%${searchText.value}%' AND conteo IS NOT NULL AND conteo != '0'";
    }
    final products = await databaseRepositoryInterface
        .getdataProductobyDatabase(query: query);
    productostotal.assignAll(products);
  }

  Future<void> actualizarproducto({required Productos productos}) async {
    String? tabla = await databaseRepositoryInterface
        .obtenernombredelinventarioactivomydb();

    if (tabla != null) {
      Get.toNamed(
        Routes.detallepro,
        arguments: DetalleProScreen(tabla: tabla, productos: productos),
      );
    }
  }

  Future<void> cerrarlosinvetarios() async {
    bool result = await databaseRepositoryInterface.cerrarinventario();
    if (result) {
      Get.snackbar("Exito", "Se cerror correctamente");
    } else {
      Get.snackbar("Error", "Opps!! ocurrio un problema");
    }
  }

  void guardarDatos(
      {required String tableName,
      required String selectalmacen,
      required File selectedFile}) async {
    String tablabasededatos = tableName.trim().replaceAll(' ', '');
    if (tableName.isNotEmpty) {
      final data = await excelRepositoryInterface.insertarDatosDesdeExcel(
          filePath: selectedFile.path, basedatos: tablabasededatos);
      await databaseRepositoryInterface.insertarDatos(
        basedatos: tablabasededatos,
        data: data,
      );
      await databaseRepositoryInterface.insertarinven(
        tableName: tableName,
        selectalmacen: selectalmacen,
        basedatos: tablabasededatos,
      );

      Get.snackbar("Mensaje", "Los datos fueron importados correctamente");
    } else {
      Get.snackbar("Advertencia", "El nombre de la tabla no puede estar vacia");
    }
  }

  Future<void> verificaryguardardatos({
    required BuildContext context,
    required File? selectedFile,
  }) async {
    bool value = await databaseRepositoryInterface.datoactivo();
    if (value) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('ADVERTENCIA'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    'Existen inventarios abiertos, verifique antes de continuar',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  guardarDatos(
                      tableName: tablenameinventario.text,
                      selectalmacen: selectalmacen.text,
                      selectedFile: selectedFile!);
                },
                child: const Text("Aceptar"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancelar"),
              ),
            ],
          );
        },
      );
    } else {
      if (selectedFile != null) {
        guardarDatos(
          tableName: tablenameinventario.text,
          selectalmacen: selectalmacen.text,
          selectedFile: selectedFile,
        );
      } else {
        Get.snackbar(
            "Advertencia", "Seleccione un almacen y cargue un archivo");
      }
    }
  }

  Future<void> getAllProducts2({String? selectalmacen}) async {
    String query = "SELECT * FROM 'inventarios'";
    if (selectalmacen != null && selectalmacen.isNotEmpty) {
      query += " WHERE almacen LIKE '%$selectalmacen%'";
    } else {
      query;
    }
    listadeinventarios.clear();
    final inventario = await databaseRepositoryInterface
        .getdataInventariobyDatabase(query: query);
    listadeinventarios.addAll(inventario);
  }

  Future<void> cargartodoslosproducts(
      {required String? search,
      required String? almacen,
      required String? subalmacen}) async {
    productostotal.clear();
    final result = await databaseRepositoryInterface.cargarDatosInventarios(
      searchTerm: search,
      almacen: almacen,
      subalmacen: subalmacen,
    );
    productostotal.assignAll(result);
  }

  Future<void> guardaralmacen() async {
    final almacen = Almacenes(
      id: "",
      almacen: searchalmacen.text,
      subalmacen: searchsubalmacen.text,
    );
    bool result =
        await databaseRepositoryInterface.insertalmacen(almacen: almacen);
    if (result) {
      cargaralmacenes();
      Get.snackbar("Exito", "Se guardo correctamente el almacen");
      searchalmacen.text = '';
      searchsubalmacen.text = '';
    } else {
      Get.snackbar("Opps!", "Ocurrio un problema");
    }
  }

  Future<void> cargaralmacenes() async {
    almacenes.clear();
    final result = await databaseRepositoryInterface.cargardatosdealmacen();
    almacenes.assignAll(result);
  }

  Future<void> cargaralmacenesitem() async {
    listalmacenes.clear();
    final items = await databaseRepositoryInterface
        .listadelamacenes(where: null)
        .then((value) {
      final itemunicos = value.map((e) => e.toString()).toSet().toList();
      return itemunicos;
    });
    listalmacenes.assignAll(items);
  }

  Future<void> cargarsubalmacenesitem({required String where}) async {
    listsubalmacenes.clear();
    final items =
        await databaseRepositoryInterface.listadelamacenes(where: where);
    listsubalmacenes.assignAll(items);
  }

  Future<void> eliminardatatablabyid(
      {required String tabla, required String id, required int index}) async {
    final result =
        await databaseRepositoryInterface.deletedatabyid(tabla: tabla, id: id);
    if (result) {
      Get.snackbar("Exito", "Se elimino con exito");
    } else {
      Get.snackbar("Opps!", "No se pudo eliminar");
    }
  }

  Future<void> sumarconteo({required String codbarra}) async {
    await databaseRepositoryInterface.sumarconteo(
      almacen: xalmacen.value,
      subalmacen: xsubalmacen.value,
      codbarra: codbarra,
    );
    await buscarproducto(codbarra: codbarra);
  }

  Future<void> buscarproducto({required String codbarra}) async {
    final result =
        await databaseRepositoryInterface.buscarProducto(codigoBarra: codbarra);
    if (result != null) {
      resultbus(result);
    } else {
      Get.snackbar("Opps!", "No se encontro el producto");
    }
  }

  Future<void> cerrarsession() async {
    final result = await localRepositoryInterface.cerrarsession();
    if (result) {
      Get.offAllNamed(Routes.home);
    } else {
      Get.snackbar("Opps!", "Ocurrio un problema");
    }
  }

  Future<void> instanciarubicaciones() async {
    final result =
        await databaseRepositoryInterface.verificarlainsertcionubicacion();
    switch (result) {
      case 1:
        final data = await databaseRepositoryInterface.querydata(
          tabla: 'almacenes',
          columna: 'almacen',
          where: null,
        );
        final data2 = await databaseRepositoryInterface.querydata(
          tabla: 'almacenes',
          columna: 'subalmacen',
          where: data,
        );
        xalmacen(data);
        xsubalmacen(data2);
      case 2:
        final data = await databaseRepositoryInterface.querydata(
          tabla: 'almacenes',
          columna: 'almacen',
          where: null,
        );
        xalmacen(data);
    }
  }

  Future<void> actualizarConteo({required String conteo}) async {
    final result = await databaseRepositoryInterface.actualizarconteo(
      ubicacion: xalmacen.value,
      sububicacion: xsubalmacen.value,
      codigoBarra: resultbus.value!.codbarra.toString(),
      conteo: conteo,
    );
    if (result) {
      Get.snackbar("Exito", "Se Actualizo el conteo");
    } else {
      Get.snackbar("Opps!", "No se Pudo Actualizar el conteo");
    }
  }
}
