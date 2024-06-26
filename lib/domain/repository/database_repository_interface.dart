import 'package:inventariosnew/domain/model/productos/almacen.dart';
import 'package:inventariosnew/domain/model/productos/inventarios.dart';
import 'package:inventariosnew/domain/model/productos/productos.dart';
import 'package:inventariosnew/domain/model/usuario/userdata.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseRepositoryInterface {
  Future<Database> iniciarbasededatos();
  createDB(Database db, int version);
  Future<Productos?> buscarProducto(
      {required String codigoBarra, required String almacen});
  Future<String?> obtenerbasedatos({required String tablanombre});
  Future<bool> insertalmacen({required Almacenes almacen});
  Future<bool> actualizarconteo({
    required String xalmacen,
    required String codigoBarra,
    required String conteo,
    required String comentario,
    required String fechapro,
    required String fechacad,
    required String valor,
  });
  Future<bool> sumarconteo({
    required String almacen,
    required String codbarra,
    required String comentario,
    required String fechapro,
    required String fechacad,
    required String valor,
  });
  Future<String?> obtenerconteo({
    required Database mydb,
    required String tabla,
    required String codbarra,
    required String almacen,
  });
  Future<bool> datoactivo();
  Future<String?> obtenerNombreInventarioActivo({required Database mydb});
  Future<String?> obtenerstock({
    required Database mydb,
    required String tabla,
    required String codbarra,
    required String almacen,
  });
  Future<List<Productos>> getdataProductobyDatabase({required String query});
  Future<bool> updatedata(
      {required String query, required List<String> arguments});
  Future<bool> cerrarinventario();
  Future<bool> checkTableExists(
      {required String tableName, required Database mydb});
  Future<void> insertarinven(
      {required String tableName,
      required String selectalmacen,
      required String basedatos});
  Future<void> insertarDatos({
    required List<List<dynamic>> data,
    required String basedatos,
  });
  Future<bool> insertarProductos({
    required Productos prod,
    required String tableName,
  });
  Future<List<Inventarios>> getdataInventariobyDatabase(
      {required String query});
  Future<List<Map<String, dynamic>>> queryDatabase({required String table});
  Future<bool> deletedatabyid({required String tabla, required String? id});
  Future<List<Productos>> cargarDatosInventarios({
    required String? searchTerm,
    required String? almacen,
  });
  Future<List<Almacenes>> cargardatosdealmacen();
  Future<UserData?> iniciarSessionLogin({
    required String email,
    required String password,
  });
  Future<bool> registrarsesession({
    required UserData userdata,
  });
  Future<String?> obtenernombredelinventarioactivomydb();
  Future<bool> cantidaddeusuario();
  Future<bool> cambiarfechacad({required String nuevafecha});
  Future<List<String>> listadelamacenes();
  Future<int?> verificarlainsertcionubicacion();
  Future<String?> querydata(
      {required String tabla, required String columna, required String? where});
}
