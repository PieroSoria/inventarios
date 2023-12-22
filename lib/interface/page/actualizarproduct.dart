import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/controller/controller.dart';
import 'package:inventarios/database/function/funciones_basicas.dart';
import 'package:inventarios/models/productos/productos.dart';
import 'package:intl/intl.dart';

import '../../components/btnform.dart';
import '../../database/createdb/database.dart';

class ActualizarPro extends StatefulWidget {
  final String tabla;
  final Productos productos;
  const ActualizarPro(
      {super.key, required this.productos, required this.tabla});

  @override
  State<ActualizarPro> createState() => _ActualizarProState();
}

class _ActualizarProState extends State<ActualizarPro> {
  final codigo = TextEditingController();
  final codbarra = TextEditingController();
  final descripcion = TextEditingController();
  final medida = TextEditingController();
  final categoria = TextEditingController();
  final precio = TextEditingController();
  final stock = TextEditingController();
  final conteo = TextEditingController();
  final diferencia = TextEditingController();
  final ubicacion = TextEditingController();
  final sububicacion = TextEditingController();
  final lote = TextEditingController();
  final numlote = TextEditingController();
  final fechapro = TextEditingController();
  final fechacad = TextEditingController();
  final serie = TextEditingController();
  final numserie = TextEditingController();
  DateTime? selectedDate;
  late bool loteyserie;
  FuncionesBasic funcioness = FuncionesBasic();
  final controller = Get.put(Controller());
  String _selectedItem = "SELECCIONAR UBICACION";
  String _selectedItem2 = "SELECCIONAR SUBUBICACION";

  SQLdb funciones = SQLdb();

  void loteserie(String lote, String serie) {
    if (lote == '1') {
      setState(() {
        loteyserie = false;
      });
    } else if (serie == "1") {
      setState(() {
        loteyserie = true;
      });
    }
  }

