import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/components/btnform.dart';
import 'package:inventarios/controller/controller.dart';
import 'package:inventarios/interface/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sqflite/sqflite.dart';

import '../../database/createdb/database.dart';

class Guardainventario extends StatefulWidget {
  const Guardainventario({super.key});

  @override
  State<Guardainventario> createState() => _GuardainventarioState();
}

class _GuardainventarioState extends State<Guardainventario> {
  final controller = Get.put(Controller());
  SQLdb sqLdb = SQLdb();

  Future<bool> cerrarinventario() async {
    Database? mydb = await sqLdb.db;
    int? rep = await mydb?.update(
      'inventarios',
      {'activo': "CERRADO"},
    );
    if (rep! > 0) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 160),
                        child: Obx(
                          () => Text(
                            controller.nombreuser.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Text(
                        '¿ESTA SEGURO DE CERRAR EL INVENTARIO?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Btnform(
                        funcion: () async {
                          bool result = await cerrarinventario();
                          if (result) {
                            Get.snackbar("Exito", "Se cerror correctamente");
                          } else {
                            Get.snackbar("Error", "Opps!! ocurrio un problema");
                          }
                        },
                        label: "CERRAR EL INVENTARIO",
                        color: Colors.blue.shade900,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Btnform(
                        funcion: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          final resul = await prefs.remove('tokenuser');
                          if (resul) {
                            Get.toNamed(Routes.home);
                          }
                        },
                        label: "Cerrar Session",
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
