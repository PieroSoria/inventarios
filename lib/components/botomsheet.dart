import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/components/btnform.dart';
import 'package:inventariosnew/controller/index_controller.dart';

class BotomSheet extends StatefulWidget {
  final IndexController controller;
  const BotomSheet({super.key, required this.controller});

  @override
  State<BotomSheet> createState() => _BotomSheetState();
}

class _BotomSheetState extends State<BotomSheet> {
  @override
  void initState() {
    widget.controller.cargaralmacenesitem();
    widget.controller.selectedItem.value = "";
    widget.controller.selectedItem2.value = "";
    super.initState();
  }

  @override
  void dispose() {
    eliminardata();
    super.dispose();
  }

  void eliminardata() {
    widget.controller.selectedItem("");
    widget.controller.selectedItem2("");
    widget.controller.listalmacenes.clear();
    widget.controller.listsubalmacenes.clear();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return SizedBox(
        height: 300,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Ubicaciones",
                      style: TextStyle(fontFamily: "Poppins", fontSize: 25),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    child: Obx(
                      () => DropdownButton<dynamic>(
                        isExpanded: true,
                        value: widget.controller.selectedItem.value != ''
                            ? widget.controller.selectedItem.value
                            : null,
                        hint: const Center(
                          child: Text("Selecciona una ubicacion"),
                        ),
                        items:
                            widget.controller.listalmacenes.map((dynamic item) {
                          return DropdownMenuItem<dynamic>(
                            value: item,
                            child: Center(child: Text(item.toString())),
                          );
                        }).toList(),
                        onChanged: (dynamic selectedItem) {
                          setState(() {
                            widget.controller.selectedItem(selectedItem);
                            widget.controller
                                .cargarsubalmacenesitem(where: selectedItem);
                          });
                        },
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    child: Obx(
                      () => DropdownButton<dynamic>(
                        isExpanded: true,
                        value: widget.controller.selectedItem2.value != ''
                            ? widget.controller.selectedItem2.value
                            : null,
                        hint: const Center(
                          child: Text("Selecciona una sub ubicacion"),
                        ),
                        items: widget.controller.listsubalmacenes
                            .map((dynamic item) {
                          return DropdownMenuItem<dynamic>(
                            value: item,
                            child: Center(
                              child: Text(
                                item.toString(),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (dynamic selectedItem) {
                          setState(() {
                            widget.controller.selectedItem2(selectedItem);
                          });
                        },
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Btnform(
                    funcion: () {
                      widget.controller
                          .xalmacen(widget.controller.selectedItem.value);
                      widget.controller
                          .xsubalmacen(widget.controller.selectedItem2.value);
                      widget.controller.selectedItem("");
                      widget.controller.selectedItem2("");
                      Navigator.of(context).pop();
                    },
                    label: "GUARDAR",
                    color: Colors.blue.shade900,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
