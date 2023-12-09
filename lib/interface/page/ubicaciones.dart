import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/controller/controller.dart';
import 'package:inventarios/interface/page/actualizarubi.dart';
import 'package:inventarios/models/productos/ubicacioneslet.dart';

import '../../components/btnform.dart';
import '../../database/function/funciones_basicas.dart';

class Ubicaciones extends StatefulWidget {
  const Ubicaciones({super.key});

  @override
  State<Ubicaciones> createState() => _UbicacionesState();
}

class _UbicacionesState extends State<Ubicaciones> {
  final controller = Get.put(Controller());
  final searchubicacion = TextEditingController();
  final searchsububicacion = TextEditingController();
  FuncionesBasic funciones = FuncionesBasic();
  String? searchText;
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    controller.nombreuser.value,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'MAESTRO UBICACIONES',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: TextField(
              controller: searchubicacion,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                  labelText: 'Ingrese ubicacion',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: TextField(
              controller: searchsububicacion,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                  labelText: 'Ingrese sububicacion',
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
                    searchubicacion.text = '';
                    searchsububicacion.text = '';
                    searchText = '';
                    setState(() {});
                  },
                  label: "CANCELAR",
                  color: Colors.blue.shade900),
              Btnform(
                  funcion: () async {
                    final fin = await funciones.getNext3('ubicaciones');

                    final ubicaciones = Ubicacioneslet(
                        id: fin,
                        ubicacion: searchubicacion.text,
                        sububicaciones: searchsububicacion.text);
                    bool result = await funciones.insertubicacion(ubicaciones);
                    if (result) {
                      Get.snackbar(
                          "Exito", "Se guardo correctamente el almacen");
                      controller.getAllProducts("ubicaciones");
                      searchubicacion.text = '';
                      searchsububicacion.text = '';
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
              'LISTADO DE UBICACIONES',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Obx(
                () => ListView.builder(
                    itemCount: controller.ubicacion.length,
                    itemBuilder: (ctx, index) {
                      return Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.add_home_outlined,
                            color: Colors.blue.shade900,
                            size: 20,
                          ),
                          title: Text(
                            controller.ubicacion[index].ubicacion,
                            style: TextStyle(
                                fontSize: 20, color: Colors.blue.shade900),
                          ),
                          subtitle: Text(
                            controller.ubicacion[index].sububicaciones,
                            style: TextStyle(
                                fontSize: 20, color: Colors.blue.shade900),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Get.to(() => ActualizarUbi(
                                        id: controller.ubicacion[index].id,
                                        ubicacion: controller
                                            .ubicacion[index].ubicacion,
                                        sububicacion: controller
                                            .ubicacion[index].sububicaciones));
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
