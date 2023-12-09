import 'package:shared_preferences/shared_preferences.dart';

class TokenGet {
  void guardartoken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("tokenuser", token);
  }

  Future<String> usartoken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final tokenuse = pref.getString("tokenuser") ?? "";
    return tokenuse;
  }
}
