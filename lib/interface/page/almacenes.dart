import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/btnform.dart';
import '../../controller/controller.dart';
import '../../database/function/funciones_basicas.dart';
import '../../models/productos/almacen.dart';
import 'actualizar.dart';

class AlmacenesIDe extends StatefulWidget {
  const AlmacenesIDe({super.key});

  @override
  State<AlmacenesIDe> createState() => _AlmacenesIDeState();
}

class _AlmacenesIDeState extends State<AlmacenesIDe> {
  Controller controller = Get.put(Controller());
  FuncionesBasic funciones = FuncionesBasic();
  final searchController = TextEditingController();
  String searchText = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  controller.imagenPath.value,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'MAESTRO ALMACENES',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                  labelText: 'Ingrese nombre de almacen',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Btnform(
                  funcion: () {
                    searchController.text = '';
                    searchText = '';
                    setState(() {});
                  },
                  label: "CANCELAR",
                  color: Colors.blue.shade900),
              Btnform(
                  funcion: () async {
                    final fin = await funciones.getNext3("almacenes");
                    final almacen =
                        Almacenes(id: fin, nombre: searchController.text);
                    bool result =
                        await funciones.insertalmacen(almacen);
                    if (result) {
                      Get.snackbar(
                          "Exito", "Se guardo correctamente el almacen");
                      controller.getAllProducts("almacenes");
                      searchController.text = '';
                    } else {
                      Get.snackbar("Opps!", "Ocurrio un problema");
                    }
                  },
                  label: "GUARDAR",
                  color: Colors.blue.shade900)
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'LISTADO DE ALMACENES',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Obx(
                () => ListView.builder(
                    itemCount: controller.almacenes.length,
                    itemBuilder: (ctx, index) {
                      return Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.add_home_outlined,
                            color: Colors.blue.shade900,
                            size: 20,
                          ),
                          title: Text(
                            controller.almacenes[index].nombre,
                            style: TextStyle(
                                fontSize: 20, color: Colors.blue.shade900),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Get.to(() => Actualizar(
                                        id: controller.almacenes[index].id
                                            .toString(),
                                        nombre: controller
                                            .almacenes[index].nombre));
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.blue.shade900,
                                    size: 25,
                                  )),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
