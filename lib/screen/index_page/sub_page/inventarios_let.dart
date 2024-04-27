import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/components/btnform.dart';
import 'package:inventariosnew/controller/index_controller.dart';
import 'package:inventariosnew/core/routes/routes.dart';
import 'package:inventariosnew/screen/detalle_inventario_page/detalle_inventario_screen.dart';

class InventarioIDE extends StatefulWidget {
  final IndexController controller;
  const InventarioIDE({super.key, required this.controller});

  @override
  State<InventarioIDE> createState() => _InventarioIDEState();
}

class _InventarioIDEState extends State<InventarioIDE> {
  @override
  void initState() {
    widget.controller.tablenameinventario.clear();
    widget.controller
        .getAllProducts2(selectalmacen: widget.controller.selectalmacen.text);
    super.initState();
  }

  @override
  void dispose() {
    eliminardata();
    super.dispose();
  }

  eliminardata() async {
    widget.controller.listadeinventarios.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: Obx(
            () => Row(
              children: [
                Text(
                  widget.controller.nombreuser.value,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900),
                ),
              ],
            ),
          ),
        ),
        const Text(
          "Lista de Inventarios",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Poppins",
          ),
        ),
        Container(
          width: double.infinity,
          height: 400,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Obx(
            () {
              final listadeinventarios = widget.controller.listadeinventarios;
              if (listadeinventarios.isNotEmpty) {
                return ListView.builder(
                  itemCount: widget.controller.listadeinventarios.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.add_home_outlined,
                          color: Colors.blue.shade900,
                          size: 20,
                        ),
                        title: Text(
                          widget.controller.listadeinventarios[index].nombre,
                          style: TextStyle(
                              fontSize: 20, color: Colors.blue.shade900),
                        ),
                        subtitle: Column(
                          children: [
                            Text(
                              "Estado: ${widget.controller.listadeinventarios[index].activo}",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.blue.shade900),
                            ),
                            Text(
                              "Fecha: ${widget.controller.listadeinventarios[index].fecha}",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Get.toNamed(
                              Routes.detalleinven,
                              arguments: DetalleInventarioScreen(
                                inventario:
                                    widget.controller.listadeinventarios[index],
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.menu,
                            color: Colors.blue.shade900,
                            size: 25,
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    "No se encontraron inventarios disponibles",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25),
                  ),
                );
              }
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Btnform(
              funcion: () {
                Get.toNamed(Routes.index);
              },
              label: "CANCELAR",
              color: Colors.blue.shade900,
            )
          ],
        ),
      ],
    );
  }
}
