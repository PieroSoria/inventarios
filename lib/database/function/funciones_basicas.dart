import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/controller/controller.dart';
import 'package:inventarios/database/createdb/database.dart';
import 'package:inventarios/models/productos/productos.dart';
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

  // Future<List<String>> captureData(
  //     String tabla, String columna, String itempri, String? where) async {
  //   Database? mydb = await funciones.db;
  //   if (where != null) {
  //     List<Map> result = await mydb!
  //         .query(tabla, columns: [columna], where: "ubicacion = '$where'");
  //     Set<String> nombres = {itempri};
  //     for (var item in result) {
  //       nombres.add(item[columna]);
  //     }
  //     return nombres.toList();
  //   } else {
  //     List<Map> result = await mydb!.query(tabla, columns: [columna]);
  //     Set<String> nombres = {itempri};
  //     for (var item in result) {
  //       nombres.add(item[columna]);
  //     }
  //     return nombres.toList();
  //   }
  // }

  Future<List<String>> captureData(
      String tabla, String columna, String itempri, String? where) async {
    Database? mydb = await funciones.db;
    Set<String> nombres = {itempri};
    if (mydb != null) {
      List<Map<String, dynamic>> result;
      if (where != null) {
        result = await mydb.query(tabla,
            columns: [columna], where: "ubicacion = '$where'");
      } else {
        result = await mydb.query(tabla, columns: [columna]);
      }
      for (var item in result) {
        nombres.add(item[columna].toString());
      }
    }
    return nombres.toList();
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
    debugPrint("Es $rows");
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

  Future<void> buscarProducto(String codigoBarra) async {
    String? tabla = await obtenerNombreInventarioActivo();
    final controller = Get.put(Controller());
    final query = 'SELECT * FROM $tabla WHERE codbarra = ?';
    final result = await rawQuery(query, [codigoBarra]);

    controller.resultbus
        .assignAll(result.map((e) => Productos.fromMap(e)).toList());
  }

  Future<bool> actualizarconteo(String ubicacion, String sububicacion,
      String codigoBarra, String conteo) async {
    String? tabla = await obtenerNombreInventarioActivo();
    debugPrint("Es $codigoBarra");
    debugPrint("Es $tabla");
    String? stock = await obtenerstock(tabla!, codigoBarra);
    debugPrint("Es $stock");
    String? conteof = await obtenerconteo(tabla, codigoBarra);
    int stocksrc = int.parse(stock!);
    int conteoft = int.parse(conteof!);
    int conteo2 = int.parse(conteo);
    int resultado2 = conteoft + conteo2;
    int resultado = resultado2 - stocksrc;
    String resultadof = resultado.toString();
    String resultado2f = resultado2.toString();

    bool rep = await funciones.updatedata(
        "UPDATE $tabla SET conteo = '$resultado2f', diferencia = '$resultadof',ubicacion = '$ubicacion',sububicacion = '$sububicacion' WHERE codbarra = '$codigoBarra'");
    if (rep) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> sumarconteo(
      String ubicacion, String sububicacion, String codbarra) async {
    String? tabla = await obtenerNombreInventarioActivo();
    String? conteo = await obtenerconteo(tabla!, codbarra);
    String? stock = await obtenerstock(tabla, codbarra);
    // int stocknum = int.parse(stock!);
    // int conteof = int.parse(conteo!);
    int resultado = int.parse(conteo!) + 1;
    String resultadof = resultado.toString();
    int diferencia = resultado - int.parse(stock!);
    String diferenciaf = diferencia.toString();
    bool rep = await funciones.updatedata(
        "UPDATE $tabla SET conteo = '$resultadof', diferencia = '$diferenciaf', ubicacion = '$ubicacion', sububicacion = '$sububicacion' WHERE codbarra = '$codbarra'");
    if (rep) {
      Get.snackbar("Exito", "Se actualizo correctamente");
    }
    buscarProducto(codbarra);
  }
}
