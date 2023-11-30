import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final void Function(String)? onChanged;
  final String label;
  final TextInputType? inputType;
  final bool ispassword;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final Icon icon;
  final Color color;
  const CustomInputField(
      {super.key,
      this.onChanged,
      required this.label,
      this.inputType,
      this.ispassword = false,
      this.validator,
      required this.controller,
      required this.icon,
      required this.color});

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool _obscureText;
  String? _errorText;

  @override
  void initState() {
    _obscureText = widget.ispassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.controller,
            obscureText: _obscureText,
            keyboardType: widget.inputType,
            onChanged: (text) {
              setState(() {
                _errorText = widget.validator?.call(text);
              });
              widget.onChanged?.call(text);
            },
            decoration: InputDecoration(
              prefixIcon: widget.icon,
              prefixIconColor: widget.color,
              labelText: widget.label,
              labelStyle:
                  const TextStyle(color: Colors.black, fontFamily: "Poppins"),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              suffixIcon: widget.ispassword
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                    )
                  : null,
            ),
          ),
          if (_errorText != null && widget.controller.text.isNotEmpty)
            Text(
              _errorText!,
              style: const TextStyle(color: Colors.redAccent),
            ),
        ],
      ),
    );
  }
}
