import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/productos/inventarios.dart';
import '../../models/productos/productos.dart';
import '../createdb/database.dart';
import 'funciones_basicas.dart';

class ExcelFuncion {
  SQLdb sqLdb = SQLdb();
  FuncionesBasic funciones = FuncionesBasic();
  Future<void> insertarDatosDesdeExcel(
      String filePath, String basedatos) async {
    List<List<dynamic>> excelData = await leerExcel(filePath);
    await insertarDatos(excelData, basedatos);
  }

  Future<List<List<dynamic>>> leerExcel(String filePath) async {
    try {
      var bytes = File(filePath).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      var sheet = excel.tables[excel.tables.keys.first];
      var rows = sheet!.rows;
      debugPrint(rows.toString());
      return rows.sublist(1);
    } catch (e, stackTrace) {
      debugPrint("Error al leer el archivo Excel: $e");
      debugPrint("StackTrace: $stackTrace");
    
      return List<List<dynamic>>.empty();
    }
  }

  Future<bool> _checkTableExists(String tableName, Database database) async {
    var table = await database.query(
      'sqlite_master',
      where: 'type = ? AND name = ?',
      whereArgs: ['table', tableName],
    );
    return table.isNotEmpty;
  }

  Future<void> insertarDatos(List<List<dynamic>> data, String basedatos) async {
    final SQLdb sqLdb = SQLdb();
    Database? mydb = await sqLdb.db;

    var tableExists = await _checkTableExists(basedatos, mydb!);
    if (!tableExists) {
      await mydb.execute('''
      CREATE TABLE $basedatos (
        id TEXT PRIMARY KEY,
        codigo TEXT,
        codbarra TEXT,
        descripcion TEXT,
        medida TEXT,
        categoria TEXT,
        precio TEXT,
        stock_inicial TEXT,
        conteo TEXT,
        diferencia TEXT,
        ubicacion TEXT,
        sububicacion TEXT,
        lote TEXT,
        num_lote TEXT,
        fecha_pro TEXT,
        fecha_cad TEXT,
        serie TEXT,
        num_serie TEXT,
        tdatos TEXT
      )
    ''');
    }

    for (var fila in data) {
      var lastRow = await mydb.query(basedatos, orderBy: 'id DESC', limit: 1);
      var lastId = lastRow.isNotEmpty ? lastRow.first['id']?.toString() : '0';
      var nextId = _getNextId(lastId ?? '0');
      var id = nextId.toString();
      var codigo = fila[0]?.value?.toString() ?? '';
      var codbarra = fila[1]?.value?.toString() ?? '';
      var descripcion = fila[2]?.value?.toString() ?? '';
      var medida = fila[3]?.value?.toString() ?? '';
      var categoria = fila[4]?.value?.toString() ?? '';
      var precio = fila[5]?.value?.toString() ?? '';
      var stock = fila[6]?.value?.toString() ?? '';
      var conteo = '0';
      var diferencia = "-$stock";
      var lote = fila[7]?.value?.toString() ?? '';
      var numlote = fila[8]?.value?.toString() ?? '';
      var fechapro = fila[9]?.value?.toString() ?? '';
      var fechacad= fila[10]?.value?.toString() ?? '';
      var serie = fila[11]?.value?.toString() ?? '';
      var numserie = fila[12]?.value?.toString() ?? '';
      
      

      final productos = Productos(
          id: double.parse(id).toString(),
          codigo: codigo,
          codbarra: codbarra,
          descripcion: descripcion,
          medida: medida,
          categoria: categoria,
          precio: precio,
          stock: stock,
          conteo: conteo,
          diferencia: diferencia,
          ubicacion: '',
          sububicacion: '',
          lote: lote,
          numlote: numlote,
          fechapro: fechapro,
          fechacad: fechacad,
          serie: serie,
          numserie: numserie,
          tdatos: basedatos);

      await insertarProductos(productos, basedatos);
    }
  }

  double _getNextId(String lastId) {
    var parsedId = double.tryParse(lastId);
    if (parsedId != null) {
      return parsedId + 1;
    }
    return 1;
  }

