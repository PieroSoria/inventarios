import 'package:flutter/material.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/components/btnform.dart';
import 'package:inventariosnew/controller/index_controller.dart';

class Importdata extends StatefulWidget {
  final IndexController controller;
  const Importdata({super.key, required this.controller});

  @override
  State<Importdata> createState() => _ImportdataState();
}

class _ImportdataState extends State<Importdata> {
  File? selectedFile;

  @override
  void initState() {
    widget.controller.tablenameinventario.clear();
    widget.controller.cargaralmacenes();
    widget.controller.startTimer();
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.selectedItem.value == "";
    widget.controller.almacenes == [];
    widget.controller.selectfilename.value = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.controller.nombreuser.value,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900),
                  ),
                  Text(
                    widget.controller.currentDateTime.value,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 30,
              ),
              child: TextField(
                controller: widget.controller.tablenameinventario,
                style: TextStyle(fontSize: 20, color: Colors.blue.shade900),
                decoration: InputDecoration(
                  labelText: 'Ingrese nombre del inventario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                widget.controller.selectfilename.value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Btnform(
              funcion: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['xlsx', 'xls'],
                );
                if (result != null && result.files.isNotEmpty) {
                  widget.controller.selectfilename(result.files.first.name);
                  selectedFile = File(result.files.first.path!);
                } else {
                  Get.snackbar("ADVERTENCIA",
                      "El documento no se cargó en la base de datos");
                }
              },
              label: 'BUSCAR EXCEL',
              color: Colors.blue.shade900,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Btnform(
                  funcion: () {
                    widget.controller.selectfilename('');
                    widget.controller.selectedItem("");
                    widget.controller.tablenameinventario.text = '';
                    selectedFile = null;
                  },
                  label: "CANCELAR",
                  color: Colors.blue.shade900,
                ),
                Btnform(
                  funcion: () async {
                    await widget.controller.verificaryguardardatos(
                      context: context,
                      selectedFile: selectedFile,
                    );
                    widget.controller.selectfilename('');
                    widget.controller.selectedItem("");
                    widget.controller.tablenameinventario.text = '';
                    selectedFile = null;
                  },
                  label: "GUARDAR",
                  color: Colors.blue.shade900,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
