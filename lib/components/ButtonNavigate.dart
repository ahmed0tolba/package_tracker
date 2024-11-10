import 'package:flutter/material.dart';

class ButtonNavigate extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  bool active;
  ButtonNavigate(
      {super.key,
      required this.onTap,
      required this.buttonText,
      this.active = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: active ? onTap : () {},
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 40),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade600,
                  spreadRadius: 1,
                  blurRadius: 15,
                  offset: const Offset(10, 10))
            ]),
        width: 200,
        child: Center(
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
