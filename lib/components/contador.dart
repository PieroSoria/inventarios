import 'package:flutter/material.dart';
import 'package:inventarios/database/function/funciones_basicas.dart';

class Contador extends StatefulWidget {
  final String buscarcodigo;
  const Contador({super.key, required this.buscarcodigo});

  @override
  State<Contador> createState() => _ContadorState();
}

class _ContadorState extends State<Contador> {
  final stockController = TextEditingController(text: '0');
  final funciones = FuncionesBasic();
  int stockValue = 0;
  int conteo = 0;
  int originalStockValue = 0;
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
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
            ),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text("Conteo"),
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
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
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
                  // resultados = [];
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
                await funciones.actualizarconteo(
                    widget.buscarcodigo.toString(), stockController.text);

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
                  // resultados = [];
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
