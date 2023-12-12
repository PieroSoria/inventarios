import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/components/btnform.dart';
import 'package:inventarios/controller/controller.dart';

class BotomSheet extends StatefulWidget {
  const BotomSheet({super.key});

  @override
  State<BotomSheet> createState() => _BotomSheetState();
}

class _BotomSheetState extends State<BotomSheet> {
  final controller = Get.put(Controller());
  String _selectedItem = "SELECCIONAR UBICACION";
  String _selectedItem2 = "SELECCIONAR SUBUBICACION";

  @override
  void initState() {
    controller.initDropdownItemsubicacion();
    super.initState();
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
                    child: Text("Ubicaciones",style: TextStyle(fontFamily: "Poppins",fontSize: 25),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                    child: Obx(() {
                      final data = controller.dropdownitemubicacion;
                      if (data.isNotEmpty) {
                        return DropdownButton<dynamic>(
                          isExpanded: true,
                          value: _selectedItem,
                          items: controller.dropdownitemubicacion
                              .map((dynamic item) {
                            return DropdownMenuItem<dynamic>(
                              value: item,
                              child: Center(child: Text(item.toString())),
                            );
                          }).toList(),
                          onChanged: (dynamic selectedItem) {
                            setState(() {
                              _selectedItem = selectedItem;

                              controller
                                  .initDropdownItemssububicacion(selectedItem);
                            });
                          },
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 18,
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                    child: Obx(
                      () => DropdownButton<dynamic>(
                        isExpanded: true,
                        value: _selectedItem2,
                        items: controller.dropdownitemsububicacion
                            .map((dynamic item) {
                          return DropdownMenuItem<dynamic>(
                            value: item,
                            child: Center(child: Text(item.toString())),
                          );
                        }).toList(),
                        onChanged: (dynamic selectedItem) {
                          setState(() {
                            _selectedItem2 = selectedItem;
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
                        controller.xubicacion(_selectedItem);
                        controller.xsububicacion(_selectedItem2);
                        Navigator.of(context).pop();
                      },
                      label: "GUARDAR",
                      color: Colors.blue.shade900)
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
