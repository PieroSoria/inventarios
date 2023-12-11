import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/interface/routes/app_routes.dart';
import 'package:inventarios/interface/routes/routes.dart';
import 'package:inventarios/settings/token.dart';

late bool ini;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ini = await tokendata();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key}); 

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventarios',
      initialRoute: ini == false ? Routes.home : Routes.inicio,
      routes: appRoutes,
    );
  }
}

Future<bool> tokendata() async {
  final x = TokenGet();
  String token = await x.usartoken();
  debugPrint(token);
  if (token != "") {
    return true;
  } else {
    return false;
  }
}
