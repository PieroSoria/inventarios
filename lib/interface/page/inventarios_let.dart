import 'package:flutter/material.dart';
import 'package:inventarios/database/function/funciones_basicas.dart';
import 'package:inventarios/database/function/funciones_excel.dart';

import '../../database/createdb/database.dart';

class Inventario extends StatefulWidget {
  const Inventario({super.key});

  @override
  State<Inventario> createState() => _InventarioState();
}

class _InventarioState extends State<Inventario> {
  ExcelFuncion excelFuncion = ExcelFuncion();
  TextEditingController selectalmacen = TextEditingController();
  SQLdb sqLdb = SQLdb();
  String? _selectedItem;
  List<String> dropdownItems = [];
  FuncionesBasic funciones = FuncionesBasic();
  TextEditingController searchController = TextEditingController();
  TextEditingController nameexcel = TextEditingController();
  String searchText = '';

  @override
  void initState() {
    initDropdownItems();
    super.initState();
  }

  Future<void> initDropdownItems() async {
    dropdownItems = await funciones.captureData();
    setState(() {
      // Set the initial selected item
      if (dropdownItems.isNotEmpty) {
        _selectedItem = dropdownItems.first;
      }
    });
  }

  Future<List<Map>> getAllProducts({String? selectalmacen}) async {
    String query = "SELECT * FROM 'inventarios'";
    if (selectalmacen != null &&
        selectalmacen.isNotEmpty &&
        selectalmacen != "SELECCIONAR ALMACEN") {
      query += " WHERE almacen LIKE '%$selectalmacen%'";
    } else {
      query;
    }
    List<Map> products = await funciones.getData(query);
    return products;
  }

  Future<void> refreshdata() async {
    setState(() {
      getAllProducts(selectalmacen: _selectedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: refreshdata,
            child: Column(
              children: [
                const SizedBox(
                  height: 120,
                ),
                Row(
                  children: [
                    Text(
                      "widget.widget.user",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButton<String>(
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
                        getAllProducts(selectalmacen: selectedItem);
                      });
                    }
                  },
                  style: TextStyle(color: Colors.blue.shade900, fontSize: 18),
                ),
                Expanded(
                  flex: 11,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    child: FutureBuilder(
                      future: getAllProducts(selectalmacen: selectalmacen.text),
                      builder: (ctx, snp) {
                        if (snp.hasData) {
                          List<Map> listproducts = snp.data!;
                          return ListView.builder(
                              itemCount: listproducts.length,
                              itemBuilder: (ctx, index) {
                                return Card(
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.add_home_outlined,
                                      color: Colors.blue.shade900,
                                      size: 20,
                                    ),
                                    title: Text(
                                      "${listproducts[index]['nombre']}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue.shade900),
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Text(
                                          "Estado: ${listproducts[index]['activo']}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.blue.shade900),
                                        ),
                                        Text(
                                          "Fecha: ${listproducts[index]['fecha']}",
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    trailing: TextButton(
                                      onPressed: () {
                                        opcionde(context, listproducts, index);
                                      },
                                      child: Icon(
                                        Icons.menu,
                                        color: Colors.blue.shade900,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
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
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> opcionde(BuildContext context,
      List<Map<dynamic, dynamic>> listproducts, int index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("SELECCION UNA OPCION"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'GUARDAR',
                            style: TextStyle(color: Colors.blue.shade900),
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                const SizedBox(height: 20),
                                TextField(
                                  controller: nameexcel,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue.shade900),
                                  decoration: InputDecoration(
                                    labelText: 'Digitar el nombre',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                String name =
                                    nameexcel.text.trim().replaceAll(' ', '_');
                                String nombretabla =
                                    "${listproducts[index]['nombre']}";
                                if (name != '') {
                                  excelFuncion.convertTableToExcel(
                                      context, name, nombretabla);
                                  Navigator.of(context).pop();
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        'ADVERTIENCIA!',
                                        style: TextStyle(
                                            color: Colors.blue.shade900),
                                      ),
                                      content: Text(
                                        'RELLENE EL CAMPO NOMBRE',
                                        style: TextStyle(
                                            color: Colors.blue.shade900),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor:
                                                Colors.blue.shade900,
                                            shape: const StadiumBorder(),
                                            padding: const EdgeInsets.all(16.0),
                                          ),
                                          child: const Text(
                                            'ACEPTAR',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue.shade900,
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.all(16.0),
                              ),
                              child: const Text(
                                'ACEPTAR',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue.shade900,
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.all(16.0),
                              ),
                              child: const Text(
                                'CANCELAR',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.explicit_outlined,
                        color: Colors.blue.shade900,
                        size: 25,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Exportar a Excel',
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(
                                  "Desea abrir el inventario \"${listproducts[index]['nombre']}\"?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.blue.shade900),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      bool rep4 = await sqLdb.updatedata(
                                          "UPDATE inventarios SET activo = 'CERRADO'");
                                      bool rep3 = await sqLdb.updatedata(
                                          "UPDATE inventarios SET activo = 'ABIERTO' WHERE nombre = '${listproducts[index]['nombre']}'");
                                      if (rep4 && rep3) {
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      }
                                    },
                                    child: const Text('Aceptar'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                ],
                              ));
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.file_open_outlined,
                          color: Colors.blue.shade900,
                          size: 25,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Abrir inventario',
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    )),
                TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(
                                  "Esta seguro que desea eliminar el inventario \"${listproducts[index]['nombre']}\"",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.blue.shade900),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      bool rep = await sqLdb.deletedata(
                                          "DELETE FROM inventarios WHERE id = ${listproducts[index]['id']}");
                                      bool rep2 = await sqLdb.deletedata(
                                          "DROP TABLE ${listproducts[index]['basedatos']}");
                                      if (rep && rep2) {
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();
                                        // ignore: use_build_context_synchronously
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('MENSAJE'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: [
                                                  Text(
                                                    "El inventario \"${listproducts[index]['nombre']}\" fue eliminado",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                  setState(() {});
                                                },
                                                child: const Text('ACEPTAR'),
                                              ),
                                            ],
                                          ),
                                        );
                                        setState(() {});
                                      }
                                    },
                                    child: const Text('Aceptar'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                ],
                              ));
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.blue.shade900,
                          size: 25,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Eliminar inventario',
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ))
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("VOLVER"),
              ),
            ],
          );
        });
  }
}
