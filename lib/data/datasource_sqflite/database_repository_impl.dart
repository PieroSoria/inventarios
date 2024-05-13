import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventariosnew/domain/model/productos/almacen.dart';
import 'package:inventariosnew/domain/model/productos/inventarios.dart';
import 'package:inventariosnew/domain/model/productos/productos.dart';
import 'package:inventariosnew/domain/model/usuario/userdata.dart';
import 'package:inventariosnew/domain/repository/database_repository_interface.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseRepositoryImpl implements DatabaseRepositoryInterface {
  @override
  Future<Database> iniciarbasededatos() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "product.db");
    Database mydb = await openDatabase(path, onCreate: createDB, version: 1);
    return mydb;
  }

  @override
  createDB(Database db, int version) async {
    await db.execute(
        "CREATE TABLE IF NOT EXISTS usuario (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT, apellido TEXT, email TEXT, pass TEXT,token TEXT,fecha TEXT,ruc TEXT,razonsocial TEXT)");
    await db.execute(
        'CREATE TABLE IF NOT EXISTS inventarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT,basedatos TEXT, almacen TEXT, activo TEXT,fecha TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS almacenes (id INTEGER PRIMARY KEY AUTOINCREMENT, almacen TEXT)');
  }

  @override
  Future<bool> insertalmacen({required Almacenes almacen}) async {
    Database? mydb = await iniciarbasededatos();
    try {
      final result = await mydb.rawQuery(
        'SELECT COUNT(*) AS count FROM almacenes WHERE almacen = ?',
        [almacen.almacen.toString()],
      );
      int count = Sqflite.firstIntValue(result)!;
      if (count == 0) {
        int res = await mydb.rawInsert(
          'INSERT INTO almacenes (almacen) VALUES(?)',
          [
            almacen.almacen.toString(),
          ],
        );
        return res > 0;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Error al insertar en la base de datos: $e");
      return false;
    } finally {
      mydb.close();
    }
  }

  @override
  Future<bool> datoactivo() async {
    Database? mydb = await iniciarbasededatos();
    try {
      List<Map<String, dynamic>> rows = await mydb
          .rawQuery("SELECT * FROM inventarios WHERE activo = 'ABIERTO'");
      return rows.isNotEmpty;
    } catch (e) {
      return false;
    } finally {
      mydb.close();
    }
  }

  @override
  Future<String?> obtenerNombreInventarioActivo(
      {required Database mydb}) async {
    try {
      final rows = await mydb.rawQuery(
        "SELECT basedatos FROM inventarios WHERE activo = 'ABIERTO' LIMIT 1",
      );
      if (rows.isNotEmpty) {
        return rows.first['basedatos'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> obtenerstock({
    required Database mydb,
    required String tabla,
    required String codbarra,
  }) async {
    try {
      final rows = await mydb.rawQuery(
        "SELECT stock_inicial FROM $tabla WHERE codbarra = '$codbarra' LIMIT 1",
      );
      if (rows.isNotEmpty) {
        return rows.first['stock_inicial'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> obtenerconteo(
      {required Database mydb,
      required String tabla,
      required String codbarra}) async {
    try {
      List<Map<String, dynamic>> rows = await mydb.rawQuery(
        "SELECT conteo FROM $tabla WHERE codbarra = '$codbarra' LIMIT 1",
      );
      if (rows.isNotEmpty) {
        return rows.first['conteo'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> obtenerbasedatos({required String tablanombre}) async {
    Database mydb = await iniciarbasededatos();
    try {
      List<Map<String, dynamic>> rows = await mydb.rawQuery(
        "SELECT basedatos FROM inventarios WHERE nombre = '$tablanombre' LIMIT 1",
      );
      if (rows.isNotEmpty) {
        return rows.first['basedatos'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      mydb.close();
    }
  }

  @override
  Future<Productos?> buscarProducto({required String codigoBarra}) async {
    Database mydb = await iniciarbasededatos();
    try {
      String? tabla = await obtenerNombreInventarioActivo(mydb: mydb);
      debugPrint(tabla);
      final result = await mydb.rawQuery(
          'SELECT * FROM $tabla WHERE codbarra = ?', [
        codigoBarra
      ]).then((value) => value.map((e) => Productos.fromMap(e)).first);
      debugPrint("$result");
      return result;
    } catch (e) {
      debugPrint("Error de $e");
      return null;
    } finally {
      mydb.close();
    }
  }

  @override
  Future<bool> actualizarconteo(
      {required String ubicacion,
     
      required String codigoBarra,
      required String conteo}) async {
    Database mydb = await iniciarbasededatos();
    try {
      String? tabla = await obtenerNombreInventarioActivo(mydb: mydb);
      String? stock = await obtenerstock(
        mydb: mydb,
        tabla: tabla!,
        codbarra: codigoBarra,
      );
      String? conteof = await obtenerconteo(
        mydb: mydb,
        tabla: tabla,
        codbarra: codigoBarra,
      );
      int stocksrc = int.parse(stock!);
      int conteoft = int.parse(conteof!);
      int conteo2 = int.parse(conteo);
      int resultado2 = conteoft + conteo2;
      int resultado = resultado2 - stocksrc;
      String resultadof = resultado.toString();
      String resultado2f = resultado2.toString();

      int rep = await mydb.rawUpdate(
          "UPDATE $tabla SET conteo = '$resultado2f', diferencia = '$resultadof',almacen = '$ubicacion' WHERE codbarra = '$codigoBarra'");
      return rep > 0;
    } catch (e) {
      debugPrint("Error de actualizar conteo $e");
      return false;
    } finally {
      mydb.close();
    }
  }

  @override
  Future<bool> sumarconteo(
      {required String almacen,
     
      required String codbarra}) async {
    Database mydb = await iniciarbasededatos();
    try {
      String? tabla = await obtenerNombreInventarioActivo(
        mydb: mydb,
      );
      String? conteo = await obtenerconteo(
        tabla: tabla!,
        codbarra: codbarra,
        mydb: mydb,
      );
      String? stock = await obtenerstock(
        mydb: mydb,
        tabla: tabla,
        codbarra: codbarra,
      );

      int resultado = int.parse(conteo!) + 1;
      String resultadof = resultado.toString();
      int diferencia = resultado - int.parse(stock!);
      String diferenciaf = diferencia.toString();
      int rep = await mydb.rawUpdate(
          'UPDATE $tabla SET conteo = ?, diferencia = ?, almacen = ? WHERE codbarra = ?',
          [
            resultadof,
            diferenciaf,
            almacen,
          
            codbarra,
          ]);
      return rep > 0;
    } catch (e) {
      debugPrint("Error al sumar conteo $e");
      return false;
    } finally {
      mydb.close();
    }
  }

  @override
  Future<List<Productos>> getdataProductobyDatabase(
      {required String query}) async {
    Database mydb = await iniciarbasededatos();
    try {
      final data = await mydb.rawQuery(query).then((value) {
        List<Productos> result =
            value.map((e) => Productos.fromMap(e)).toList();
        return result;
      });
      return data;
    } catch (e) {
      return [];
    } finally {
      mydb.close();
    }
  }

  @override
  Future<bool> updatedata(
      {required String query, required List<String> arguments}) async {
    Database mydb = await iniciarbasededatos();
    try {
      final result = await mydb.rawUpdate(query, arguments);
      return result > 0;
    } catch (e) {
      return false;
    } finally {
      mydb.close();
    }
  }

  @override
  Future<bool> deletedatabyid(
      {required String tabla, required String? id}) async {
    Database mydb = await iniciarbasededatos();
    try {
      if (id != null) {
        final result =
            await mydb.delete(tabla, where: 'id = ?', whereArgs: [id]);
        return result > 0;
      } else {
        await mydb.execute("DROP TABLE IF EXISTS $tabla");
        return true;
      }
    } catch (e) {
      debugPrint("Error al borrar datos $e");
      return false;
    } finally {
      mydb.close();
    }
  }

  @override
  Future<bool> cerrarinventario() async {
    Database? mydb = await iniciarbasededatos();
    try {
      int? rep = await mydb.update(
        'inventarios',
        {'activo': "CERRADO"},
      );
      return rep > 0;
    } catch (e) {
      return false;
    } finally {
      mydb.close();
    }
  }

  @override
  Future<bool> checkTableExists(
      {required String tableName, required Database mydb}) async {
    try {
      var table = await mydb.query(
        'sqlite_master',
        where: 'type = ? AND name = ?',
        whereArgs: ['table', tableName],
      );
      return table.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> insertarDatos({
    required List<List<dynamic>> data,
    required String basedatos,
  }) async {
    Database mydb = await iniciarbasededatos();
    try {
      var tableExists =
          await checkTableExists(tableName: basedatos, mydb: mydb);
      if (!tableExists) {
        await mydb.execute('''
      CREATE TABLE $basedatos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        codbarra TEXT,
        producto TEXT,
        almacen TEXT,
        medida TEXT,
        categoria TEXT,
        precio TEXT,
        stock_inicial TEXT,
        conteo TEXT,
        diferencia TEXT,
        tipoproducto TEXT,
        valor TEXT,
        fecha_pro TEXT,
        fecha_cad TEXT,
        comentario TEXT,
        tdatos TEXT
      )
    ''');
      }

      for (var fila in data) {
        final productos = Productos(
            id: "",
            codbarra: fila[0]?.value?.toString() ?? '',
            producto: fila[1]?.value?.toString() ?? '',
            almacen: fila[2]?.value?.toString() ?? '',
            medida: fila[3]?.value?.toString() ?? '',
            categoria: fila[4]?.value?.toString() ?? '',
            precio: fila[5]?.value?.toString() ?? '',
            stock: fila[6]?.value?.toString() ?? '',
            conteo: fila[7]?.value?.toString() ?? '',
            diferencia: "-${fila[7]?.value?.toString() ?? ''}",
            tipoproducto: fila[8]?.value?.toString() ?? '',
            valor: fila[9]?.value?.toString() ?? '',
            fechapro: fila[10]?.value?.toString() ?? '',
            fechacad: fila[11]?.value?.toString() ?? '',
            comentario: fila[12]?.value?.toString() ?? '',
            tdatos: basedatos);

        await insertarProductos(
          prod: productos,
          tableName: basedatos,
        );
      }
    } catch (e) {
      debugPrint("Error de insertar producto $e");
    } finally {
      mydb.close();
    }
  }

  @override
  Future<bool> insertarProductos({
    required Productos prod,
    required String tableName,
  }) async {
    Database mydb = await iniciarbasededatos();
    try {
      final result = await mydb.rawInsert('''INSERT INTO $tableName(
        codbarra,
        producto,
        almacen,
        medida,
        categoria,
        precio,
        stock_inicial,
        conteo,
        diferencia,
        tipoproducto ,
        valor ,
        fecha_pro ,
        fecha_cad ,
        comentario ,
        tdatos ) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)''', [
        prod.codbarra,
        prod.producto,
        prod.almacen,
        prod.medida,
        prod.categoria,
        prod.precio,
        prod.stock,
        prod.conteo,
        prod.diferencia,
        prod.tipoproducto,
        prod.valor,
        prod.fechapro,
        prod.fechacad,
        prod.comentario,
        prod.tdatos
      ]);
      return result > 0;
    } catch (e) {
      debugPrint("Error de insertarproducto: $e");
      return false;
    } finally {
      mydb.close();
    }
  }

  @override
  Future<void> insertarinven(
      {required String tableName,
      required String selectalmacen,
      required String basedatos}) async {
    Database mydb = await iniciarbasededatos();
    try {
      var results =
          await mydb.query('inventarios', where: 'activo IS NOT NULL');
      if (results.isNotEmpty) {
        await mydb.update(
          'inventarios',
          {'activo': "CERRADO"},
        );
      }
      String activotabla = "ABIERTO";
      final fechas = DateTime.now();
      final hoy = DateFormat('yyyy-MM-dd HH:mm:ss').format(fechas);
      final inventarios = Inventarios(
          id: "",
          nombre: tableName,
          basedatos: basedatos,
          almacen: selectalmacen,
          activo: activotabla,
          fecha: hoy);
      await insertinventario(inventarios);
    } catch (e) {
      debugPrint("Error de sistema $e");
    } finally {
      mydb.close();
    }
  }

  Future<bool> insertinventario(Inventarios inven) async {
    Database mydb = await iniciarbasededatos();
    try {
      final result = await mydb.rawInsert(
        'INSERT INTO inventarios(nombre,basedatos,almacen,activo,fecha) VALUES(?,?,?,?,?)',
        [
          inven.nombre,
          inven.basedatos,
          inven.almacen,
          inven.activo,
          inven.fecha
        ],
      );
      return result > 0;
    } catch (e) {
      return false;
    } finally {
      mydb.close();
    }
  }

  @override
  Future<List<Inventarios>> getdataInventariobyDatabase(
      {required String query}) async {
    Database mydb = await iniciarbasededatos();
    try {
      final result = await mydb.rawQuery(query).then(
            (value) => value.map((e) => Inventarios.fromMap(e)).toList(),
          );
      return result;
    } catch (e) {
      return [];
    } finally {
      mydb.close();
    }
  }

  @override
  Future<List<Map<String, dynamic>>> queryDatabase(
      {required String table}) async {
    Database mydb = await iniciarbasededatos();
    try {
      final result = await mydb.query(table);
      return result;
    } catch (e) {
      return [];
    } finally {
      mydb.close();
    }
  }

  @override
  Future<List<Productos>> cargarDatosInventarios({
    required String? searchTerm,
    required String? almacen,
   
  }) async {
    Database mydb = await iniciarbasededatos();
    try {
      List<Productos> result = [];
      List<Map<String, Object?>> inventarios =
          await mydb.query('inventarios', columns: ['basedatos']);

      List<String> nombresBasesDeDatos =
          inventarios.map((e) => e['basedatos'] as String).toList();
      debugPrint(nombresBasesDeDatos.toString());

      for (String nombreBaseDatos in nombresBasesDeDatos) {
        List<Map<String, dynamic>> datosTabla =
            await mydb.query(nombreBaseDatos);
        List<Productos> productos =
            datosTabla.map((e) => Productos.fromMap(e)).toList();

        if (searchTerm != null && searchTerm.isNotEmpty) {
          productos = productos
              .where((producto) =>
                  producto.producto
                      .toLowerCase()
                      .contains(searchTerm.toLowerCase()) ||
                  producto.codbarra
                      .toLowerCase()
                      .contains(searchTerm.toLowerCase()))
              .toList();
        } else if (almacen != null) {
          productos = productos
              .where(
                (producto) => producto.almacen.toLowerCase().contains(almacen),
              )
              .toList();
        } 
        result.addAll(productos);
      }
      return result;
    } catch (e) {
      debugPrint("Error $e");
      return [];
    } finally {
      mydb.close();
    }
  }

  @override
  Future<List<Almacenes>> cargardatosdealmacen() async {
    Database mydb = await iniciarbasededatos();
    try {
      final result = await mydb
          .query('almacenes')
          .then((value) => value.map((e) => Almacenes.fromMap(e)).toList());
      return result;
    } catch (e) {
      debugPrint("Error del almacen $e");
      return [];
    } finally {
      mydb.close();
    }
  }

  @override
  Future<UserData?> iniciarSessionLogin(
      {required String email, required String password}) async {
    Database mydb = await iniciarbasededatos();
    try {
      final result = await mydb
          .query('usuario',
              columns: ['*'],
              where: 'email = ? and pass = ?',
              whereArgs: [email, password])
          .then((value) => value.map((e) => UserData.fromMap(e)).toList());
      return result.first;
    } catch (e) {
      return null;
    } finally {
      mydb.close();
    }
  }

  @override
  Future<bool> registrarsesession({
    required UserData userdata,
  }) async {
    Database mydb = await iniciarbasededatos();
    try {
      final datause = userdata.tomap();
      final result = await mydb.insert('usuario', datause);
      return result > 0;
    } catch (e) {
      return false;
    } finally {
      mydb.close();
    }
  }

  @override
  Future<String?> obtenernombredelinventarioactivomydb() async {
    Database mydb = await iniciarbasededatos();
    try {
      final result = await obtenerNombreInventarioActivo(mydb: mydb);
      return result;
    } catch (e) {
      return null;
    } finally {
      mydb.close();
    }
  }

  @override
  Future<bool> cantidaddeusuario() async {
    Database mydb = await iniciarbasededatos();
    try {
      int? count = Sqflite.firstIntValue(
          await mydb.rawQuery('SELECT COUNT(*) FROM usuario'));
      return count == 0;
    } catch (e) {
      return false;
    } finally {
      mydb.close();
    }
  }

  @override
  Future<bool> cambiarfechacad({required String nuevafecha}) async {
    Database mydb = await iniciarbasededatos();
    try {
      final result = await mydb.rawUpdate(
        'UPDATE usuario SET fecha = ?, WHERE id = ?',
        [nuevafecha, 1],
      );
      return result > 0;
    } catch (e) {
      debugPrint("Error de cambiar fecha $e");
      return false;
    } finally {
      mydb.close();
    }
  }

  @override
  Future<List<String>> listadelamacenes() async {
    Database mydb = await iniciarbasededatos();
    try {
      final result = await mydb.query(
        'almacenes',
        columns: ['almacen'],
      ).then((value) {
        final data =
            value.map((e) => Almacenes.fromMap(e).almacen.toString()).toList();
        return data;
      });
      return result;
    } catch (e) {
      return [];
    } finally {
      mydb.close();
    }
  }

  @override
  Future<int?> verificarlainsertcionubicacion() async {
    Database mydb = await iniciarbasededatos();
    try {
      final almacenCount = Sqflite.firstIntValue(
          await mydb.rawQuery('SELECT COUNT(DISTINCT almacen) FROM almacenes'));
      final subalmacenByAlmacenCount = Sqflite.firstIntValue(await mydb.rawQuery(
          'SELECT COUNT(DISTINCT subalmacen) FROM almacenes GROUP BY almacen'));
      if (almacenCount == 1 && subalmacenByAlmacenCount == 1) {
        return 1;
      } else if (almacenCount == 1 && subalmacenByAlmacenCount! > 1) {
        return 2;
      } else {
        return 3;
      }
    } catch (e) {
      debugPrint("Error de verificacion: $e");
      return null;
    } finally {
      mydb.close();
    }
  }

  @override
  Future<String?> querydata({
    required String tabla,
    required String columna,
    required String? where,
  }) async {
    Database mydb = await iniciarbasededatos();
    try {
      if (where != null) {
        final result = await mydb
            .query(tabla,
                columns: [columna], where: 'almacen = ?', whereArgs: [where])
            .then((value) =>
                value.map((e) => Almacenes.fromMap(e)).first.toString());
        return result;
      } else {
        final result = await mydb.query(tabla, columns: [columna]).then(
            (value) => value
                .map((e) => Almacenes.fromMap(e).almacen)
                .first
                .toString());
        return result;
      }
    } catch (e) {
      return null;
    } finally {
      mydb.close();
    }
  }
}
