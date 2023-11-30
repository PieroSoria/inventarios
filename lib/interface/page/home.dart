import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../components/btnanimation.dart';
import '../../components/showmethodlogin.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late RiveAnimationController _btnAnimationController;

  bool issigndialogo = false;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation('active', autoplay: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            bottom: 200,
            left: 100,
            child: Image.asset("assets/image/Spline.png"),
          ),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
          )),
          const RiveAnimation.asset("assets/icons/shapes.riv"),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: const SizedBox(),
          )),
          AnimatedPositioned(
            top: issigndialogo ? -50 : 0,
            duration: const Duration(milliseconds: 240),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  const SizedBox(
                    width: 330,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "APP",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Poppins",
                              fontSize: 60),
                        ),
                        Text(
                          "Inventarios",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Poppins",
                              fontSize: 55),
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Quas voluptatibus, omnis modi dicta id beatae. Suscipit, cum unde. Ipsam dolore voluptatem rerum deserunt quia nisi voluptate expedita doloribus soluta corporis.",
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  AnimatedBtn(
                    btnAnimationController: _btnAnimationController,
                    press: () {
                      _btnAnimationController.isActive = true;
                      Future.delayed(const Duration(milliseconds: 800), () {
                        setState(() {
                          issigndialogo = true;
                        });
                        showmethodlogin(context, onclose: (_) {
                          setState(() {
                            issigndialogo = false;
                          });
                        });
                      });
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Quas voluptatibus, omnis modi dicta id beatae. Suscipit, cum unde. Ipsam dolore voluptatem rerum deserunt quia nisi voluptate expedita doloribus soluta corporis.",
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            )),
          )
        ],
      ),
    );
  }
}
