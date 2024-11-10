import 'dart:convert';
import 'package:packagetracker/components/TextInputLogin.dart';
import 'package:packagetracker/pages/employee.dart';
import 'package:packagetracker/components/ButtonLogin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:packagetracker/components/MyAppBar.dart';
import 'package:packagetracker/components/ButtonNavigate.dart';
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
DateTime birthday = DateTime.utc(2003, 1, 1);
final phoneController = TextEditingController();
final emailController = TextEditingController();
final nationalnumberController = TextEditingController();
final usernameController = TextEditingController();
final passwordController = TextEditingController();

final _client = http.Client();
String originalusername = '';
Future<void> deleteEmployee(context) async {
  // print("hi");
  try {
    http.Response response = await _client.post(Uri.parse(
        "http://127.0.0.1:13000/deleteemployee?username=$originalusername"));
    var responseDecoded = jsonDecode(response.body);
    bool accepted = responseDecoded['success'];
    String message = responseDecoded['message'];
    if (response.statusCode == 200) {
      if (accepted) {
        Future.delayed(const Duration(seconds: 3), () {
          if (_isThereCurrentDialogShowing(context)) {
            Navigator.of(context, rootNavigator: true).pop(true);
          }
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Employee()));
        });
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Employee deleted successfuly"),
              );
            });
      } else {
        Future.delayed(const Duration(seconds: 3), () {
          if (_isThereCurrentDialogShowing(context)) {
            Navigator.of(context, rootNavigator: true).pop(true);
          }
        });
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(message),
              );
            });
      }
    }
  } on Exception catch (_) {
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

class EmployeeDelete extends StatefulWidget {
  const EmployeeDelete({Key? key}) : super(key: key);

  @override
  _EmployeeDeleteState createState() => _EmployeeDeleteState();
}

class _EmployeeDeleteState extends State<EmployeeDelete> {
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

  Future<void> loadEmployeeData(context) async {
    try {
      http.Response response = await _client.post(Uri.parse(
          "http://127.0.0.1:13000/getEmployeeData?username=$originalusername&usertype=$usertype"));
      var responseDecoded = jsonDecode(response.body);
      if (responseDecoded['firstname'] != null) {
        firstnameController.text = responseDecoded['firstname'];
      }
      if (responseDecoded['lastname'] != null) {
        lastnameController.text = responseDecoded['lastname'];
      }
      if (responseDecoded['phone'] != null) {
        phoneController.text = responseDecoded['phone'];
      }
      if (responseDecoded['email'] != null) {
        emailController.text = responseDecoded['email'];
      }
      if (responseDecoded['nationalnumber'] != null) {
        nationalnumberController.text = responseDecoded['nationalnumber'];
      }

      if (responseDecoded['username'] != null) {
        usernameController.text = responseDecoded['username'];
      }
      if (responseDecoded['password'] != null) {
        passwordController.text = responseDecoded['password'];
      }
    } on Exception catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    loadSessionVariable(context).then((listMap) {
      // listOfColumns = [];
      loadEmployeeData(context).then((listMap) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    originalusername = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: MyAppBar(usertype: usertype, context: context),
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
                      enabled: false,
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
                      enabled: false,
                    ),
                  ),
                  const Expanded(flex: 2, child: Text(""))
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: <Widget>[
                  const Expanded(flex: 1, child: Text("")),
                  const Expanded(
                    flex: 2,
                    child: // username field
                        Text('Date of birth:'),
                  ),
                  Expanded(
                    flex: 3,
                    child: // First Name
                        ElevatedButton(
                      onPressed: () {},
                      child: Text("${birthday.toLocal()}".split(' ')[0]),
                    ),
                  ),
                  const Expanded(flex: 5, child: Text("")),
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
                      regexp: (r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$'),
                      enabled: false,
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
                      regexp: (r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'),
                      enabled: false,
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
                      regexp: (r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$'),
                      enabled: false,
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
                      enabled: false,
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
                      enabled: false,
                      maxLines: 1,
                    ),
                  ),
                  const Expanded(flex: 2, child: Text(""))
                ],
              ),

              const SizedBox(height: 10),

              ButtonNavigate(
                onTap: () {
                  showAlertDialog(context);
                },
                buttonText: "Delete Employee",
              ),
              const SizedBox(height: 25),
              ButtonLogin(
                onTap: () async {
                  Future.delayed(const Duration(seconds: 0), () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Employee()));
                  });
                },
                buttonText: "Back",
              ),
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

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Delete"),
      onPressed: () {
        Navigator.pop(context);
        deleteEmployee(context).then((listMap) {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm Delete"),
      content: const Text("Are you sure you want to delete that employee?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
