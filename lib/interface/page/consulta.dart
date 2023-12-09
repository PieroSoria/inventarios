// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/controller/controller.dart';
import 'package:inventarios/database/function/funciones_basicas.dart';
import 'package:inventarios/models/productos/productos.dart';

import 'actualizarproduct.dart';

class Consulta extends StatefulWidget {
  const Consulta({super.key});

  @override
  State<Consulta> createState() => _ConsultaState();
}

class _ConsultaState extends State<Consulta> {
  TextEditingController selectalmacen = TextEditingController();
  final controller = Get.put(Controller());
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
                  Obx(
                    () => Text(
                      controller.nombreuser.value,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900),
                    ),
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
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Conteo: ${listproducts[index]['conteo']}",
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 11),
                                            ),
                                            Text(
                                              "Stock Teorico: ${listproducts[index]['stock_inicial']}",
                                              textAlign: TextAlign.center,
                                              style:
                                                  const TextStyle(fontSize: 11),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              String? tabla = await funciones
                                                  .obtenerNombreInventarioActivo();
                                              final pro = Productos(
                                                  id: listproducts[index]['id'],
                                                  codigo: listproducts[index]
                                                      ['codigo'],
                                                  codbarra: listproducts[index]
                                                      ['codbarra'],
                                                  descripcion: listproducts[index]
                                                      ['descripcion'],
                                                  medida: listproducts[index]
                                                      ['medida'],
                                                  categoria: listproducts[index]
                                                      ['categoria'],
                                                  precio: listproducts[index]
                                                      ['precio'],
                                                  stock: listproducts[index]
                                                      ['stock_inicial'],
                                                  conteo: listproducts[index]
                                                      ['conteo'],
                                                  diferencia: listproducts[index]
                                                      ['diferencia'],
                                                  ubicacion: listproducts[index]
                                                      ['ubicacion'],
                                                  sububicacion: listproducts[index]
                                                      ['sububicacion'],
                                                  lote: listproducts[index]
                                                      ['lote'],
                                                  numlote: listproducts[index]
                                                      ['num_lote'],
                                                  fechapro: listproducts[index]
                                                      ['fecha_pro'],
                                                  fechacad: listproducts[index]['fecha_cad'],
                                                  serie: listproducts[index]['serie'],
                                                  numserie: listproducts[index]['num_serie']);
                                              if (tabla != null) {
                                                Get.to(() => ActualizarPro(
                                                      productos: pro,
                                                      tabla: tabla,
                                                    ));
                                              }
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.blue.shade900,
                                            ))
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
