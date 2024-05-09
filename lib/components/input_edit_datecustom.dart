import 'package:flutter/material.dart';

class InputEditDateCustom extends StatefulWidget {
  const InputEditDateCustom({
    super.key,
    required this.controller,
    required this.labeltext,
    required this.nuevoitem,
    required this.press,
  });

  final TextEditingController controller;
  final String nuevoitem;
  final String labeltext;
  final Function() press;

  @override
  State<InputEditDateCustom> createState() => _InputEditDateCustomState();
}

class _InputEditDateCustomState extends State<InputEditDateCustom> {
  @override
  void initState() {
    widget.controller.text = widget.nuevoitem;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          icon: const Icon(Icons.calendar_month_outlined),
          labelText: widget.labeltext,
        ),
        onTap: widget.press,
      ),
    );
  }
}
