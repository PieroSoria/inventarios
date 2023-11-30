import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/controller/controller.dart';
import 'package:inventarios/interface/page/login.dart';
import 'package:inventarios/interface/page/registrarse.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  Controller controller = Get.put(Controller());
  bool switchvalue = false;

   @override
  void initState() {
    switchvalue = controller.loginanregis.value;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(Radius.circular(40))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Poppins",
                        fontSize: 20),
                  ),
                ),
                Switch(
                    value: switchvalue,
                    onChanged: (bool value) {
                      setState(() {
                        switchvalue = value;
                        controller.loginanregis(value);
                      });
                    }),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Poppins",
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Obx(() => SizedBox(
                child: controller.loginanregis.value
                    ? const Registrar()
                    : const Login(),
              ))
        ],
      ),
    );
  }
}
