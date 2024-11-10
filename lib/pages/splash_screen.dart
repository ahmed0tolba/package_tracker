import "package:flutter/material.dart";
import 'dart:async';
import 'package:packagetracker/pages/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 3000), () {
      // set your desired delay time here
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Image.asset("lib/images/splash.png",
            width: MediaQuery.of(context).size.width / 1.5,
            fit: BoxFit.scaleDown),
      ),
    );
  }
}
