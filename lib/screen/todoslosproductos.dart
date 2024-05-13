import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/controller/index_controller.dart';
import 'package:inventariosnew/core/routes/routes.dart';
import 'package:inventariosnew/screen/detalle_producto_page/detalle_pro_screen.dart';

class ProductosIDe extends StatefulWidget {
  final IndexController controller;
  const ProductosIDe({super.key, required this.controller});

  @override
  State<ProductosIDe> createState() => _ProductosIDeState();
}

class _ProductosIDeState extends State<ProductosIDe> {
  @override
  void initState() {
    widget.controller.cargartodoslosproducts(
      search: null,
      almacen: null,
    );
    widget.controller.cargaralmacenesitem();
    super.initState();
  }

  @override
  void dispose() {
    eliminardata();
    super.dispose();
  }

  void eliminardata() async {
    widget.controller.selectalmacenfiltro("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Busca el producto entre todos los inventarios",
                style: TextStyle(fontFamily: "Poppins"),
              ),
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
                onChanged: (String value) {
                  widget.controller.cargartodoslosproducts(
                    search: value,
                    almacen: widget.controller.selectedItem.value,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Obx(
                    () => DropdownButton<dynamic>(
                      isExpanded: true,
                      value: widget.controller.selectalmacenfiltro.value != ""
                          ? widget.controller.selectalmacenfiltro.value
                          : null,
                      hint: const Center(child: Text("Seleccionar una opcion")),
                      items: widget.controller.listalmacenes.map((item) {
                        return DropdownMenuItem<dynamic>(
                          value: item,
                          child: Center(
                            child: Text(
                              item.toString(),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) async {
                        widget.controller.selectalmacenfiltro(value.toString());

                        await widget.controller.cargartodoslosproducts(
                          search: null,
                          almacen: widget.controller.selectalmacenfiltro.value,
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      icon: IconButton(
                        onPressed: () {
                          widget.controller.selectalmacenfiltro("");
                          widget.controller.cargartodoslosproducts(
                            search: null,
                            almacen: null,
                          );
                        },
                        icon: const Icon(Icons.backspace_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                "LISTA DE PRODUCTOS",
                style: TextStyle(fontFamily: "Poppins", fontSize: 25),
              ),
            ),
            Expanded(
              flex: 6,
              child: Obx(
                () => ListView.builder(
                  itemCount: widget.controller.productostotal.length,
                  itemBuilder: (context, index) {
                    final listproducts = widget.controller.productostotal;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          title: Text(listproducts[index].producto),
                          subtitle: Text(listproducts[index].codbarra),
                          trailing: Obx(
                            () => widget.controller.opcionedit.value
                                ? IconButton(
                                    onPressed: () {
                                      Get.toNamed(
                                        Routes.detallepro,
                                        arguments: DetalleProScreen(
                                          tabla: listproducts[index].tdatos,
                                          productos: listproducts[index],
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
