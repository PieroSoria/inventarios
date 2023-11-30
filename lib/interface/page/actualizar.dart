import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        automaticallyImplyLeading: true,
        title: const Text('EDITAR PRODUCTO'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: nombreController,
                style: TextStyle(fontSize: 20, color: Colors.blue.shade900),
                decoration: InputDecoration(
                  labelText: 'codigo de barra',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
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
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue.shade900,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const SizedBox(
                  width: 270,
                  child: Text(
                    'MODIFICAR ALMACEN',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue.shade900,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const SizedBox(
                  width: 270,
                  child: Text(
                    'CANCELAR',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
