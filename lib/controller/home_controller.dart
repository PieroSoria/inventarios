import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/core/routes/routes.dart';
import 'package:inventariosnew/domain/model/usuario/userdata.dart';
import 'package:inventariosnew/domain/repository/database_repository_interface.dart';
import 'package:inventariosnew/domain/repository/local_repository_interface.dart';
import 'package:rive/rive.dart';

class HomeController extends GetxController {
  final DatabaseRepositoryInterface databaseRepositoryInterface;
  final LocalRepositoryInterface localRepositoryInterface;
  HomeController({
    required this.databaseRepositoryInterface,
    required this.localRepositoryInterface,
  });
  var loginanregis = false.obs;
  var issigndialogo = false.obs;
  var cargando = false.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  final nombre = TextEditingController();
  final apellido = TextEditingController();
  final ruc = TextEditingController();
  final razonsocial = TextEditingController();
  final licencia = TextEditingController();
  late RiveAnimationController btnAnimationController;

  @override
  void onInit() {
    btnAnimationController = OneShotAnimation('active', autoplay: false);
    super.onInit();
  }

  Future<void> iniciarSession() async {
    final result = await databaseRepositoryInterface.iniciarSessionLogin(
        email: email.text, password: password.text);

    if (result != null) {
      await localRepositoryInterface.guardarToken(authToken: result.token);
      Get.toNamed(Routes.index);
    } else {
      Get.snackbar("Opps!", "No se encontro el usuario");
    }
  }

  Future<void> registrarse() async {
    DateTime fechaActual = DateTime.now();
    DateTime fechaTresMesesDespues = fechaActual.add(
      const Duration(days: 3 * 30),
    );
    final canusu = await databaseRepositoryInterface.cantidaddeusuario();
    if (canusu) {
      await localRepositoryInterface.guardarfechacad(
          fechacad: fechaTresMesesDespues.toString());
      var bytes = utf8.encode(
          "${nombre.text}/${apellido.text}/${email.text}/${password.text}");

      var token = sha256.convert(bytes);
      final data = UserData(
        nombre: nombre.text,
        apellido: apellido.text,
        email: email.text,
        pass: password.text,
        token: token.toString(),
        fechacad: fechaTresMesesDespues.toString(),
        ruc: ruc.text,
        razonSocial: razonsocial.text,
      );
      bool result =
          await databaseRepositoryInterface.registrarsesession(userdata: data);
      if (result) {
        loginanregis(false);
        email.clear();
        password.clear();
        nombre.clear();
        apellido.clear();
        ruc.clear();
        razonsocial.clear();
        Get.snackbar("Exito", "Se registro correctamente");
      } else {
        Get.snackbar("Opps!", "No se Pudo registrar");
      }
    } else {
      Get.snackbar("Opps!", "Ya no se puede Registrar");
    }
  }

  Future<void> cargarlicencia() async {
    List<String> licencias = [
      "7PmQa8kXtWz5yFvNcB3hE6sUgR2dJ4lI9oP1qA0rSjVxGmC",
      "H3gU7sQbVtYrJmP1a0nS4dF6oG9lB2hE8xKcWzI5jRqXvNfT",
      "M8dS2fP6jQ0lO4rK1iU9yC3tZ7gXvB5hEaNwD8zFbVqGmHxR",
      "T5zY7cW9vF0bN3mH1xR6qP8lJ2kA4gEoDfSdVjIuXrCpG6hB",
      "K8qWzJ6lC9hP2oR5kV7cB1fD4uG3xS0vNjEaIyMmTbXrA5gU",
      "D1rK7xG0fC5bQ3tV9sP2lN6cA8oE4dWzXmYjIuHgRvBnFqS",
      "5uM4nH1lI8pR2oT9qF3sG7vB5cX6dJ0kA1mW8zEaNyVbUg",
      "G3kL8hN2vU7qX1zA5fD6rP4wB0oJ9sCmYiVtSxTgM7eRnF",
      "4sW3qN8fJ5oG7tK1rM0iA9vS6xV2cDzEhYbTlPjXyRgB6u",
      "F6sZ3nK7cB5mV8hP2aG0jI4tY9dQ1xRwEoLzUvNqMgS1rT"
    ];

    String textoLicencia = licencia.text;

    final licenciausada = await localRepositoryInterface.mostrarlaslicencias();

    if (licencias.contains(textoLicencia) &&
        !licenciausada!.contains(textoLicencia)) {
      licenciausada.add(textoLicencia);
      await localRepositoryInterface.guardarlicenciasusadas(
          licenciasusadas: licenciausada);
      DateTime fechaActual = DateTime.now();
      DateTime fechanueva = fechaActual.add(
        const Duration(days: 365),
      );
      await databaseRepositoryInterface.cambiarfechacad(
          nuevafecha: fechanueva.toString());
      licencia.clear();
      Get.snackbar(
        "Exito",
        "Ya puede ingresar denuevo a tu inicio de sesison",
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
    } else {
      Get.snackbar(
        "Licencia Usada",
        "La licencia ya ha sido utilizada",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
