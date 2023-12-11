import 'package:flutter/material.dart';
import 'package:inventarios/interface/page/almacenes.dart';
import 'package:inventarios/interface/page/ubicaciones.dart';

import 'todoslosproductos.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Widget _currentWidget;
  double opcionwidth = 60;
  double opcionheight = 60;
  bool openset = false;

  @override
  void initState() {
    _currentWidget = const AlmacenesIDe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: _currentWidget,
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60,
              height: openset ? 200.0 : 60.0,
              curve: Curves.ease,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.blue.shade900,
              ),
              child: openset
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _currentWidget = const AlmacenesIDe();
                                  openset = !openset;
                                });
                              },
                              icon: const Icon(
                                Icons.home,
                                color: Colors.white,
                                size: 30,
                              )),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _currentWidget = const Ubicaciones();
                                  openset = !openset;
                                });
                              },
                              icon: const Icon(
                                Icons.location_on_outlined,
                                color: Colors.white,
                                size: 30,
                              )),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _currentWidget = const ProductosIDe();
                                  openset = !openset;
                                });
                              },
                              icon: const Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                                size: 30,
                              )),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                openset = !openset;
                              });
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          openset = !openset;
                        });
                      },
                      icon: const Icon(
                        Icons.settings,
                        size: 30,
                        color: Colors.white,
                      ),
                    )),
        ),
      ],
    );
  }
}
