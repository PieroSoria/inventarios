import 'package:flutter/material.dart';

class Btnform extends StatelessWidget {
  final Function() funcion;
  final String label;
  final Color color;
  const Btnform(
      {super.key,
      required this.funcion,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: funcion,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(16.0),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
