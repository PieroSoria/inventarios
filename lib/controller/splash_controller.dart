import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventariosnew/core/routes/routes.dart';
import 'package:inventariosnew/domain/repository/local_repository_interface.dart';

class SplashController extends GetxController {
  final LocalRepositoryInterface localRepositoryInterface;
  SplashController({required this.localRepositoryInterface});

  @override
  void onReady() {
    verificaciondesession();
    super.onReady();
  }

  void verificaciondesession() async {
    final result = await localRepositoryInterface.usartoken();

    if (result != null) {
      final fechacadStr = await localRepositoryInterface.compararfechacad();
      DateTime fechacad = DateFormat('yyyy-MM-dd').parse(fechacadStr!);
      if (fechacad.isAfter(DateTime.now())) {
        Get.offNamed(Routes.index);
      } else {
        Get.offNamed(Routes.home);
      }
    } else {
      Get.offNamed(Routes.home);
    }
  }
}