  @override
  void initState() async {
    codigo.text = widget.productos.codigo;
    codbarra.text = widget.productos.codbarra;
    descripcion.text = widget.productos.descripcion;
    medida.text = widget.productos.medida;
    categoria.text = widget.productos.categoria;
    precio.text = widget.productos.precio;
    stock.text = widget.productos.stock;
    conteo.text = widget.productos.conteo;
    diferencia.text = widget.productos.diferencia;
    ubicacion.text = widget.productos.ubicacion;
    sububicacion.text = widget.productos.sububicacion;
    lote.text = widget.productos.lote;
    numlote.text = widget.productos.numlote;
    fechapro.text = widget.productos.fechapro;
    fechacad.text = widget.productos.fechacad;
    serie.text = widget.productos.serie;
    numserie.text = widget.productos.numserie;
    controller.initDropdownItemsubicacion();
    loteserie(lote.text, serie.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            )),
        title: const Text(
          'EDITAR PRODUCTO',
          style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  controller: codigo,
                  style: TextStyle(fontSize: 20, color: Colors.blue.shade900),
                  decoration: InputDecoration(
                    labelText: 'codigo',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  controller: codbarra,
                  style: TextStyle(fontSize: 20, color: Colors.blue.shade900),
                  decoration: InputDecoration(
                    labelText: 'codigo de barra',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  controller: descripcion,
                  style: TextStyle(fontSize: 20, color: Colors.blue.shade900),
                  decoration: InputDecoration(
                    labelText: 'descripcion',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  controller: medida,
                  style: TextStyle(fontSize: 20, color: Colors.blue.shade900),
                  decoration: InputDecoration(
                    labelText: 'medida',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  controller: categoria,
                  style: TextStyle(fontSize: 20, color: Colors.blue.shade900),
                  decoration: InputDecoration(
                    labelText: 'categoria',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  controller: precio,
                  style: TextStyle(fontSize: 20, color: Colors.blue.shade900),
                  decoration: InputDecoration(
                    labelText: 'precio',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  controller: stock,
                  style: TextStyle(fontSize: 20, color: Colors.blue.shade900),
                  decoration: InputDecoration(
                    labelText: 'stock inicial',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  controller: conteo,
                  style: TextStyle(fontSize: 20, color: Colors.blue.shade900),
                  decoration: InputDecoration(
                    labelText: 'conteo',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  controller: diferencia,
                  style: TextStyle(fontSize: 20, color: Colors.blue.shade900),
                  decoration: InputDecoration(
                    labelText: 'diferencia',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Obx(
                  () => DropdownButton<dynamic>(
                    isExpanded: true,
                    value: _selectedItem,
                    items: controller.dropdownitemubicacion.map((dynamic item) {
                      return DropdownMenuItem<dynamic>(
                        value: item,
                        child: Center(child: Text(item.toString())),
                      );
                    }).toList(),
                    onChanged: (dynamic selectedItem) {
                      setState(() {
                        _selectedItem = selectedItem;
                        ubicacion.text = _selectedItem.toString();
                        _selectedItem2 = "SELECCIONAR SUBUBICACION";
                        controller.initDropdownItemssububicacion(selectedItem);
                      });
                    },
                    style: TextStyle(color: Colors.blue.shade900, fontSize: 18),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Obx(
                  () => DropdownButton<dynamic>(
                    isExpanded: true,
                    value: _selectedItem2,
                    items:
                        controller.dropdownitemsububicacion.map((dynamic item) {
                      return DropdownMenuItem<dynamic>(
                          value: item,
                          child: Center(child: Text(item.toString())));
                    }).toList(),
                    onChanged: (dynamic selectedItem) {
                      setState(() {
                        _selectedItem2 = selectedItem;
                        sububicacion.text = _selectedItem2.toString();
                      });
                    },
                    style: TextStyle(color: Colors.blue.shade900, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("LOTE"),
                    ),
                    Switch(
                        value: loteyserie,
                        onChanged: (bool value) {
                          setState(() {
                            loteyserie = value;
                          });
                        }),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("SERIE"),
                    )
                  ],
                ),
              ),
              Container(
                child: loteyserie == false
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: TextField(
                              controller: lote,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.blue.shade900),
                              decoration: InputDecoration(
                                labelText: 'lote',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: TextField(
                              controller: numlote,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.blue.shade900),
                              decoration: InputDecoration(
                                labelText: 'numero de lote',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: TextField(
                              controller: fechapro,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.calendar_month_outlined),
                                labelText: "Seleccione fecha",
                              ),
                              onTap: () async {
                                DateTime? pickdate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100));
                                if (pickdate != null) {
                                  setState(() {
                                    fechapro.text = DateFormat('yyyy-MM-dd')
                                        .format(pickdate);
                                  });
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: TextField(
                              controller: fechacad,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.calendar_month_outlined),
                                labelText: "Seleccione fecha",
                              ),
                              onTap: () async {
                                DateTime? pickdate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100));
                                if (pickdate != null) {
                                  setState(() {
                                    fechapro.text = DateFormat('yyyy-MM-dd')
                                        .format(pickdate);
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: TextField(
                              controller: serie,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.blue.shade900),
                              decoration: InputDecoration(
                                labelText: 'serie',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: TextField(
                              controller: numserie,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.blue.shade900),
                              decoration: InputDecoration(
                                labelText: 'numero de serie',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Btnform(
                    funcion: () async {
                      bool rep = await funciones.updatedata('''
                  UPDATE ${widget.tabla} SET
                    codigo = "${codigo.text}",
                    codbarra = "${codbarra.text}",
                    descripcion = "${descripcion.text}",
                    medida = "${medida.text}",
                    categoria = "${categoria.text}",
                    precio = "${precio.text}",
                    stock_inicial = "${stock.text}",
                    conteo = "${conteo.text}",
                    diferencia = "${diferencia.text}",
                    ubicacion = "${ubicacion.text}",
                    sububicacion = "${sububicacion.text}",
                    lote = "${lote.text}",
                    num_lote = "${numlote.text}",
                    fecha_pro = "${fechapro.text}",
                    fecha_cad = "${fechacad.text}",
                    serie = "${serie.text}",
                    num_serie = "${numserie.text}"
                    WHERE id = "${widget.productos.id}"
                    ''');
                      if (rep) {
                        Get.snackbar(
                            "Exito", "Se actualizo correctamente el producto");
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      }
                    },
                    label: "MODIFICAR ALMACEN",
                    color: Colors.blue.shade900),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Btnform(
                    funcion: () {
                      Navigator.of(context).pop();
                    },
                    label: "CANCELAR",
                    color: Colors.blue.shade900),
              )
            ],
          ),
        ),
      ),
    );
  }
}
