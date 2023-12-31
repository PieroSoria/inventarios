import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/database/function/funciones_basicas.dart';

import '../controller/controller.dart';

class Contador extends StatefulWidget {
  const Contador({super.key});

  @override
  State<Contador> createState() => _ContadorState();
}

class _ContadorState extends State<Contador> {
  final stockController = TextEditingController(text: '0');
  final controller = Get.put(Controller());
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
                bool result = await funciones.actualizarconteo(
                    controller.xubicacion.value,
                    controller.xsububicacion.value,
                    controller.conteo.value,
                    stockController.text);

                if (result) {
                  setState(() {
                    controller.conteo("");
                  });
                  Get.snackbar("Exito", "Los datos se guardaron correctamente");
                }else{
                  Get.snackbar("Opps!", "No se selecciono ninguna ubicacion");
                }

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
