import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/usuario/userdata.dart';
import '../URL/url_direcction.dart';
import '../dominio/dominio.dart';

Future<bool> signupwithemailandpassword(UserData data) async {
  var cliente = http.Client();
  try {
    var url = Uri.https(UrlDominio.urldominio1, UrlDirection.signup);
    var response = await http.post(url, body: {
      'nombre': data.nombre,
      'apellido': data.apellido,
      'email': data.email,
      'pass': data.pass
    });

    debugPrint(response.body); 

    var responseInfo = json.decode(response.body);

    if (responseInfo != null && responseInfo.containsKey('mensaje')) {
      if (responseInfo['mensaje'] == 'Registro exitoso') {
        Get.snackbar("Success", "Registro exitoso");
        return true;
      } else {
        Get.snackbar("Error", responseInfo['mensaje']);
        return false;
      }
    } else {
      // Manejar caso inesperado
      Get.snackbar("Error", "Error inesperado en la respuesta del servidor");
      return false;
    }
  } catch (e) {
    // Manejar errores de red u otras excepciones
    Get.snackbar("Error", "Error en la comunicación con el servidor $e");
    return false;
  } finally {
    cliente.close();
  }
}
