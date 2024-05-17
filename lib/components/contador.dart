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
  int stockValue = 0;
  int conteo = 0;
  int originalStockValue = 0;
  void incrementStock() {
    setState(() {
      if (widget.controller.stockController.text.isNotEmpty) {
        stockValue = int.tryParse(widget.controller.stockController.text) ?? 0;
      }
      stockValue += 1;
      conteo += 1;
      widget.controller.stockController.text = stockValue.toString();
    });
  }

  void restarStock() {
    setState(() {
      if (widget.controller.stockController.text.isNotEmpty) {
        stockValue = int.tryParse(widget.controller.stockController.text) ?? 0;
      }
      if (stockValue > 0) {
        stockValue -= 1;
        conteo -= 1;
      }
      widget.controller.stockController.text = stockValue.toString();
    });
  }

  @override
  void initState() {
    // init();
    super.initState();
  }

  // void init() {
  //   if (widget.controller.stockController.text.isNotEmpty) {
  //     setState(() {
  //       stockValue = int.parse(widget.controller.stockController.text);
  //       debugPrint("Data: $stockValue");
  //       originalStockValue = stockValue;
  //       widget.controller.stockController.text = originalStockValue.toString();
  //     });
  //   }
  // }

  @override
  void dispose() {
    delete();
    super.dispose();
  }

  void delete() {
    conteo = 0;
    originalStockValue = 0;
    stockValue = originalStockValue;

    widget.controller.stockController.text = "0";
    widget.controller.resultbus.value = null;
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
                    controller: widget.controller.stockController,
                    onChanged: (value) {
                      setState(() {
                        widget.controller.stockController.text = value;
                        debugPrint(widget.controller.stockController.text);
                      });
                    },
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
                  conteo = 0;
                  originalStockValue = 0;
                  stockValue = originalStockValue;
                  widget.controller.stockController.text = "0";
                  widget.controller.resultbus.value = null;
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
                    isScrollControlled: true,
                    builder: (context) {
                      return BotomtypePorduct(
                        controller: widget.controller,
                        value: widget.controller.resultbus.value!.codbarra
                            .toString(),
                        barrido: false,
                        stock: widget.controller.stockController,
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
