import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventarios/components/btnform.dart';
import 'package:inventarios/database/function/funciones_basicas.dart';
import 'package:inventarios/database/function/funciones_excel.dart';

import '../../controller/controller.dart';

class Importdata extends StatefulWidget {
  const Importdata({super.key});

  @override
  State<Importdata> createState() => _ImportdataState();
}

class _ImportdataState extends State<Importdata> {
  Controller controller = Get.put(Controller());
  final selectalmacen = TextEditingController();
  ExcelFuncion excelfuncion = ExcelFuncion();
  FuncionesBasic sqLdb = FuncionesBasic();
  bool _isDisposed = false;

  String _selectedFileName = '';
  String? tablabasededatos;
  File? selectedFile;
  String? _selectedItem;
  List<String> dropdownItems = [];

  late String _currentDateTime;

  final _tableNameController = TextEditingController();
  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isDisposed) {
        setState(() {
          _currentDateTime =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
        });
      }
    });
  }

  Future<void> initDropdownItems() async {
    dropdownItems = await sqLdb.captureData("almacenes", "nombre","SELECCIONAR ALMACEN",null);
    setState(() {
      if (dropdownItems.isNotEmpty) {
        _selectedItem = dropdownItems.first;
      }
    });
  }

  @override
  void initState() {
    _currentDateTime = '';
    initDropdownItems();
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _tableNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                          controller.nombreuser.value,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900),
                        ),
                      ),
                      Text(
                        _currentDateTime,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedItem,
                    items: dropdownItems.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Center(child: Text(item)),
                      );
                    }).toList(),
                    onChanged: (String? selectedItem) {
                      if (dropdownItems.contains(selectedItem)) {
                        setState(() {
                          _selectedItem = selectedItem!;
                          selectalmacen.text = _selectedItem.toString();
                        });
                      }
                    },
                    style: TextStyle(color: Colors.blue.shade900, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TextField(
                    controller: _tableNameController,
                    style: TextStyle(fontSize: 20, color: Colors.blue.shade900),
                    decoration: InputDecoration(
                      labelText: 'Ingrese nombre del inventario',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    _selectedFileName, // Mostrar el nombre del archivo seleccionado
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Btnform(
                  funcion: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['xlsx', 'xls'],
                    );
                    if (result != null && result.files.isNotEmpty) {
                      setState(() {
                        selectedFile = File(result.files.first.path!);
                        _selectedFileName = result.files.first.name;
                      });
                    } else {
                      Get.snackbar("ADVERTENCIA",
                          "El documento no se cargó en la base de datos");
                    }
                  },
                  label: 'BUSCAR EXCEL',
                  color: Colors.blue.shade900,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _tableNameController.text = '';
                          selectedFile = null;
                          _selectedFileName = '';
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
                        bool value = await sqLdb.datoactivo();
                        if (value) {
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('ADVERTENCIA'),
                                content: const SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      Text(
                                        'Existen inventarios abiertos, verifique antes de continuar',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      if (_selectedItem !=
                                          "SELECCIONAR ALMACEN") {
                                        excelfuncion.guardarDatos(
                                            _tableNameController.text,
                                            selectalmacen.text,
                                            selectedFile!);
                                      } else {
                                        Get.snackbar("Advertencia",
                                            "Seleccione un almacen");
                                      }
                                    },
                                    child: const Text("Aceptar"),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancelar")),
                                ],
                              );
                            },
                          );
                        } else {
                          if (_selectedItem != "SELECCIONAR ALMACEN" &&
                              selectedFile != null) {
                            File file = selectedFile!;
                            String tablename = _tableNameController.text;
                            excelfuncion.guardarDatos(
                                tablename, selectalmacen.text, file);
                          } else {
                            Get.snackbar("Advertencia",
                                "Seleccione un almacen y cargue un archivo");
                          }
                        }
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
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
