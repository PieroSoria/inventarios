import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/components/btnform.dart';

import '../../database/createdb/database.dart';
import '../routes/routes.dart';

class ActualizarUbi extends StatefulWidget {
  final double id;
  final String ubicacion;
  final String sububicacion;
  const ActualizarUbi(
      {super.key,
      required this.id,
      required this.ubicacion,
      required this.sububicacion});

  @override
  State<ActualizarUbi> createState() => _ActualizarUbiState();
}

class _ActualizarUbiState extends State<ActualizarUbi> {
  final ubicacion = TextEditingController();
  final sububicacion = TextEditingController();

  SQLdb funciones = SQLdb();
  @override
  void initState() {
    ubicacion.text = widget.ubicacion;
    sububicacion.text = widget.sububicacion;
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
        title: const Text('EDITAR UBICACION',
            style: TextStyle(color: Colors.white, fontFamily: "Poppins")),
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
                  controller: ubicacion,
                  style: TextStyle(fontSize: 20, color: Colors.blue.shade900),
                  decoration: InputDecoration(
                    labelText: 'ubicacion',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  controller: sububicacion,
                  style: TextStyle(fontSize: 20, color: Colors.blue.shade900),
                  decoration: InputDecoration(
                    labelText: 'sububicacion',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              Btnform(
                  funcion: () async {
                    bool rep = await funciones.updatedata('''
                  UPDATE ubicaciones SET
                  ubicacion = "${ubicacion.text}",
                  sububicacion = "${sububicacion.text}",
                  WHERE id = "${widget.id}"
                  ''');
                    if (rep) {
                      Get.snackbar(
                          "Exito", "Se actualizo correctamente la ubicacion");
                      Get.toNamed(Routes.inicio);
                    }
                  },
                  label: "MODIFICAR UBICACION",
                  color: Colors.blue.shade900),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Btnform(
                    funcion: () {
                      Navigator.of(context).pop();
                    },
                    label: "CANCELAR",
                    color: Colors.blue.shade900),
              )
            ],
          ),
        ),
      ),
    );
  }
}
