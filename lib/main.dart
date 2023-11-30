import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/interface/routes/app_routes.dart';
import 'package:inventarios/interface/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventarios',
      initialRoute: Routes.home,
      routes: appRoutes,
    );
  }
}


