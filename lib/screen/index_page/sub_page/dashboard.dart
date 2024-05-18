import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/controller/index_controller.dart';
import 'package:inventariosnew/screen/almacenes.dart';
import 'package:inventariosnew/screen/todoslosproductos.dart';

class Dashboard extends StatefulWidget {
  final IndexController controller;
  const Dashboard({super.key, required this.controller});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    widget.controller.indexpagedashboard(0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(() {
        final index = widget.controller.indexpagedashboard.value;
        switch (index) {
          case 0:
            return AlmacenesIDe(
              controller: widget.controller,
            );

          case 1:
            return ProductosIDe(
              controller: widget.controller,
            );
          default:
            return AlmacenesIDe(
              controller: widget.controller,
            );
        }
      }),
      floatingActionButton: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 60,
          height: widget.controller.openset.value ? 160.0 : 60.0,
          curve: Curves.ease,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.blue.shade900,
          ),
          child: widget.controller.openset.value
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          widget.controller.indexpagedashboard(0);
                          widget.controller
                              .openset(widget.controller.openset.value);
                        },
                        icon: const Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget.controller.indexpagedashboard(1);
                          widget.controller
                              .openset(widget.controller.openset.value);
                        },
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget.controller
                              .openset(!widget.controller.openset.value);
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
                    widget.controller.openset(!widget.controller.openset.value);
                  },
                  icon: const Icon(
                    Icons.menu,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
