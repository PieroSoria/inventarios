import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/controller/controller.dart';
import 'package:inventarios/database/function/funciones_basicas.dart';
import 'package:inventarios/interface/page/actualizar.dart';

import '../../models/productos/almacen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Controller controller = Get.put(Controller());
  FuncionesBasic funciones = FuncionesBasic();
  final searchController = TextEditingController();
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                  ElevatedButton(
                    onPressed: () {
                      searchController.text = '';
                      searchText = '';
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue.shade900,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.all(16.0),
                    ),
                    child: const SizedBox(
                      child: Text(
                        'CANCELAR',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final fin = await funciones.getNext3();
                      final String almacenes = searchController.text;
                      final almacen = Almacenes(id: fin, nombre: almacenes);
                      bool result = await funciones.insertalmacen(almacen);
                      if (result) {
                        Get.snackbar(
                            "Exito", "Se guardo correctamente el almacen");
                        controller.getAllProducts();
                        searchController.text = '';
                      } else {
                        Get.snackbar("Opps!", "Ocurrio un problema");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue.shade900,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.all(16.0),
                    ),
                    child: const SizedBox(
                      child: Text(
                        'GUARDAR',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
        ),
      ),
    );
  }
}
