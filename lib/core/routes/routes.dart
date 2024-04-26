import 'package:get/get.dart';
import 'package:inventariosnew/dependency/detalle_almacen_binding.dart';
import 'package:inventariosnew/dependency/detalle_inventario_binding.dart';
import 'package:inventariosnew/dependency/detalle_pro_binding.dart';
import 'package:inventariosnew/dependency/home_binding.dart';
import 'package:inventariosnew/dependency/index_binding.dart';
import 'package:inventariosnew/dependency/main_binding.dart';
import 'package:inventariosnew/dependency/setting_bindings.dart';
import 'package:inventariosnew/dependency/splash_binding.dart';
import 'package:inventariosnew/screen/detalle_almacen_page/detalle_almacen_screen.dart';
import 'package:inventariosnew/screen/detalle_inventario_page/detalle_inventario_screen.dart';
import 'package:inventariosnew/screen/detalle_producto_page/detalle_pro_screen.dart';
import 'package:inventariosnew/screen/home_page/home.dart';
import 'package:inventariosnew/screen/index_page/index_screen.dart';
import 'package:inventariosnew/screen/setting_page/settings_screen.dart';
import 'package:inventariosnew/screen/splash_page/splash_screen.dart';

abstract class Routes {
  static const splash = '/';
  static const index = '/index';
  static const detallepro = '/detallepro';
  static const detallealma = '/detallealma';
  static const detalleinven = '/detalleinven';
  static const home = '/home';
  static const settings = '/settings';
}

class AppRoutes {
  static final approutes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      bindings: [
        MainBinding(),
        SplashBinding(),
      ],
    ),
    GetPage(
      name: Routes.index,
      page: () => const IndexScreen(),
      bindings: [
        MainBinding(),
        IndexBinding(),
      ],
    ),
    GetPage(
      name: Routes.detallepro,
      page: () {
        DetalleProScreen detalleProScreen = Get.arguments;
        return detalleProScreen;
      },
      bindings: [
        MainBinding(),
        DetalleProBinding(),
      ],
    ),
    GetPage(
      name: Routes.detalleinven,
      page: () {
        DetalleInventarioScreen detalleProScreen = Get.arguments;
        return detalleProScreen;
      },
      bindings: [
        MainBinding(),
        DetalleInventarioBinding(),
      ],
    ),
    GetPage(
      name: Routes.detallealma,
      page: () {
        DetalleAlmacenScreen detallealma = Get.arguments;
        return detallealma;
      },
      bindings: [
        MainBinding(),
        DetalleAlmacenBinding(),
      ],
    ),
    GetPage(
      name: Routes.home,
      page: () => const Home(),
      bindings: [
        MainBinding(),
        HomeBinding(),
      ],
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsScreen(),
      bindings: [
        MainBinding(),
        SettingsBinding(),
      ],
    )
  ];
}
