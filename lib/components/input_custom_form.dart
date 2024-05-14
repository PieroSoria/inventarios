import 'package:flutter/material.dart';

class InputEditCustom extends StatelessWidget {
  const InputEditCustom({
    super.key,
    required this.controller,
    required this.labeltext,
  });

  final TextEditingController controller;
  final String labeltext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: 20,
          color: Colors.blue.shade900,
        ),
        decoration: InputDecoration(
          labelText: labeltext,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
