import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AnimatedBtn extends StatelessWidget {
  const AnimatedBtn({
    super.key,
    required RiveAnimationController btnAnimationController,
    required this.press,
  }) : _btnAnimationController = btnAnimationController;

  final RiveAnimationController _btnAnimationController;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          height: 64,
          width: 260,
          child: Stack(
            children: [
              RiveAnimation.asset(
                "assets/icons/button.riv",
                controllers: [_btnAnimationController],
              ),
              const Positioned.fill(
                  top: 8,
                  left: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(Icons.arrow_forward_sharp),
                      ),
                      Text(
                        "Start the course",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontFamily: "Poppins"),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
