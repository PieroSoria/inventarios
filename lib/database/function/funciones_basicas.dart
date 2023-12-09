import 'package:flutter/material.dart';
import 'package:inventarios/database/createdb/database.dart';
import 'package:inventarios/models/productos/ubicacioneslet.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/productos/almacen.dart';

class FuncionesBasic {
  SQLdb funciones = SQLdb();

  Future<List<Map>> getData(String sql) async {
    Database? mydb = await funciones.db;
    List<Map> rep = await mydb!.rawQuery(sql);
    return rep;
  }

  Future<bool> insertalmacen(Almacenes almacen) async {
    try {
      Database? mydb = await funciones.db;
      await mydb!.insert('almacenes', almacen.tomap());
      return true;
    } catch (e) {
      debugPrint("Error al insertar en la base de datos: $e");
      return false;
    }
  }
  Future<bool> insertubicacion(Ubicacioneslet ubi) async {
    try {
      Database? mydb = await funciones.db;
      await mydb!.insert('ubicaciones', ubi.toMap3());
      return true;
    } catch (e) {
      debugPrint("Error al insertar en la base de datos: $e");
      return false;
    }
  }

  Future<double> getNext3(String table) async {
    Database? mydb = await funciones.db;
    final List<Map<String, dynamic>> result = await mydb!.query(
      table,
      columns: ['id'],
      orderBy: 'id DESC',
      limit: 1,
    );
    if (result.isNotEmpty) {
      final double lastId = result[0]['id'];
      return lastId + 1;
    } else {
      return 1;
    }
  }

  Future<bool> datoactivo() async {
    Database? mydb = await funciones.db;
    List<Map<String, dynamic>> rows = await mydb!
        .rawQuery("SELECT * FROM inventarios WHERE activo = 'ABIERTO'");
    return rows.isNotEmpty;
  }

  Future<List<String>> captureData() async {
    Database? mydb = await funciones.db;
    List<Map> result = await mydb!.query('almacenes', columns: ['nombre']);
    List<String> nombres = [];
    nombres.add("SELECCIONAR ALMACEN");
    for (var item in result) {
      nombres.add(item['nombre']);
    }
    return nombres;
  }

  Future<String?> obtenerNombreInventarioActivo() async {
    Database? mydb = await funciones.db;
    List<Map<String, dynamic>> rows = await mydb!.rawQuery(
      "SELECT basedatos FROM inventarios WHERE activo = 'ABIERTO' LIMIT 1",
    );
    if (rows.isNotEmpty) {
      return rows.first['basedatos'] as String?;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> rawQuery(String query,
      [List<dynamic>? arguments]) async {
    Database? mydb = await funciones.db;
    return mydb!.rawQuery(query, arguments);
  }

  Future<String?> obtenerstock(String tabla, String codbarra) async {
    Database? mydb = await funciones.db;
    List<Map<String, dynamic>> rows = await mydb!.rawQuery(
      "SELECT stock_inicial FROM $tabla WHERE codbarra = '$codbarra' LIMIT 1",
    );
    if (rows.isNotEmpty) {
      return rows.first['stock_inicial'] as String?;
    }
    return null;
  }

  Future<String?> obtenerconteo(String tabla, String codbarra) async {
    Database? mydb = await funciones.db;
    List<Map<String, dynamic>> rows = await mydb!.rawQuery(
      "SELECT conteo FROM $tabla WHERE codbarra = '$codbarra' LIMIT 1",
    );
    if (rows.isNotEmpty) {
      return rows.first['conteo'] as String?;
    }
    return null;
  }

  Future<String?> obtenerbasedatos(String tablanombre) async {
    Database? mydb = await funciones.db;
    List<Map<String, dynamic>> rows = await mydb!.rawQuery(
      "SELECT basedatos FROM inventarios WHERE nombre = '$tablanombre' LIMIT 1",
    );
    if (rows.isNotEmpty) {
      return rows.first['basedatos'] as String?;
    }
    return null;
  }
}
