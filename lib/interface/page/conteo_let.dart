import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/components/botomsheet.dart';
import 'package:inventarios/components/contador.dart';
import 'package:inventarios/controller/controller.dart';
import 'package:inventarios/database/createdb/database.dart';
import 'package:inventarios/database/function/funciones_basicas.dart';

class Conteo extends StatefulWidget {
  const Conteo({super.key});

  @override
  State<Conteo> createState() => _ConteoState();
}

class _ConteoState extends State<Conteo> {
  SQLdb sqLdb = SQLdb();
  FuncionesBasic funciones = FuncionesBasic();
  final controller = Get.put(Controller());
  final buscarController = TextEditingController();
  bool productoEncontrado = false;
  FocusNode _focusNode = FocusNode();
  bool _switchValue = false;

  @override
  void initState() {
    // _focusNode = FocusNode();
    // _focusNode.requestFocus();
    // if (stockController.text.isNotEmpty) {
    //   stockValue = int.parse(stockController.text);
    //   originalStockValue = stockValue;
    // }
    // controller.initDropdownItemsubicacion();
    super.initState();
  }

  @override
  void dispose() {
    controller.xubicacion("");
    controller.xsububicacion("");
    controller.resultbus.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Ubicacion Actual",
                          style: TextStyle(
                              color: Colors.blue.shade900,
                              fontFamily: "Poppins",
                              fontSize: 23),
                        ),
                      ),
                      Obx(() => Text(
                            controller.xubicacion.value,
                            style: const TextStyle(
                                fontFamily: "Poppins", fontSize: 20),
                          )),
                      Obx(() => Text(
                            controller.xsububicacion.value,
                            style: const TextStyle(
                                fontFamily: "Poppins", fontSize: 20),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 60, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(
                        () => Text(
                          controller.nombreuser.value,
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
                                  controller.resultbus.clear();
                                });
                              }),
                          const Text("manual")
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: buscarController,
                    focusNode: _focusNode,
                    onSubmitted: (value) async {
                      if (controller.xubicacion.value == "" &&
                          controller.xsububicacion.value == "") {
                        showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            backgroundColor:
                                const Color.fromARGB(0, 194, 193, 193),
                            builder: (context) {
                              return const BotomSheet();
                            });
                      } else {
                        if (_switchValue == false) {
                          funciones.sumarconteo(controller.xubicacion.value,
                              controller.xsububicacion.value, value);
                        } else {
                          await funciones.buscarProducto(value);
                          setState(() {
                            controller.conteo(value);
                            debugPrint("Es ${controller.conteo.value}");
                          });
                        }
                        buscarController.text = '';
                        setState(() {
                          _focusNode = FocusNode();
                          _focusNode.requestFocus();
                        });
                      }
                    },
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
                    () => ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.resultbus.length,
                      itemBuilder: (context, index) {
                        final resultado = controller.resultbus[index];
                        return ListBody(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                  "Código de Barras: ${resultado.codbarra}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text("Categoría: ${resultado.categoria}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                  "Nombre del Producto: ${resultado.descripcion}"),
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
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  child: _switchValue ? const Contador() : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
