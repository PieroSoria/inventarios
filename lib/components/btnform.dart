import 'package:flutter/material.dart';

class Btnform extends StatefulWidget {
  final Function() funcion;
  final String label;
  final Color color;
  const Btnform({super.key, required this.funcion, required this.label, required this.color});

  @override
  State<Btnform> createState() => _BtnformState();
}

class _BtnformState extends State<Btnform> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.funcion,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: widget.color,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.all(16.0),
      ),
      child: Text(
        widget.label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
