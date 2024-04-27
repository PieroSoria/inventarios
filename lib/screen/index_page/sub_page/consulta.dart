import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/controller/index_controller.dart';

class Consulta extends StatefulWidget {
  final IndexController controller;
  const Consulta({super.key, required this.controller});

  @override
  State<Consulta> createState() => _ConsultaState();
}

class _ConsultaState extends State<Consulta> {
  List<String> dropdownItems = ["TODOS", "CONTADOS", "NO CONTADOS"];

  @override
  void initState() {
    super.initState();
    widget.controller.selectedItem(dropdownItems.first);
    widget.controller
        .getAllProducts(selectalmacen: widget.controller.selectedItem.value);
  }

  @override
  void dispose() {
    eliminardata();
    super.dispose();
  }

  void eliminardata() {
    widget.controller.selectedItem("");
    widget.controller.searchText("");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  widget.controller.nombreuser.value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
              ),
            ],
          ),
          Obx(
            () => DropdownButton<String>(
              isExpanded: true,
              value: widget.controller.selectedItem.value != ""
                  ? widget.controller.selectedItem.value
                  : null,
              hint: const Center(child: Text("Selecciona una opcion")),
              items: dropdownItems.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Center(child: Text(item)),
                );
              }).toList(),
              onChanged: (String? selectedItem) {
                if (dropdownItems.contains(selectedItem)) {
                  setState(() {
                    widget.controller.selectedItem(selectedItem);
                    widget.controller.getAllProducts(
                      selectalmacen: widget.controller.selectedItem.value,
                    );
                  });
                }
              },
              style: TextStyle(
                color: Colors.blue.shade900,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: TextField(
              controller: widget.controller.searchalmacen,
              onChanged: (value) async {
                widget.controller.searchText(value);
                await widget.controller.getAllProducts(
                  selectalmacen: widget.controller.selectedItem.value,
                );
              },
              decoration: InputDecoration(
                labelText: 'Ingrese codigo de barra',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Obx(() {
              final data = widget.controller.productostotal;
              if (data.isNotEmpty) {
                return ListView.builder(
                  itemCount: widget.controller.productostotal.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.blue.shade900,
                          size: 20,
                        ),
                        title: Text(
                          widget.controller.productostotal[index].codbarra,
                          style: TextStyle(
                              fontSize: 16, color: Colors.blue.shade900),
                        ),
                        subtitle: Column(
                          children: [
                            Text(
                              widget.controller.productostotal[index].producto,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Conteo: ${widget.controller.productostotal[index].conteo}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 11),
                                ),
                                Text(
                                  "Stock Teorico: ${widget.controller.productostotal[index].stock}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                            Obx(
                              () => widget.controller.opcionedit.value
                                  ? IconButton(
                                      onPressed: () async {
                                        widget.controller.actualizarproducto(
                                            productos: widget.controller
                                                .productostotal[index]);
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blue.shade900,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text("No se encontro nada"),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
