import 'dart:convert';
import 'package:packagetracker/pages/welcome.dart';
import 'package:packagetracker/pages/employee_welcome.dart';
import 'package:packagetracker/pages/customer_welcome.dart';
import 'package:packagetracker/pages/customer_signup.dart';

import 'package:packagetracker/components/TextInputLogin.dart';
import 'package:packagetracker/components/ButtonLogin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session_manager/flutter_session_manager.dart';

// import 'package:dio/dio.dart';

final usernameController = TextEditingController();
final passwordController = TextEditingController();

final _client = http.Client();

_isThereCurrentDialogShowing(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;

Future<void> signUserIn(context) async {
  final String username = usernameController.text;
  final String password = passwordController.text;

  try {
    http.Response response = await _client.post(Uri.parse(
        "http://127.0.0.1:13000/login?username=$username&password=$password"));

    var responseDecoded = jsonDecode(response.body);
    print(responseDecoded);
    bool accepted = responseDecoded['success'];
    String usernameReceived = responseDecoded['username'];
    String usertype = responseDecoded['usertype'];
    String userid = responseDecoded['userid'];
    await SessionManager().set("username", usernameReceived);
    await SessionManager().set("usertype", usertype);
    await SessionManager().set("userid", userid);
    if (accepted) {
      if (usertype == "admin") {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Welcome()));
      }
      if (usertype == "employee") {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const EmployeeWelcome()));
      }
      if (usertype == "customer") {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CustomerWelcome()));
      }
    } else {
      // wrong username or password
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(const Duration(seconds: 3), () {
              Navigator.of(context, rootNavigator: true).pop(true);
            });
            return const AlertDialog(
              title: Text("Wrong credentials."),
            );
          });
    }
  } on Exception catch (_) {
    // make it explicit that this function can throw exceptions
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 20), () {
            if (_isThereCurrentDialogShowing(context)) {
              Navigator.of(context, rootNavigator: true).pop(true);
            }
          });
          return const AlertDialog(
            title: Text(
                '404 , unable to establish connection with server, check internet , make sure the server (python file) is running , type http://127.0.0.1:13000'),
          );
        });
    return;
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

// flutter pub add http
class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),

              Image.asset(
                "lib/images/splash.png",
                height: MediaQuery.of(context).size.height / 4,
              ),

              const SizedBox(height: 10),

              // wellcome back
              Text(
                "Welcome to track your shipment",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              // username field
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password field
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
                maxLines: 1,
              ),

              const SizedBox(height: 10),

              // forgot password?
              Align(
                alignment: FractionalOffset.topRight,
                child: Container(
                  margin: const EdgeInsets.only(right: 45),
                  child: TextButton(
                    child: const Text(
                      'SignUp',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CustomerSignup()));
                    },
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       Text(
              //         'Sign Up?',
              //         style: TextStyle(color: Colors.grey[600]),
              //       ),
              //     ],
              //   ),
              // ),

              const SizedBox(height: 10),

              // sign in button
              ButtonLogin(
                onTap: () async {
                  await signUserIn(context);
                },
                buttonText: "Login",
              ),

              const SizedBox(height: 10),

              Image.asset(
                "lib/images/carmanpush.png",
                height: MediaQuery.of(context).size.height / 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
