import 'package:flutter/material.dart';
import 'package:inventarios/interface/page/registrarse.dart';
import 'package:inventarios/interface/routes/routes.dart';

import '../page/dashboard.dart';
import '../page/home.dart';
import '../page/index.dart';
import '../page/login.dart';
import '../page/perfil.dart';

Map<String, Widget Function(BuildContext)> get appRoutes => {
      Routes.inicio: (_) => const Index(
            selectcurrentwidget: Dashboard(),
            dashindex: 0,
          ),
      Routes.success: (_) => const Index(
            selectcurrentwidget: Perfil(),
            dashindex: 2,
          ),
      Routes.login: (_) => const Login(),
      Routes.registrar: (_) => const Registrar(),
      Routes.home: (_) => const Home(),
    };
