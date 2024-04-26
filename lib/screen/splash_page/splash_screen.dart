import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/controller/splash_controller.dart';
import 'package:rive/rive.dart';

class SplashScreen extends GetWidget<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(),
        child: const RiveAnimation.asset('assets/icons/shapes.riv'),
      ),
    );
  }
}
