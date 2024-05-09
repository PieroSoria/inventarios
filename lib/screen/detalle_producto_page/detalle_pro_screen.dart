import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventariosnew/components/btnform.dart';
import 'package:inventariosnew/components/input_custom_form.dart';
import 'package:inventariosnew/components/input_edit_dateCustom.dart';
import 'package:inventariosnew/controller/detalle_pro_controller.dart';
import 'package:inventariosnew/core/routes/routes.dart';
import 'package:inventariosnew/domain/model/productos/productos.dart';

class DetalleProScreen extends GetWidget<DetalleProController> {
  final String tabla;
  final Productos productos;
  const DetalleProScreen(
      {super.key, required this.tabla, required this.productos});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Get.offAllNamed(Routes.index);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Colors.white,
            ),
          ),
          title: const Text(
            'EDITAR PRODUCTO',
            style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
          ),
          backgroundColor: Colors.blue.shade900,
        ),
        body: Container(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: GetBuilder(
              init: controller,
              initState: (_) => controller.insertardata(productos),
              builder: (_) {
                return Column(
                  children: [
                    InputEditCustom(
                      controller: controller.codbarra,
                      labeltext: 'Codigo de barra',
                    ),
                    InputEditCustom(
                      controller: controller.producto,
                      labeltext: 'ducto',
                    ),
                    InputEditCustom(
                      controller: controller.medida,
                      labeltext: 'Medida',
                    ),
                    InputEditCustom(
                      controller: controller.categoria,
                      labeltext: 'Categoria',
                    ),
                    InputEditCustom(
                      controller: controller.precio,
                      labeltext: 'Precio',
                    ),
                    InputEditCustom(
                      controller: controller.stock,
                      labeltext: 'stock inicial',
                    ),
                    InputEditCustom(
                      controller: controller.conteo,
                      labeltext: 'conteo',
                    ),
                    InputEditCustom(
                      controller: controller.diferencia,
                      labeltext: 'diferencia',
                    ),
                    InputEditCustom(
                      controller: controller.almacen,
                      labeltext: "Almacen",
                    ),
                    InputEditCustom(
                      controller: controller.subalmacen,
                      labeltext: "Sub Almacen",
                    ),
                    Obx(
                      () => Column(
                        children: [
                          RadioListTile(
                            value: "Lote",
                            groupValue: controller.selectmode.value,
                            onChanged: (value) {
                              controller.selectmode(value);
                            },
                            title: const Text("Lote"),
                            activeColor: Colors.blue.shade900,
                          ),
                          RadioListTile(
                            value: "Serie",
                            groupValue: controller.selectmode.value,
                            onChanged: (value) {
                              controller.selectmode(value);
                            },
                            title: const Text("Serie"),
                            activeColor: Colors.blue.shade900,
                          ),
                          RadioListTile(
                            value: "Ninguno",
                            groupValue: controller.selectmode.value,
                            onChanged: (value) {
                              controller.selectmode(value);
                            },
                            title: const Text("Ninguno"),
                            activeColor: Colors.blue.shade900,
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => controller.selectmode.value == "Lote"
                          ? Column(
                              children: [
                                InputEditCustom(
                                  controller: controller.lote,
                                  labeltext: 'lote',
                                ),
                                InputEditCustom(
                                  controller: controller.numlote,
                                  labeltext: 'numero de lote',
                                ),
                                InputEditDateCustom(
                                  controller: controller.fechapro,
                                  nuevoitem: productos.fechapro.toString(),
                                  labeltext: 'Seleccione la fecha',
                                  press: () async {
                                    DateTime? pickdate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100));
                                    if (pickdate != null) {
                                      controller.fechapro.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickdate);
                                    }
                                  },
                                ),
                                InputEditDateCustom(
                                  controller: controller.fechacad,
                                  nuevoitem: productos.fechacad.toString(),
                                  labeltext: 'Seleccione la fecha',
                                  press: () async {
                                    DateTime? pickdate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100));
                                    if (pickdate != null) {
                                      controller.fechacad.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickdate);
                                    }
                                  },
                                ),
                              ],
                            )
                          : controller.selectmode.value == "Serie"
                              ? Column(
                                  children: [
                                    InputEditCustom(
                                      controller: controller.serie,
                                      labeltext: 'Serie',
                                    ),
                                    InputEditCustom(
                                      controller: controller.numserie,
                                      labeltext: 'numero de serie',
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Btnform(
                        funcion: () async {
                          controller.actualizarproductobyid(
                            id: productos.id,
                            tabla: tabla,
                          );
                        },
                        label: "MODIFICAR PRODUCTO",
                        color: Colors.blue.shade900,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Btnform(
                        funcion: () {
                          Navigator.of(context).pop();
                        },
                        label: "CANCELAR",
                        color: Colors.blue.shade900,
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

