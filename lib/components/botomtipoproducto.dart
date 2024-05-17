import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventariosnew/components/input_custom_form.dart';
import 'package:inventariosnew/components/input_edit_datecustom.dart';
import 'package:inventariosnew/controller/index_controller.dart';

class BotomtypePorduct extends StatefulWidget {
  const BotomtypePorduct({
    super.key,
    required this.controller,
    required this.value,
    required this.barrido,
    this.stock,
  });

  final IndexController controller;
  final String value;
  final bool barrido;
  final TextEditingController? stock;

  @override
  State<BotomtypePorduct> createState() => _BotomtypePorductState();
}

class _BotomtypePorductState extends State<BotomtypePorduct> {
  String? typeProduct;

  @override
  void initState() {
    capturartypo();
    super.initState();
  }

  void capturartypo() async {
    typeProduct =
        await widget.controller.buscarproductoType(codbarra: widget.value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 570,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          typeProduct == "1"
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 318,
                      child: InputEditCustom(
                        controller: widget.controller.comentario,
                        labeltext: 'Comentario (opcional)',
                      ),
                    ),
                    SizedBox(
                      width: 318,
                      child: InputEditCustom(
                        controller: widget.controller.valor,
                        labeltext: 'Ingrese Lote',
                      ),
                    ),
                    SizedBox(
                      width: 318,
                      child: InputEditDateCustom(
                        controller: widget.controller.fechaproconteo,
                        labeltext: "Ingrese fecha de produccion",
                        nuevoitem: "",
                        press: () async {
                          DateTime? pickdate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100));
                          if (pickdate != null) {
                            widget.controller.fechaproconteo.text =
                                DateFormat('yyyy-MM-dd').format(pickdate);
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 318,
                      child: InputEditDateCustom(
                        controller: widget.controller.fechacadconteo,
                        labeltext: "Ingrese fecha de caducacion",
                        nuevoitem: "",
                        press: () async {
                          DateTime? pickdate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100));
                          if (pickdate != null) {
                            widget.controller.fechacadconteo.text =
                                DateFormat('yyyy-MM-dd').format(pickdate);
                          }
                        },
                      ),
                    ),
                  ],
                )
              : typeProduct == "2"
                  ? Column(
                      children: [
                        SizedBox(
                          width: 318,
                          child: InputEditCustom(
                            controller: widget.controller.comentario,
                            labeltext: 'Comentario (opcional)',
                          ),
                        ),
                        SizedBox(
                          width: 318,
                          child: InputEditCustom(
                            controller: widget.controller.valor,
                            labeltext: 'Ingrese Serie',
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(
                          width: 318,
                          child: InputEditCustom(
                            controller: widget.controller.comentario,
                            labeltext: 'Comentario (opcional)',
                          ),
                        ),
                      ],
                    ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              if (widget.barrido) {
                await widget.controller.sumarconteo(codbarra: widget.value);
              } else {
                await widget.controller.actualizarConteo(
                  conteo: widget.stock!.text,
                );
              }
            },
            child: const Text(
              "Guardar",
            ),
          )
        ],
      ),
    );
  }
}
