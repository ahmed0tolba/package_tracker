import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final String regexp; // "[0-9a-zA-Z]"
  final bool enabled;
  final int maxLength;
  final int minLines;
  final int maxLines;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.regexp = (r'^.*'),
    this.enabled = true,
    this.maxLength = 50,
    this.minLines = 1,
    this.maxLines = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0),
      child: TextField(
        controller: controller,
        maxLength: maxLength,
        enabled: enabled,
        minLines: minLines,
        maxLines: maxLines,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(regexp)),
        ], // Only numbers can be entered
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}
