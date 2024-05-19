// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:inventariosnew/components/botomsheet.dart';
import 'package:inventariosnew/components/botomtipoproducto.dart';
import 'package:inventariosnew/components/contador.dart';
import 'package:inventariosnew/controller/index_controller.dart';

class Conteo extends StatefulWidget {
  final IndexController controller;
  const Conteo({super.key, required this.controller});

  @override
  State<Conteo> createState() => _ConteoState();
}

class _ConteoState extends State<Conteo> {
  bool productoEncontrado = false;
  FocusNode _focusNode = FocusNode();
  bool _switchValue = false;

  @override
  void initState() {
    _focusNode.requestFocus();
    widget.controller.instanciarubicaciones();
    super.initState();
  }

  @override
  void dispose() {
    eliminardata();
    super.dispose();
  }

  void eliminardata() {
    widget.controller.xalmacen("");
    widget.controller.resultbus(null);
  }

  Future<dynamic> funciondeconteo(String value) async {
    final result = await widget.controller.buscarproductoType(codbarra: value);
    _focusNode.requestFocus();
    if (widget.controller.xalmacen.value != "") {
      if (_switchValue == false) {
        if (result != "0") {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return BotomtypePorduct(
                controller: widget.controller,
                value: value,
                barrido: true,
                tyProduct: result,
              );
            },
          );
        } else {
          widget.controller.sumarconteo(codbarra: value);
        }
      } else {
        await widget.controller.buscarproducto(codbarra: value);
      }
    } else {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        backgroundColor: const Color.fromARGB(0, 194, 193, 193),
        builder: (context) {
          return BotomSheet(controller: widget.controller);
        },
      );
    }
    widget.controller.buscarController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    backgroundColor: const Color.fromARGB(0, 194, 193, 193),
                    builder: (context) {
                      return BotomSheet(
                        controller: widget.controller,
                      );
                    },
                  );
                },
                child: Obx(
                  () => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Ubicacion De Almacen",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontFamily: "Poppins",
                            fontSize: 23,
                          ),
                        ),
                      ),
                      Text(
                        widget.controller.xalmacen.value,
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 60, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Obx(
                      () => Text(
                        widget.controller.nombreuser.value,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900),
                      ),
                    ),
                    Row(
                      children: [
                        const Text("Barrido"),
                        Switch(
                          value: _switchValue,
                          onChanged: (bool value) {
                            setState(() {
                              _switchValue = value;
                              _focusNode = FocusNode();
                              _focusNode.requestFocus();
                              widget.controller.resultbus.value = null;
                            });
                          },
                        ),
                        const Text("manual")
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: widget.controller.buscarController,
                  focusNode: _focusNode,
                  textCapitalization: TextCapitalization.characters,
                  onSubmitted: funciondeconteo,
                  style: TextStyle(fontSize: 20, color: Colors.blue.shade900),
                  decoration: InputDecoration(
                    labelText: 'Ingrese código de barras',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              SizedBox(
                height: 250,
                child: Obx(
                  () {
                    final resultado = widget.controller.resultbus.value;
                    if (resultado != null) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child:
                                Text("Código de Barras: ${resultado.codbarra}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text("Categoría: ${resultado.categoria}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                                "Nombre del Producto: ${resultado.producto}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text("Medida: ${resultado.medida}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Stock Teórico: ${resultado.stock}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Conteo: ${resultado.conteo}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Almacen: ${resultado.almacen}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text("No se encontro nada"),
                      );
                    }
                  },
                ),
              ),
              Container(
                child: _switchValue
                    ? Contador(controller: widget.controller)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
