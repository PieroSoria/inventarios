import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/controller/controller.dart';

import '../../models/productos/productos.dart';
import 'actualizarproduct.dart';

class ProductosIDe extends StatefulWidget {
  const ProductosIDe({super.key});

  @override
  State<ProductosIDe> createState() => _ProductosIDeState();
}

class _ProductosIDeState extends State<ProductosIDe> {
  final controller = Get.put(Controller());

  @override
  void initState() {
    controller.cargarDatosInventarios(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(color: Colors.grey[50]),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Card(
                color: Colors.blueGrey[50],
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        "Busca el producto entre todos los inventarios",
                        style: TextStyle(fontFamily: "Poppins"),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.shopping_cart),
                              prefixIconColor: Colors.black,
                              labelText: "Buscar Producto",
                              labelStyle: const TextStyle(
                                  color: Colors.black, fontFamily: "Poppins"),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onChanged: (String value){
                              controller.cargarDatosInventarios(value);
                            },
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 200,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20))),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
                    child: Text(
                      "LISTA DE PRODUCTOS",
                      style: TextStyle(fontFamily: "Poppins", fontSize: 25),
                    ),
                  ),
                  Expanded(
                      flex: 6,
                      child: Obx(
                        () => ListView.builder(
                          itemCount: controller.productostotal.length,
                          itemBuilder: (context, index) {
                            final listproducts = controller.productostotal;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                  title: Text(listproducts[index].descripcion),
                                  subtitle: Text(listproducts[index].codbarra),
                                  trailing: IconButton(
                                      onPressed: () {
                                        final pro = Productos(
                                            id: listproducts[index].id,
                                            codigo: listproducts[index].codigo,
                                            codbarra:
                                                listproducts[index].codbarra,
                                            descripcion:
                                                listproducts[index].descripcion,
                                            medida: listproducts[index].medida,
                                            categoria:
                                                listproducts[index].categoria,
                                            precio: listproducts[index].precio,
                                            stock: listproducts[index].stock,
                                            conteo: listproducts[index].conteo,
                                            diferencia:
                                                listproducts[index].diferencia,
                                            ubicacion:
                                                listproducts[index].ubicacion,
                                            sububicacion: listproducts[index]
                                                .sububicacion,
                                            lote: listproducts[index].lote,
                                            numlote:
                                                listproducts[index].numlote,
                                            fechapro:
                                                listproducts[index].fechapro,
                                            fechacad:
                                                listproducts[index].fechacad,
                                            serie: listproducts[index].serie,
                                            numserie:
                                                listproducts[index].numserie,
                                            tdatos: listproducts[index].tdatos);

                                        Get.to(() => ActualizarPro(
                                              productos: pro,
                                              tabla: listproducts[index].tdatos,
                                            ));
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                      )),
                                ),
                              ),
                            );
                          },
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
