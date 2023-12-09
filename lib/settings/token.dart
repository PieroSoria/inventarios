import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenGet {
  Future<bool> guardartoken(String token) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("tokenuser", token);
      return true;
    } catch (e) {
      debugPrint("Error al guardar el token: $e");
      return false;
    }
  }

  Future<String> usartoken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final tokenuse = pref.getString("tokenuser") ?? "";
    return tokenuse;
  }
}
