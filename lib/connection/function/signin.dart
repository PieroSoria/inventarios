import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:inventarios/connection/URL/url_direcction.dart';
import 'package:inventarios/connection/dominio/dominio.dart';
import 'package:inventarios/models/usuario/userdata.dart';
import 'package:inventarios/settings/token.dart';

TokenGet tokenfuncion = TokenGet();

Future<bool> signinwithemailandpassword(UserData data) async {
  var cliente = http.Client();
  try {
    var url = Uri.https(UrlDominio.urldominio1, UrlDirection.signin);
    var response =
        await http.post(url, body: {'email': data.email, 'pass': data.pass});

    debugPrint(response.body);

    if (response.statusCode == 200) {
      var responseInfo = json.decode(response.body);

      if (responseInfo is List && responseInfo.isNotEmpty) {
        Get.snackbar("Success", "Inicio de sesión exitoso");
        debugPrint("ID: ${responseInfo[0]['id']}");
        debugPrint("token: ${responseInfo[0]['token']}");
        tokenfuncion.guardartoken("${responseInfo[0]['token']}");
        return true;
      } else if (responseInfo[0].containsKey('mensaje')) {
        Get.snackbar("Error", "${responseInfo[0]['mensaje']}");
        return false;
      }
    } else {
      Get.snackbar("Error", "El usuario es invalido");
      return false;
    }
  } catch (e) {
    Get.snackbar("Error", "Error en la comunicación con el servidor");
  } finally {
    cliente.close();
  }

  return false;
}
