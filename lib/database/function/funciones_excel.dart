import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/productos/inventarios.dart';
import '../../models/productos/productos.dart';
import '../createdb/database.dart';

class ExcelFuncion {
  SQLdb sqLdb = SQLdb();
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

      return rows;
    } catch (e, stackTrace) {
      debugPrint("Error al leer el archivo Excel: $e");
      debugPrint("StackTrace: $stackTrace");
      // Puedes manejar la excepción de manera adecuada aquí
      // Por ejemplo, puedes devolver una lista vacía en caso de error
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
        diferencia TEXT
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
          diferencia: diferencia);

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
}
