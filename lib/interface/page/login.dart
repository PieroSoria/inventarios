import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/components/input_form.dart';
import 'package:inventarios/interface/routes/routes.dart';
import 'package:inventarios/models/usuario/userdata.dart';

import '../../connection/function/signin.dart';
import '../../controller/controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Controller controller = Get.put(Controller());
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
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Iniciar Session",
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 30,
                    fontWeight: FontWeight.w700),
              ),
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
              icon: const Icon(Icons.person),
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
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                  onPressed: () async {
                    final data = UserData(
                        nombre: '',
                        apellido: '',
                        email: email.text,
                        pass: password.text,
                        token: '');
                    bool result = await signinwithemailandpassword(data);
                    if (result) {
                      Get.toNamed(Routes.inicio);
                    } else {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
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
                          "Iniciar Session",
                          style: TextStyle(
                              color: Colors.black, fontFamily: "Poppins"),
                        )
                      : const CircularProgressIndicator()),
            ),
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "OR",
                    style: TextStyle(color: Colors.black26),
                  ),
                ),
                Expanded(child: Divider()),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.g_mobiledata),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
