import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/components/btnform.dart';
import 'package:inventariosnew/controller/index_controller.dart';
import 'package:inventariosnew/core/routes/routes.dart';
import 'package:inventariosnew/screen/detalle_almacen_page/detalle_almacen_screen.dart';

class AlmacenesIDe extends StatefulWidget {
  final IndexController controller;
  const AlmacenesIDe({super.key, required this.controller});

  @override
  State<AlmacenesIDe> createState() => _AlmacenesIDeState();
}

class _AlmacenesIDeState extends State<AlmacenesIDe> {
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    widget.controller.cargaralmacenes();
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.almacenes == [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              widget.controller.imagenPath.value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'MAESTRO ALMACENES',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        Form(
          key: _formkey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: TextFormField(
                  controller: widget.controller.searchalmacen,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "El campo no puede ser vacio";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Ingrese el almacen',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: TextFormField(
                  controller: widget.controller.searchsubalmacen,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "El campo no puede ser vacio";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Ingrese el subalmacen',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Btnform(
                    funcion: () {
                      widget.controller.searchalmacen.text = '';
                      widget.controller.searchsubalmacen.text = '';
                      widget.controller.searchText("");
                    },
                    label: "CANCELAR",
                    color: Colors.blue.shade900,
                  ),
                  Btnform(
                    funcion: () async {
                      if (_formkey.currentState!.validate()) {
                        await widget.controller.guardaralmacen();
                      }
                    },
                    label: "GUARDAR",
                    color: Colors.blue.shade900,
                  )
                ],
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            'LISTADO DE ALMACENES',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Obx(
              () => ListView.builder(
                itemCount: widget.controller.almacenes.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.add_home_outlined,
                        color: Colors.blue.shade900,
                        size: 20,
                      ),
                      title: Text(
                        widget.controller.almacenes[index].almacen,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      subtitle: Text(
                        widget.controller.almacenes[index].subalmacen,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      trailing: Obx(
                        () => widget.controller.opcionedit.value
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Get.toNamed(
                                        Routes.detallealma,
                                        arguments: DetalleAlmacenScreen(
                                          almacen: widget
                                              .controller.almacenes[index],
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.blue.shade900,
                                      size: 25,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      widget.controller.eliminardatatablabyid(
                                        tabla: 'almacenes',
                                        id: widget
                                            .controller.almacenes[index].id
                                            .toString(),
                                        index: index,
                                      );
                                      widget.controller.almacenes
                                          .removeAt(index);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.blue.shade900,
                                      size: 25,
                                    ),
                                  )
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
