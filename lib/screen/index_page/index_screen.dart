import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/controller/index_controller.dart';
import 'package:inventariosnew/core/routes/routes.dart';
import 'package:inventariosnew/screen/index_page/sub_page/consulta.dart';
import 'package:inventariosnew/screen/index_page/sub_page/conteo_let.dart';
import 'package:inventariosnew/screen/index_page/sub_page/dashboard.dart';
import 'package:inventariosnew/screen/index_page/sub_page/guardarinventario.dart';
import 'package:inventariosnew/screen/index_page/sub_page/import.dart';
import 'package:inventariosnew/screen/index_page/sub_page/inventarios_let.dart';

class IndexScreen extends GetWidget<IndexController> {
  const IndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Inventarios",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.settings);
            },
            icon: const Icon(
              Icons.settings,
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: Obx(() {
          final index = controller.indexpage.value;
          switch (index) {
            case 0:
              return Dashboard(
                controller: controller,
              );
            case 1:
              return Importdata(
                controller: controller,
              );
            case 2:
              return Consulta(
                controller: controller,
              );
            case 3:
              return Conteo(
                controller: controller,
              );
            case 4:
              return InventarioIDE(
                controller: controller,
              );
            case 5:
              return Guardainventario(
                controller: controller,
              );
            default:
              return Dashboard(
                controller: controller,
              );
          }
        }),
      ),
      bottomNavigationBar: Obx(
        () => CurvedNavigationBar(
          backgroundColor: Colors.blue.shade900,
          color: Colors.grey.shade200,
          animationDuration: const Duration(milliseconds: 200),
          index: controller.indexpage.value,
          onTap: (index) {
            controller.indexpage(index);
            controller.guardarindex(index);
          },
          items: [
            Icon(
              Icons.dashboard,
              color: Colors.blue.shade900,
            ),
            Icon(
              Icons.replay_outlined,
              color: Colors.blue.shade900,
            ),
            Icon(
              Icons.search,
              color: Colors.blue.shade900,
            ),
            Icon(
              Icons.content_paste_search_outlined,
              color: Colors.blue.shade900,
            ),
            Icon(
              Icons.doorbell_rounded,
              color: Colors.blue.shade900,
            ),
            Icon(
              Icons.donut_large_outlined,
              color: Colors.blue.shade900,
            ),
          ],
        ),
      ),
    );
  }
}
