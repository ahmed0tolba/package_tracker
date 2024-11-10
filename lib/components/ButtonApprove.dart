import 'package:flutter/material.dart';

class ButtonApprove extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  const ButtonApprove(
      {super.key, required this.onTap, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width - 20,
            color: const Color.fromARGB(186, 255, 254, 255),
            child: const Row(
              children: <Widget>[
                SizedBox(
                  height: 70,
                  child: Image(
                    image: AssetImage('assest/images/logo.png'),
                  ),
                ),
                Text(
                  '     Negative Emotion Detected',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
