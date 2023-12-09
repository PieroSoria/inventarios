import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:inventarios/connection/URL/url_direcction.dart';
import 'package:inventarios/connection/dominio/dominio.dart';
import 'package:inventarios/models/usuario/userdata.dart';
import 'package:inventarios/settings/token.dart';

TokenGet funciones = TokenGet();

Future<ResponsyUserData> mostrarDato() async {
  String token = await funciones.usartoken();

  if (token.isNotEmpty) {
    var cliente = http.Client();

    try {
      var url = Uri.https(UrlDominio.urldominio1, UrlDirection.token);
      var response = await http.post(url, body: {'token': token});

      if (response.statusCode == 200) {
        debugPrint("Respuesta del servidor: ${response.body}");
        var responseInfo = json.decode(response.body);

        if (responseInfo is List && responseInfo.isNotEmpty) {
          final data = UserData(
            nombre: '${responseInfo[0]['nombre']}',
            apellido: '${responseInfo[0]['apellido']}',
            email: '${responseInfo[0]['email']}',
            pass: '${responseInfo[0]['pass']}',
            token: '${responseInfo[0]['token']}',
          );

          debugPrint(responseInfo.toString());
          return ResponsyUserData(data, null);
        } else if (responseInfo.isNotEmpty &&
            responseInfo[0].containsKey('mensaje')) {
          Get.snackbar("Error", "${responseInfo[0]['mensaje']}");
        }
      } else {
        Get.snackbar("Error", "Error de red: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error: $e");
      return ResponsyUserData(null, "El error es: $e");
    } finally {
      cliente.close();
    }
  }

  return ResponsyUserData(null, null);
}

Future<void> iniciarsessionportoken() async {}
