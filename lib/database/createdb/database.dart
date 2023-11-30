import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLdb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await inicializacion();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database> inicializacion() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'product.db');
    Database mydb = await openDatabase(path, onCreate: _createDB, version: 1);
    return mydb;
  }

  _createDB(Database db, int version) async {
    await db.execute(
        "CREATE TABLE IF NOT EXISTS usuario (id INTEGER PRIMARY KEY, nombre TEXT, apellido TEXT, email TEXT, pass TEXT)");
    await db.execute(
        'CREATE TABLE IF NOT EXISTS inventarios (id REAL PRIMARY KEY, nombre TEXT,basedatos TEXT, almacen TEXT, activo TEXT,fecha TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS almacenes (id REAL PRIMARY KEY, nombre TEXT)');
    debugPrint(
        "==================base de datos creada =======================");
  }

  Future<bool> insertdata(String sql) async {
    Database? mydb = await db;
    int rep = await mydb!.rawInsert(sql);
    if (rep > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updatedata(String sql) async {
    Database? mydb = await db;
    int rep = await mydb!.rawUpdate(sql);
    if (rep > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deletedata(String sql) async {
    Database? mydb = await db;
    int rep = await mydb!.rawDelete(sql);
    if (rep > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getdata(String sql) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> rep = await mydb!.rawQuery(sql);
    return rep;
  }
}
