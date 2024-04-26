import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/components/btnform.dart';
import 'package:inventariosnew/controller/index_controller.dart';

class Guardainventario extends StatefulWidget {
  final IndexController controller;
  const Guardainventario({super.key, required this.controller});

  @override
  State<Guardainventario> createState() => _GuardainventarioState();
}

class _GuardainventarioState extends State<Guardainventario> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.selectedItem.value == "";
    widget.controller.almacenes == [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Obx(
              () => Text(
                widget.controller.nombreuser.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Text(
                '¿ESTA SEGURO DE CERRAR EL INVENTARIO?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Btnform(
                funcion: () async {
                  widget.controller.cerrarlosinvetarios();
                },
                label: "CERRAR EL INVENTARIO",
                color: Colors.blue.shade900,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Btnform(
                funcion: () async {
                  widget.controller.cerrarsession();
                },
                label: "Cerrar Session",
                color: Colors.blue.shade900,
              ),
            ),
          ],
        )
      ],
    );
  }
}
