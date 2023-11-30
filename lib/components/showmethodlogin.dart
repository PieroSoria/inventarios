import 'package:flutter/material.dart';
import 'package:inventarios/interface/page/perfil.dart';

void showmethodlogin(BuildContext context, {required ValueChanged onclose}) {
  showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "Sign In",
      context: context,
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (_, animation, __, child) {
        Tween<Offset> tween;
        tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
        return SlideTransition(
          position: tween.animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
          child: child,
        );
      },
      pageBuilder: (context, _, __) => Center(
              child: Container(
            height: 620,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.94),
                borderRadius: const BorderRadius.all(Radius.circular(40))),
            child: const Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              // body: Stack(
              //   clipBehavior: Clip.none,
              //   children: [
              //     const Login(),
              //     Positioned(
              //         left: 0,
              //         right: 0,
              //         bottom: -60,
              //         child: CircleAvatar(
              //           radius: 30,
              //           backgroundColor: Colors.white,
              //           child: Transform.scale(
              //             scale: 1.7,
              //             child: const Icon(
              //               Icons.close,
              //               color: Colors.black,
              //             ),
              //           ),
              //         ))
              //   ],
              // )),
              body: Perfil(),
            ),
          ))).then((onclose));
}


