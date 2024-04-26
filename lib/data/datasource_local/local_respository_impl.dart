import 'package:inventariosnew/core/enum/data_user.dart';
import 'package:inventariosnew/domain/repository/local_repository_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalRepositoryImpl implements LocalRepositoryInterface {
  @override
  Future<bool> guardarToken({required String authToken}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(DataUser.token.valor, authToken);
  }

  @override
  Future<bool> cerrarsession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final resul = await pref.remove(DataUser.token.valor);
    return resul;
  }

  @override
  Future<String?> usartoken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(DataUser.token.valor);
  }

  @override
  Future<String?> compararfechacad() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("fecha");
  }

  @override
  Future<void> guardarfechacad({required String fechacad}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("fecha", fechacad);
  }

  @override
  Future<void> guardarlicenciasusadas(
      {required List<String> licenciasusadas}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setStringList("licenciasusadas", licenciasusadas);
  }

  @override
  Future<List<String>?> mostrarlaslicencias() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getStringList("licenciasusadas");
  }

  @override
  Future<void> guardaropciondeedit({required bool opcionEdit}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("OpcionEdit", opcionEdit);
  }

  @override
  Future<bool> usarOpcionEdit() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("OpcionEdit") ?? false;
  }
}
