import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/interface/routes/routes.dart';
import 'package:inventarios/models/productos/productos.dart';

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

  SQLdb funciones = SQLdb();
  @override
  void initState() {
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
              Btnform(
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
                  num_serie = "${numserie.text}",
                  WHERE id = "${widget.productos.id}"
                  ''');
                    if (rep) {
                      Get.snackbar(
                          "Exito", "Se actualizo correctamente el almacen");
                      Get.toNamed(Routes.inicio);
                    }
                  },
                  label: "MODIFICAR ALMACEN",
                  color: Colors.blue.shade900),
              Btnform(
                  funcion: () {
                    Navigator.of(context).pop();
                  },
                  label: "CANCELAR",
                  color: Colors.blue.shade900)
            ],
          ),
        ),
      ),
    );
  }
}
