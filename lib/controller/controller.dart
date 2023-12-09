import 'package:get/get.dart';
import 'package:inventarios/connection/function/usertoken.dart';
import 'package:inventarios/database/createdb/database.dart';
import 'package:inventarios/models/productos/almacen.dart';
import 'package:inventarios/settings/token.dart';

class Controller extends GetxController {
  SQLdb funciones = SQLdb();
  TokenGet x = TokenGet();
  RxBool cargando = false.obs;
  RxString imagenPath = "".obs;
  RxString nombreuser = "".obs;
  RxString emailuser = "".obs;
  RxString apellidouser = "".obs;
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
}
