import 'package:flutter/material.dart';

class ButtonLogin extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  const ButtonLogin({super.key, required this.onTap, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 40),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(40),
        ),
        width: 200,
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
