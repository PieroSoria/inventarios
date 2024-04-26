import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/core/routes/routes.dart';
import 'package:inventariosnew/dependency/main_binding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Inventarios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade900,
        ),
      ),
      initialRoute: Routes.splash,
      getPages: AppRoutes.approutes,
      initialBinding: MainBinding(),
    );
  }
}
