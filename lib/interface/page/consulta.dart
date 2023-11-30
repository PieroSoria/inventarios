// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:inventarios/database/function/funciones_basicas.dart';

class Consulta extends StatefulWidget {
  const Consulta({super.key});

  @override
  State<Consulta> createState() => _ConsultaState();
}

class _ConsultaState extends State<Consulta> {
  TextEditingController selectalmacen = TextEditingController();
  FuncionesBasic funciones = FuncionesBasic();
  String? _selectedItem;
  TextEditingController searchController = TextEditingController();
  String searchText = '';
  List<String> dropdownItems = ["TODOS", "CONTADOS", "NO CONTADOS"];
  Future<List<Map>> getAllProducts({required String selectalmacen}) async {
    String? tabla = await funciones.obtenerNombreInventarioActivo();
    String query = "SELECT * FROM '$tabla'";
    if (searchText == '' && selectalmacen == "TODOS") {
      query;
    } else if (searchText == '' && selectalmacen == "CONTADOS") {
      query += " WHERE conteo IS NOT NULL AND conteo != '0'";
    } else if (searchText == '' && selectalmacen == "NO CONTADOS") {
      query += " WHERE conteo IS NULL OR conteo = '0'";
    } else if (searchText != "" && selectalmacen == "TODOS") {
      query += " WHERE codbarra LIKE '%$searchText%'";
    } else if (searchText != "" && selectalmacen == "NO CONTADOS") {
      query +=
          " WHERE codbarra LIKE '%$searchText%' AND conteo IS NULL OR conteo = '0'";
    } else if (searchText != "" && selectalmacen == "CONTADOS") {
      query +=
          " WHERE codbarra LIKE '%$searchText%' AND conteo IS NOT NULL AND conteo != '0'";
    }

    List<Map> products = await funciones.getData(query);
    return products;
  }

  Future<void> refreshData() async {
    setState(() {
      getAllProducts(selectalmacen: selectalmacen.text);
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedItem = dropdownItems.first;
    selectalmacen.text = _selectedItem.toString();
    getAllProducts(selectalmacen: _selectedItem!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      // ignore: avoid_unnecessary_containers
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: RefreshIndicator(
          onRefresh: refreshData,
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "widget.widget.user",
                    textAlign: TextAlign.right,
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
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: searchController,
                onSubmitted: (value) {
                  setState(() {
                    searchText = value;
                    searchController.text = '';
                  });
                },
                decoration: InputDecoration(
                    labelText: 'Ingrese codigo de barra',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  // ignore: avoid_unnecessary_containers
                  child: Container(
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
                                      Icons.shopping_cart_outlined,
                                      color: Colors.blue.shade900,
                                      size: 20,
                                    ),
                                    title: Text(
                                      "${listproducts[index]['codbarra']}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue.shade900),
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Text(
                                            "${listproducts[index]['descripcion']}"),
                                      ],
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Conteo: ${listproducts[index]['conteo']}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                        Text(
                                          "Stock Teorico: ${listproducts[index]['stock_inicial']}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
