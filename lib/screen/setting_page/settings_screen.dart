import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/controller/settings_controller.dart';
import 'package:inventariosnew/core/routes/routes.dart';

class SettingsScreen extends GetWidget<SettingController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Inventarios",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.offAllNamed(Routes.index),
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text("Advertencia"),
                      content: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Ingrese la clave para activar la funcion",
                              style: TextStyle(fontFamily: "Poppins"),
                            ),
                            TextField(
                              controller: controller.clave,
                            )
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            controller.verificarclave();
                          },
                          child: const Text("Aceptar"),
                        ),
                        ElevatedButton(
                          onPressed: () => Get.back(),
                          child: const Text("Cancelar"),
                        )
                      ],
                    );
                  },
                );
                // controller.guardaropcionedit();
              },
              title: const Text("Opcion de edicion de productos"),
              trailing: Obx(
                () => controller.opcionedit.value
                    ? const Icon(Icons.edit)
                    : const Icon(Icons.edit_off_rounded),
              ),
            )
          ],
        ),
      ),
    );
  }
}
