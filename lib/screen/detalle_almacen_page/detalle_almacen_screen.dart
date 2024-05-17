import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/components/btnform.dart';
import 'package:inventariosnew/components/input_custom_form.dart';
import 'package:inventariosnew/controller/detalle_almacen_controller.dart';
import 'package:inventariosnew/core/routes/routes.dart';
import 'package:inventariosnew/domain/model/productos/almacen.dart';

class DetalleAlmacenScreen extends GetWidget<DetalleAlmacenController> {
  final Almacenes almacen;
  const DetalleAlmacenScreen({
    super.key,
    required this.almacen,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Get.offAllNamed(Routes.index);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Get.offAllNamed(Routes.index),
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
            ),
          ),
          title: const Text(
            "Editar Alamcen",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(),
          child: GetBuilder(
            init: controller,
            initState: (state) {
              controller.insertaralmacen(almacen);
            },
            builder: (context) {
              return Column(
                children: [
                  InputEditCustom(
                    controller: controller.almacencon,
                    labeltext: "Ingrese Almacen",
                  ),
                  Btnform(
                    funcion: () {
                      controller.actualizaralmacen(almacen.id.toString());
                    },
                    label: "Editar Almacen",
                    color: Colors.blue.shade900,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
