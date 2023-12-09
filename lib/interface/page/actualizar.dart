import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/components/btnform.dart';
import 'package:inventarios/interface/routes/routes.dart';

import '../../database/createdb/database.dart';

class Actualizar extends StatefulWidget {
  final String id;
  final String nombre;
  const Actualizar({super.key, required this.id, required this.nombre});

  @override
  State<Actualizar> createState() => _ActualizarState();
}

class _ActualizarState extends State<Actualizar> {
  TextEditingController nombreController = TextEditingController();

  SQLdb funciones = SQLdb();
  @override
  void initState() {
    nombreController.text = widget.nombre;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Colors.white,
            )),
        title: const Text(
          'EDITAR ALMACEN',
          style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  controller: nombreController,
                  style: TextStyle(fontSize: 20, color: Colors.blue.shade900),
                  decoration: InputDecoration(
                    labelText: 'codigo de barra',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              Btnform(
                  funcion: () async {
                    bool rep = await funciones.updatedata('''
                  UPDATE almacenes SET
                  nombre = "${nombreController.text}"
                  WHERE id = "${widget.id}"
                  ''');
                    if (rep) {
                      Get.snackbar(
                          "Exito", "Se actualizo correctamente el almacen");
                      Get.toNamed(Routes.inicio);
                    }
                  },
                  label: "MODIFICAR ALMACEN",
                  color: Colors.blue.shade900),
              Btnform(
                  funcion: () {
                    Navigator.of(context).pop();
                  },
                  label: "CANCELAR",
                  color: Colors.blue.shade900)
            ],
          ),
        ),
      ),
    );
  }
}
