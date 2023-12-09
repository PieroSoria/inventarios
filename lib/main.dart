import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventarios/interface/routes/app_routes.dart';
import 'package:inventarios/interface/routes/routes.dart';
import 'package:inventarios/settings/token.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: tokendata(),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Inventarios',
              initialRoute: Routes.inicio,
              routes: appRoutes,
            );
          } else {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Inventarios',
              initialRoute: Routes.home,
              routes: appRoutes,
            );
          }
        });
  }

  Future<bool> tokendata() async {
    final x = TokenGet();
    String token = await x.usartoken();
    if(token.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }
}
