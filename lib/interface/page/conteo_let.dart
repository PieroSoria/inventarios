import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  TextEditingController buscarController = TextEditingController();
  TextEditingController stockController = TextEditingController(text: '0');
  bool productoEncontrado = false;
  int stockValue = 0;
  int conteo = 0;
  int originalStockValue = 0;
  FocusNode _focusNode = FocusNode();
  String? buscarcodigo;
  bool _switchValue = false;

  void incrementStock() {
    setState(() {
      if (stockController.text.isNotEmpty) {
        stockValue = int.tryParse(stockController.text) ?? 0;
      }
      stockValue += 1;
      conteo += 1;
      stockController.text = stockValue.toString();
    });
  }

  void restarStock() {
    setState(() {
      if (stockController.text.isNotEmpty) {
        stockValue = int.tryParse(stockController.text) ?? 0;
      }
      if (stockValue > 0) {
        stockValue -= 1;
        conteo -= 1;
      }
      stockController.text = stockValue.toString();
    });
  }

  Future<String> buscarProducto(String codigoBarra) async {
    String? tabla = await funciones.obtenerNombreInventarioActivo();
    final query = 'SELECT * FROM $tabla WHERE codbarra = ?';
    final result = await funciones.rawQuery(query, [codigoBarra]);

    setState(() {
      resultados = result;
      productoEncontrado = resultados.isNotEmpty;
    });
    return buscarcodigo = codigoBarra;
  }

  Future<void> actualizarconteo(String codigoBarra, String conteo) async {
    String? tabla = await funciones.obtenerNombreInventarioActivo();
    String? stock = await funciones.obtenerstock(tabla!, codigoBarra);
    String? conteof = await funciones.obtenerconteo(tabla, codigoBarra);
    int stocksrc = int.parse(stock!);
    int conteoft = int.parse(conteof!);
    int conteo2 = int.parse(conteo);
    int resultado2 = conteoft + conteo2;
    int resultado = resultado2 - stocksrc;
    String resultadof = resultado.toString();
    String resultado2f = resultado2.toString();

    bool rep = await sqLdb.updatedata(
        "UPDATE $tabla SET conteo = '$resultado2f', diferencia = '$resultadof' WHERE codbarra = '$codigoBarra'");
    if (rep) {
      setState(() {});
    }
  }

  Future<void> sumarconteo(String codbarra) async {
    String? tabla = await funciones.obtenerNombreInventarioActivo();
    String? conteo = await funciones.obtenerconteo(tabla!, codbarra);
    String? stock = await funciones.obtenerstock(tabla, codbarra);
    int stocknum = int.parse(stock!);
    int conteof = int.parse(conteo!);
    int resultado = conteof + 1;
    String resultadof = resultado.toString();
    int diferencia = resultado - stocknum;
    String diferenciaf = diferencia.toString();
    bool rep = await sqLdb.updatedata(
        "UPDATE $tabla SET conteo = '$resultadof', diferencia = '$diferenciaf' WHERE codbarra = '$codbarra'");
    if (rep) {
      setState(() {});
    }
    buscarProducto(codbarra);
  }

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.requestFocus();
    if (stockController.text.isNotEmpty) {
      stockValue = int.parse(stockController.text);
      originalStockValue = stockValue;
    }
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
                        sumarconteo(value);
                      } else {
                        buscarProducto(value);
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
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: resultados.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> resultado = resultados[index];
                      return ListBody(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                                "Código de Barras: ${resultado['codbarra']}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text("Categoría: ${resultado['categoria']}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                                "Nombre del Producto: ${resultado['descripcion']}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text("Medida: ${resultado['medida']}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Stock Teórico: ${resultado['stock_inicial']}",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Conteo: ${resultado['conteo']}",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                if (_switchValue == true)
                  _contador()
                else
                  const SizedBox(
                    height: 30,
                  ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _contador() {
    return SizedBox(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: restarStock,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text("Conteo"),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 90,
                  child: TextField(
                    controller: stockController,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: incrementStock,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  conteo = 0;
                  stockValue = originalStockValue;
                  stockController.text = stockValue.toString();
                  resultados = [];
                });
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
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await actualizarconteo(
                    buscarcodigo.toString(), stockController.text);

                // ignore: use_build_context_synchronously
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('MENSAJE'),
                      content: const SingleChildScrollView(
                        child: ListBody(
                          children: [
                            Text(
                              'Los datos se registraron correctamente',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Aceptar'),
                        ),
                      ],
                    );
                  },
                );

                setState(() {
                  conteo = 0;
                  stockValue = originalStockValue;
                  stockController.text = stockValue.toString();
                  resultados = [];
                });
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
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
