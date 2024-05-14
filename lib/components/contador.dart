import 'package:flutter/material.dart';
import 'package:inventariosnew/components/botomtipoproducto.dart';

import 'package:inventariosnew/controller/index_controller.dart';

class Contador extends StatefulWidget {
  final IndexController controller;
  const Contador({super.key, required this.controller});

  @override
  State<Contador> createState() => _ContadorState();
}

class _ContadorState extends State<Contador> {
  final stockController = TextEditingController(text: '0');

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
  void initState() {
    if (widget.controller.stockController.text.isNotEmpty) {
      stockValue = int.parse(widget.controller.stockController.text);
      originalStockValue = stockValue;
    }
    super.initState();
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    conteo = 0;
                    stockValue = originalStockValue;
                    stockController.text = stockValue.toString();
                    widget.controller.resultbus(null);
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
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return BotomtypePorduct(
                        controller: widget.controller,
                        value: widget.controller.resultbus.value!.codbarra
                            .toString(),
                        barrido: false,
                        stock: stockController,
                      );
                    },
                  );

                  await widget.controller.buscarproducto(
                    codbarra:
                        widget.controller.resultbus.value!.codbarra.toString(),
                  );
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
                    'GUARDAR',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
