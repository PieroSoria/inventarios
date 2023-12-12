import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  List<Map<String, dynamic>> resultados = [];
  final buscarController = TextEditingController();

  bool productoEncontrado = false;
  int stockValue = 0;
  int conteo = 0;
  int originalStockValue = 0;
  FocusNode _focusNode = FocusNode();
  String? buscarcodigo;
  bool _switchValue = false;

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.requestFocus();
    // if (stockController.text.isNotEmpty) {
    //   stockValue = int.parse(stockController.text);
    //   originalStockValue = stockValue;
    // }
    super.initState();
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
                      if (_switchValue == false) {
                        funciones.sumarconteo(value);
                      } else {
                        final resul = await funciones.buscarProducto(value);
                        setState(() {
                          resultados = resul;
                        });
                      }
                      buscarController.text = '';
                      setState(() {
                        _focusNode = FocusNode();
                        _focusNode.requestFocus();
                      });
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: resultados.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> resultado = resultados[index];
                      return ListBody(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                                "Código de Barras: ${resultado['codbarra']}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text("Categoría: ${resultado['categoria']}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                                "Nombre del Producto: ${resultado['descripcion']}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text("Medida: ${resultado['medida']}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Stock Teórico: ${resultado['stock_inicial']}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Conteo: ${resultado['conteo']}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  child: _switchValue
                      ? Contador(
                          buscarcodigo: buscarController.text,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
