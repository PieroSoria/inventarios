import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/connection/function/signup.dart';
import 'package:inventarios/models/usuario/userdata.dart';

import '../../components/input_form.dart';
import '../../controller/controller.dart';
import '../routes/routes.dart';

class Registrar extends StatefulWidget {
  const Registrar({super.key});

  @override
  State<Registrar> createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {
  Controller controller = Get.put(Controller());
  final nombre = TextEditingController();
  final apellido = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('Registrar Usuario',style: TextStyle(fontFamily: "Poppins",fontSize: 20)),
            ),
            CustomInputField(
              controller: nombre,
              label: "Nombre completo",
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return "El nombre no puede estar vacío";
                } else if (RegExp(r'[0-9!@#%^&*(),.?":{}|<>]').hasMatch(text)) {
                  return "El nombre no puede contener números ni símbolos";
                }
                return null;
              },
              icon: const Icon(Icons.person),
              color: Colors.black,
            ),
            CustomInputField(
              controller: apellido,
              label: "Apellido completo",
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return "El apellido no puede estar vacío";
                } else if (RegExp(r'[0-9!@#%^&*(),.?":{}|<>]').hasMatch(text)) {
                  return "El apellido no puede contener números ni símbolos";
                }
                return null;
              },
              icon: const Icon(Icons.person),
              color: Colors.black,
            ),
            CustomInputField(
              controller: email,
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
              controller: password,
              label: "Contraseña",
              ispassword: true,
              validator: (text) {
                if (text!.length < 8) {
                  return "La contraseña es muy corta";
                }

                if (text.isEmpty) {
                  return "La contraseña no puede ser vacio";
                }
                return "";
              },
              icon: const Icon(Icons.lock),
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: ElevatedButton(
                  onPressed: () async {
                    final data = UserData(
                        nombre: nombre.text,
                        apellido: apellido.text,
                        email: email.text,
                        pass: password.text, token: '');
                    bool result = await signupwithemailandpassword(data);
                    if (result) {
                      Get.toNamed(Routes.home);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade900,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: controller.cargando.value == false
                      ? const Text(
                          "Crear Usuario",
                          style: TextStyle(
                              color: Colors.black, fontFamily: "Poppins"),
                        )
                      : const CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
