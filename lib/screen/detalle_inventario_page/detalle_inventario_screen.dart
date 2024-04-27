import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/components/estadodelinventario.dart';
import 'package:inventariosnew/controller/detalle_inventario_controller.dart';
import 'package:inventariosnew/core/routes/routes.dart';
import 'package:inventariosnew/domain/model/productos/inventarios.dart';

class DetalleInventarioScreen extends GetWidget<DetalleInventarioController> {
  final Inventarios inventario;
  const DetalleInventarioScreen({super.key, required this.inventario});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Get.offAllNamed(Routes.index);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.offAllNamed(Routes.index),
            icon: const Icon(
              Icons.arrow_back_ios_new,
            ),
          ),
          title: Text(
            "Opciones del Inventario ${inventario.nombre}",
            style: const TextStyle(fontSize: 16),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          width: double.infinity,
          height: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.5),
            //     spreadRadius: 5,
            //     blurRadius: 7,
            //     offset: const Offset(0, 3),
            //   )
            // ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Opcion de ${inventario.nombre}",
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                      ),
                    ),
                    Estadoinventario(
                      controller: controller,
                      inventarios: inventario,
                    )
                  ],
                ),
              ),
              Form(
                key: controller.keyform,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),
                      child: TextFormField(
                        controller: controller.nombreexcel,
                        validator: (value) {
                          if (value!.isEmpty || value == "") {
                            return "el campo no puede estar vacio";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Ingrese un nuevo nombre",
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (controller.keyform.currentState!.validate()) {
                              controller.exportarExcel(inventario);
                            }
                          },
                          child: const Text(
                            "Exportar excel",
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Advertencia"),
                                content: Text(
                                  "Esta seguro que desea eliminar el inventario ${inventario.nombre}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                                actions: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await controller
                                            .eliminarinventario(inventario);
                                      },
                                      child: const Text('Aceptar'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancelar'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text("Eliminar Inventario"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
