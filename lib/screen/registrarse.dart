import 'package:flutter/material.dart';
import 'package:inventariosnew/controller/home_controller.dart';
import '../../components/input_form.dart';

class Registrar extends StatelessWidget {
  final HomeController controller;
  const Registrar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registrar Usuario',
          style: TextStyle(fontFamily: "Poppins", fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomInputField(
                controller: controller.nombre,
                label: "Nombre completo",
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "El nombre no puede estar vacío";
                  } else if (RegExp(r'[0-9!@#%^&*(),.?":{}|<>]')
                      .hasMatch(text)) {
                    return "El nombre no puede contener números ni símbolos";
                  }
                  return null;
                },
                icon: const Icon(Icons.person),
                color: Colors.black,
              ),
              CustomInputField(
                controller: controller.apellido,
                label: "Apellido completo",
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "El apellido no puede estar vacío";
                  } else if (RegExp(r'[0-9!@#%^&*(),.?":{}|<>]')
                      .hasMatch(text)) {
                    return "El apellido no puede contener números ni símbolos";
                  }
                  return null;
                },
                icon: const Icon(Icons.person),
                color: Colors.black,
              ),
              CustomInputField(
                controller: controller.email,
                label: "Usuario",
                inputType: TextInputType.emailAddress,
                validator: (text) {
                  if (text == null) return null;
                  if (text.contains("@")) {
                    return null;
                  }
                  return "Invalid email address";
                },
                icon: const Icon(Icons.email),
                color: Colors.black,
              ),
              CustomInputField(
                controller: controller.password,
                label: "Contraseña",
                ispassword: true,
                validator: (text) {
                  if (text!.length < 8) {
                    return "La contraseña es muy corta";
                  }

                  if (text.isEmpty) {
                    return "La contraseña no puede ser vacio";
                  }
                  return null;
                },
                icon: const Icon(Icons.lock),
                color: Colors.black,
              ),
              CustomInputField(
                controller: controller.ruc,
                label: "Ruc",
                ispassword: false,
                validator: (text) {
                  if (text!.isEmpty) {
                    return "El Ruc no puede ser vacio";
                  }
                  return null;
                },
                icon: const Icon(Icons.numbers),
                color: Colors.black,
              ),
              CustomInputField(
                controller: controller.razonsocial,
                label: "Razon Social",
                ispassword: false,
                validator: (text) {
                  if (text!.isEmpty) {
                    return "La Razon Social no puede ser vacio";
                  }
                  return null;
                },
                icon: const Icon(Icons.home_work_outlined),
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ElevatedButton(
                  onPressed: () async {
                    controller.registrarse();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: controller.cargando.value == false
                      ? const Text(
                          "Crear Usuario",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                          ),
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
