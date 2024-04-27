import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventariosnew/components/input_form.dart';
import 'package:inventariosnew/controller/home_controller.dart';
import 'package:inventariosnew/screen/registrarse.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends GetWidget<HomeController> {
  const Home({super.key});

  void _launchWhatsapp() async {
    var whatsapp = "981229283";
    var message = "buenas quiero comprar una licencia de inventarios";
    var whatsappUrl =
        "whatsapp://send?phone=$whatsapp&text=${Uri.encodeComponent(message)}";

    try {
      await launchUrl(Uri.parse(whatsappUrl));
    } catch (e) {
      Get.snackbar(
        "Error",
        "No se pudo abrir el whatsapp",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  _launchGmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'COMERCIAL@RMC.PE',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Comprar Licencia',
      }),
    );
    launchUrl(emailLaunchUri);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/image/logo.jpg",
                height: 350,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: CustomInputField(
                  label: "E-mail",
                  controller: controller.email,
                  icon: const Icon(Icons.person),
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: CustomInputField(
                  label: "Password",
                  controller: controller.password,
                  ispassword: true,
                  icon: const Icon(Icons.lock),
                  color: Colors.black,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.iniciarSession();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blue.shade900,
                ),
                child: const Text(
                  "Iniciar Session",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => Registrar(controller: controller));
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blue.shade900,
                ),
                child: const Text(
                  "Registrarse",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Get.to(() => Registrar(controller: controller));
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        decoration: const BoxDecoration(),
                        width: double.infinity,
                        height: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: _launchWhatsapp,
                              child: Image.asset(
                                'assets/image/what.png',
                                width: 150,
                                height: 150,
                              ),
                            ),
                            GestureDetector(
                              onTap: _launchGmail,
                              child: Image.asset(
                                'assets/image/gmail.jpg',
                                width: 150,
                                height: 150,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blue.shade900,
                ),
                child: const Text(
                  "Comprar Licencia",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        decoration: const BoxDecoration(),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: CustomInputField(
                                label: "Ingresar Licencia",
                                controller: controller.licencia,
                                icon: const Icon(Icons.track_changes_outlined),
                                color: Colors.black,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                controller.cargarlicencia();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Colors.blue.shade900,
                              ),
                              child: const Text(
                                "Cargar Licencia",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blue.shade900,
                ),
                child: const Text(
                  "Ingresar Licencia",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
