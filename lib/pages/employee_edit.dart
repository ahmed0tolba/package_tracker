import 'dart:convert';
import 'package:packagetracker/components/TextInputLogin.dart';
import 'package:packagetracker/components/ButtonLogin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:packagetracker/components/MyAppBar.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:packagetracker/pages/employee.dart';
import 'package:packagetracker/pages/customer_welcome.dart';
import 'package:packagetracker/pages/employee_welcome.dart';

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
Future<void> updateuser(context) async {
  final String firstname = firstnameController.text;
  final String lastname = lastnameController.text;
  final String phone = phoneController.text;
  final String email = emailController.text;
  final String nationalnumber = nationalnumberController.text;
  final String username = usernameController.text;
  final String password = passwordController.text;
  late http.Response response;
  try {
    String modifyTable = "";
    if (originalusername == "") {
      originalusername = username;
    }
    response = await _client.post(Uri.parse(
        "http://127.0.0.1:13000/updateuser?originalusername=$username&firstname=$firstname&lastname=$lastname&birthday=$birthday&phone=$phone&email=$email&nationalnumber=$nationalnumber&username=$username&password=$password&usertype=$usertype"));
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
              Future.delayed(const Duration(milliseconds: 3000), () {
                if (_isThereCurrentDialogShowing(context)) {
                  Navigator.of(context, rootNavigator: true).pop(true);
                }
              });

              return const AlertDialog(
                title: Text("Profile Updated successfuly."),
              );
            });
        originalusername = username;
        Future.delayed(const Duration(seconds: 3), () {
          if (originalusername == "") {
            if (usertype == "admin") {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Employee()));
            }
            if (usertype == "employee") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const EmployeeWelcome()));
            }
            if (usertype == "customer") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CustomerWelcome()));
            }
          } else {
            if (usertype == "admin") {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Employee()));
            }
            if (usertype == "employee") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const EmployeeWelcome()));
            }
            if (usertype == "customer") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CustomerWelcome()));
            }
          }
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
      }
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

class EmployeeEdit extends StatefulWidget {
  const EmployeeEdit({Key? key}) : super(key: key);

  @override
  _EmployeeEditState createState() => _EmployeeEditState();
}

class _EmployeeEditState extends State<EmployeeEdit> {
  @override
  void initState() {
    super.initState();
    loadSessionVariable(context).then((listMap) {
      originalusername = ModalRoute.of(context)!.settings.arguments as String;
      loadUserData(context).then((listMap) {
        setState(() {});
      });
    });
  }

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

  Future<void> loadUserData(context) async {
    try {
      if (originalusername == "") {
        originalusername = username;
      }
      // originalusername = username;
      http.Response response = await _client.post(Uri.parse(
          "http://127.0.0.1:13000/getuserdata?username=$originalusername&usertype=$usertype"));
      var responseDecoded = jsonDecode(response.body);
      print(responseDecoded);

      firstnameController.text = responseDecoded['firstname'] ?? "";
      lastnameController.text = responseDecoded['lastname'] ?? "";
      phoneController.text = responseDecoded['phone'] ?? "";
      emailController.text = responseDecoded['email'] ?? "";
      nationalnumberController.text = responseDecoded['nationalnumber'] ?? "";
      usernameController.text = responseDecoded['username'] ?? "";
      passwordController.text = responseDecoded['password'] ?? "";
    } on Exception catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(usertype: usertype, context: context),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
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
                  Expanded(
                    flex: 2,
                    child: // National Number
                        Text(
                      "Date of birth:",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ElevatedButton(
                        onPressed: () => _selectDate(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black54,
                          minimumSize: const Size.fromHeight(50),
                          alignment: Alignment
                              .centerLeft, // Align button content to the left
                        ),
                        child: Text("${birthday.toLocal()}".split(' ')[0]),
                      ),
                    ),
                  ),
                  const Expanded(flex: 2, child: Text(""))
                ],
              ),

              // Row(
              //   children: <Widget>[
              //     const Expanded(flex: 1, child: Text("")),
              //     const Expanded(
              //       flex: 2,
              //       child: // username field
              //           Text('Date of birth:'),
              //     ),
              //     Expanded(
              //       flex: 3,
              //       child: // First Name
              //           ElevatedButton(
              //         onPressed: () => _selectDate(context),
              //         child: Text("${birthday.toLocal()}".split(' ')[0]),
              //       ),
              //     ),
              //     const Expanded(flex: 5, child: Text("")),
              //   ],
              // ),

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
                      maxLength: 10,
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
                      // regexp: (r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'),
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
                      maxLength: 10,
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
                  await updateuser(context);
                },
                buttonText: "Update Information",
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
}
