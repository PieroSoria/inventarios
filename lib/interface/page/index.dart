import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/controller/controller.dart';
import 'package:inventarios/interface/page/consulta.dart';

import 'package:inventarios/interface/page/dashboard.dart';
import 'package:inventarios/interface/page/guardarinventario.dart';
import 'package:inventarios/interface/page/import.dart';

import 'inventarios_let.dart';
import 'conteo_let.dart';

class Index extends StatefulWidget {
  final int dashindex;
  final Widget selectcurrentwidget;
  const Index(
      {super.key, required this.selectcurrentwidget, required this.dashindex});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  final controller = Get.put(Controller());
  late Widget _currentWidget;

  String? widgetapp;
  @override
  void initState() {
    super.initState();
    controller.usardatonombre();
    _currentWidget = widget.selectcurrentwidget;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 10, 7, 49),
      extendBody: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 167, 166, 166),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 90),
          child: _currentWidget,
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(255, 167, 166, 166),
        color: Colors.grey.shade200,
        animationDuration: const Duration(milliseconds: 200),
        index: widget.dashindex,
        onTap: (index) {
          setState(() {
            if (index == 0) {
              _currentWidget = const Dashboard();
            } else if (index == 1) {
              _currentWidget = const Importdata();
            } else if (index == 2) {
              _currentWidget = const Consulta();
            } else if (index == 3) {
              _currentWidget = const Conteo();
            } else if (index == 4) {
              _currentWidget = const InventarioIDE();
            } else if (index == 5) {
              _currentWidget = const Guardainventario();
            }
          });
        },
        items: const [
          Icon(Icons.dashboard),
          Icon(Icons.replay_outlined),
          Icon(Icons.search),
          Icon(Icons.content_paste_search_outlined),
          Icon(Icons.doorbell_rounded),
          Icon(Icons.donut_large_outlined),
        ],
      ),
    );
  }
}
