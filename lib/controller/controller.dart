import 'package:get/get.dart';
import 'package:inventarios/database/createdb/database.dart';
import 'package:inventarios/models/productos/almacen.dart';

class Controller extends GetxController {
  SQLdb funciones = SQLdb();
  RxBool cargando = false.obs;
  RxString imagenPath = "".obs;
  RxBool loginanregis = false.obs;
  RxList<Almacenes> almacenes = <Almacenes>[].obs;

  Future<void> getAllProducts({String? searchText}) async {
    String query = "SELECT * FROM almacenes";
    if (searchText != null && searchText.isNotEmpty) {
      query += " WHERE nombre LIKE '%$searchText%'";
    }
    List<Map<String, dynamic>> products = await funciones.getdata(query);
    almacenes.assignAll(
      products.map((map) => Almacenes.fromMap(map)).toList(),
    );
  }
}
