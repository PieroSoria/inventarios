import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/controller/detalle_inventario_controller.dart';
import 'package:inventariosnew/domain/model/productos/inventarios.dart';

class Estadoinventario extends StatefulWidget {
  const Estadoinventario({
    super.key,
    required this.controller,
    required this.inventarios,
  });

  final DetalleInventarioController controller;
  final Inventarios inventarios;

  @override
  State<Estadoinventario> createState() => _EstadoinventarioState();
}

class _EstadoinventarioState extends State<Estadoinventario> {
  @override
  void initState() {
    widget.controller
        .estadoinve(widget.inventarios.activo.toString() == "ABIERTO");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          const Text("Estado: "),
          Switch(
            value: widget.controller.estadoinve.value,
            onChanged: (value) {
              widget.controller.estadoinve(value);
              widget.controller.activarinventario(widget.inventarios);
            },
          )
        ],
      ),
    );
  }
}