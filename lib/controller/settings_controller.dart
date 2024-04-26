import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/domain/repository/local_repository_interface.dart';

class SettingController extends GetxController {
  final LocalRepositoryInterface localRepositoryInterface;
  SettingController({required this.localRepositoryInterface});

  @override
  void onInit() {
    sharedopcionedit();
    super.onInit();
  }

  final clave = TextEditingController();

  var opcionedit = false.obs;

  void sharedopcionedit() async {
    final result = await localRepositoryInterface.usarOpcionEdit();
    opcionedit(result);
  }

  void guardaropcionedit() async {
    opcionedit(!opcionedit.value);
    await localRepositoryInterface.guardaropciondeedit(
        opcionEdit: opcionedit.value);
  }

  void verificarclave() async {
    if (clave.text == "RMC123") {
      guardaropcionedit();
      clave.clear();
      Get.back();
    } else {
      clave.clear();
      Get.back();
      Get.snackbar("Error", "Clave Incorrecta");
    }
  }
}
