import 'dart:convert';
import 'package:packagetracker/components/TextInputLogin.dart';
import 'package:packagetracker/components/ButtonLogin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:packagetracker/components/MyAppBar.dart';
import 'package:packagetracker/pages/login_page.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

dynamic username = "", userid = "", usertype = "";
Future<void> loadSessionVariable(context) async {
  username = await SessionManager().get("username");
  userid = await SessionManager().get("userid");
  usertype = await SessionManager().get("usertype");
}

_isThereCurrentDialogShowing(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;

final firstnameController = TextEditingController();
final lastnameController = TextEditingController();
DateTime birthday = DateTime.utc(2000, 1, 1);
final phoneController = TextEditingController();
final emailController = TextEditingController();
final nationalnumberController = TextEditingController();
final usernameController = TextEditingController();
final passwordController = TextEditingController();

final _client = http.Client();

Future<void> addCustomer(context) async {
  final String firstname = firstnameController.text;
  final String lastname = lastnameController.text;
  final String phone = phoneController.text;
  final String email = emailController.text;
  final String nationalnumber = nationalnumberController.text;
  final String username = usernameController.text;
  final String password = passwordController.text;

  try {
    http.Response response = await _client.post(Uri.parse(
        "http://127.0.0.1:13000/addcustomer?firstname=$firstname&lastname=$lastname&birthday=$birthday&phone=$phone&email=$email&nationalnumber=$nationalnumber&username=$username&password=$password"));
    var responseDecoded = jsonDecode(response.body);
    print(responseDecoded);
    bool accepted = responseDecoded['success'];
    String message = responseDecoded['message'];
    int status = responseDecoded['status'];
    if (response.statusCode == 200) {
      if (accepted) {
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(seconds: 3), () {
                Navigator.of(context, rootNavigator: true).pop(true);
                Future.delayed(const Duration(seconds: 3), () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginPage()));
                });
              });
              return const AlertDialog(
                title: Text("Custome Created successfuly."),
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(seconds: 10), () {
                if (_isThereCurrentDialogShowing(context)) {
                  Navigator.of(context, rootNavigator: true).pop(true);
                }
              });

              return AlertDialog(
                title: Text(message),
              );
            });
        // wrong input
      }
    } else {
      // not 200
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
                '404 , unable to establish connection with server, check internet , make sure the server is running , type http://127.0.0.1:13000'),
          );
        });
    return;
  }
}

class CustomerSignup extends StatefulWidget {
  const CustomerSignup({Key? key}) : super(key: key);

  @override
  _CustomerSignupState createState() => _CustomerSignupState();
}

// flutter pub add http
class _CustomerSignupState extends State<CustomerSignup> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: birthday,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2003));
    if (picked != null && picked != birthday) {
      setState(() {
        birthday = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: username != ""
          ? MyAppBar(usertype: usertype, context: context)
          : null,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Image.asset(
              //   "lib/images/splash.png",
              //   height: MediaQuery.of(context).size.height / 6,
              // ),

              const SizedBox(height: 10),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: // First Name
                        Text(
                      "First Name:",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: // username field
                        MyTextField(
                      controller: firstnameController,
                      hintText: 'First Name',
                      obscureText: false,
                    ),
                  ),
                  const Expanded(flex: 2, child: Text(""))
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: // First Name
                        Text(
                      "Last Name:",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: // Last Name field
                        MyTextField(
                      controller: lastnameController,
                      hintText: 'Last Name',
                      obscureText: false,
                    ),
                  ),
                  const Expanded(flex: 2, child: Text(""))
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: <Widget>[
                  const Expanded(flex: 1, child: Text("")),
                  Expanded(
                    flex: 4,
                    child: // First Name
                        ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: const Text('Enter your date of birth'),
                    ),
                  ),
                  const Expanded(flex: 1, child: Text("")),
                  Expanded(
                    flex: 3,
                    child: // username field
                        Text("${birthday.toLocal()}".split(' ')[0]),
                  ),
                  const Expanded(flex: 1, child: Text(""))
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: // Phone
                        Text(
                      "Phone:",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: //
                        // Birthday
                        MyTextField(
                      controller: phoneController,
                      hintText: 'Phone',
                      obscureText: false,
                      regexp: (r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*'),
                    ),
                  ),
                  const Expanded(flex: 2, child: Text(""))
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: // Phone
                        Text(
                      "Email:",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: //
                        // Email
                        MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                      maxLength: 50,
                    ),
                  ),
                  const Expanded(flex: 2, child: Text(""))
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: // National Number
                        Text(
                      "National Number:",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: //
                        // National Number
                        MyTextField(
                      controller: nationalnumberController,
                      hintText: 'National Number',
                      obscureText: false,
                      regexp: (r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*'),
                    ),
                  ),
                  const Expanded(flex: 2, child: Text(""))
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: // National Number
                        Text(
                      "Username:",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child:
                        // Username field
                        MyTextField(
                      controller: usernameController,
                      hintText: 'Username:',
                      obscureText: false,
                    ),
                  ),
                  const Expanded(flex: 2, child: Text(""))
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: // National Number
                        Text(
                      "Password:",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child:
                        // password field
                        MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      maxLines: 1,
                    ),
                  ),
                  const Expanded(flex: 2, child: Text(""))
                ],
              ),

              const SizedBox(height: 10),

              // sign in button
              ButtonLogin(
                onTap: () async {
                  await addCustomer(context);
                },
                buttonText: "Sign up",
              ),

              const SizedBox(height: 20),
              ButtonLogin(
                onTap: () async {
                  Future.delayed(const Duration(seconds: 0), () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginPage()));
                  });
                },
                buttonText: "Back",
              ),

              const SizedBox(height: 10),

              // Image.asset(
              //   "lib/images/carmanpush.png",
              //   height: MediaQuery.of(context).size.height / 4,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