  Future<void> insertarProductos(Productos prod, String tableName) async {
    Database? mydb = await sqLdb.db;
    await mydb!.insert(tableName, prod.toMap2());
  }

  Future<void> insertarinven(
      String tableName, String selectalmacen, String basedatos) async {
    final SQLdb sqLdb = SQLdb();
    Database? mydb = await sqLdb.db;
    var results = await mydb!.query('inventarios', where: 'activo IS NOT NULL');
    if (results.isNotEmpty) {
      await mydb.update(
        'inventarios',
        {'activo': "CERRADO"},
      );
    }

    var lastRow = await mydb.query('inventarios', orderBy: 'id DESC', limit: 1);
    var lastId = lastRow.isNotEmpty ? lastRow.first['id']?.toString() : '0';
    var nextId = _getNextId(lastId ?? '0');
    var id = nextId.toString();
    nextId++;
    String activotabla = "ABIERTO";
    final fechas = DateTime.now();
    final hoy = DateFormat('yyyy-MM-dd HH:mm:ss').format(fechas);
    final inventarios = Inventarios(
        id: double.parse(id),
        nombre: tableName,
        basedatos: basedatos,
        almacen: selectalmacen,
        activo: activotabla,
        fecha: hoy);
    await insertinventario(inventarios);
  }

  void guardarDatos(
      String tableName, String selectalmacen, File selectedFile) async {
    String tablabasededatos = tableName.trim().replaceAll(' ', '');
    if (tableName.isNotEmpty) {
      await insertarDatosDesdeExcel(selectedFile.path, tablabasededatos);
      await insertarinven(tableName, selectalmacen, tablabasededatos);

      Get.snackbar("Mensaje", "Los datos fueron importados correctamente");
    } else {
      Get.snackbar("Advertencia", "El nombre de la tabla no puede estar vacia");
    }
  }

  Future<void> insertinventario(Inventarios inven) async {
    Database? mydb = await sqLdb.db;
    await mydb!.insert('inventarios', inven.toMap());
  }

  Future<void> convertTableToExcel(
      BuildContext context, String name, String nombretabla) async {
    // Abrir la base de datos SQLite
    final databasePath = await getDatabasesPath();
    final database =
        await openDatabase(path.join(databasePath, 'productos.db'));

    // Leer los datos de la tabla SQLite
    final String? tabla = await funciones.obtenerbasedatos(nombretabla);
    final List<Map<String, dynamic>> tableData = await database.query('$tabla');

    // Crear un nuevo archivo de Excel
    final excel = Excel.createExcel();

    // Crear una hoja de trabajo en el archivo de Excel
    final sheet = excel['Sheet1'];

    // Escribir los encabezados de columna en la hoja de trabajo
    final headers = tableData.first.keys.toList();
    for (var i = 0; i < headers.length; i++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .value = headers[i];
    }

    // Escribir los datos en la hoja de trabajo
    for (var i = 0; i < tableData.length; i++) {
      final row = tableData[i];
      final values = row.values.toList();
      for (var j = 0; j < values.length; j++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1))
            .value = values[j].toString();
      }
    }

    // Mostrar el diálogo de selección de carpeta
    final outputPath = await FilePicker.platform.getDirectoryPath();

    if (outputPath != null) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final documentsPath = documentsDirectory.path;

      // Crear la ruta de salida en la carpeta seleccionada
      final outputDirectory =
          Directory(path.join(documentsPath, 'ExcelOutput'));
      await outputDirectory.create(recursive: true);
      final excelPath = path.join(outputPath, '$name.xlsx');

      // Guardar el archivo de Excel en la carpeta seleccionada
      final excelBytes = excel.encode();
      final excelFile = File(excelPath);
      await excelFile.writeAsBytes(excelBytes!);
      debugPrint('Tabla SQLite convertida a Excel: $excelPath');
      Get.snackbar("Exito", "SE GUARDO EXITOSAMENTE");
    } else {
      debugPrint('No se seleccionó ninguna carpeta.');
    }
  }
}
