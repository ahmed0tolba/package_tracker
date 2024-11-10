import 'package:packagetracker/components/ButtonLogin.dart';
import 'package:packagetracker/components/ButtonNavigate.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:packagetracker/pages/employee_add.dart';
import 'package:packagetracker/pages/employee_edit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:packagetracker/components/MyAppBar.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:packagetracker/pages/welcome.dart';

dynamic username = "", userid = "", usertype = "";
Future<void> loadSessionVariable(context) async {
  username = await SessionManager().get("username");
  userid = await SessionManager().get("userid");
  usertype = await SessionManager().get("usertype");
}

_isThereCurrentDialogShowing(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;

final usernameController = TextEditingController();
final passwordController = TextEditingController();
final _client = http.Client();
const data = '';
late int selectedIndex; //where I want to store the selected index
String dropDownVal = "";
List<String> dropdownItems = [''];

// List<DropdownMenuItem<String>> dropdownItems = [];

Future<void> loadEmployees(context) async {
  // print("hi");
  try {
    http.Response response =
        await _client.get(Uri.parse("http://127.0.0.1:13000/listemployees"));
    var responseDecoded = jsonDecode(response.body);
    // print(responseDecoded['employees_names_list'].length);
    if (responseDecoded['employees_names_list'].length > 0) {
      dropdownItems = [];
      for (int k = 0; k < responseDecoded['employees_names_list'].length; k++) {
        // print(responseDecoded['employees_names_list'][k]);
        dropdownItems.add(responseDecoded['employees_names_list'][k]);
      }
      // }
    } else {
      dropdownItems = [''];
    }
    dropDownVal = dropdownItems[0];
    // print(dropdownItems);
    // setState(() {});
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

Future<void> deleteEmployee(context) async {
  // print("hi");
  try {
    http.Response response = await _client.post(Uri.parse(
        "http://127.0.0.1:13000/deleteemployee?username=$dropDownVal"));
    var responseDecoded = jsonDecode(response.body);
    bool accepted = responseDecoded['success'];
    if (response.statusCode == 200) {
      if (accepted) {
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(seconds: 3), () {
                if (_isThereCurrentDialogShowing(context)) {
                  Navigator.of(context, rootNavigator: true).pop(true);
                }
              });

              return const AlertDialog(
                title: Text("Employee Deleted successfuly."),
              );
            });
        dropdownItems.remove(dropDownVal);
        if (dropdownItems.isNotEmpty) {
          dropDownVal = dropdownItems[0];
        } else {
          dropDownVal = '';
        }
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

class EmployeeDeleteSelect extends StatefulWidget {
  const EmployeeDeleteSelect({Key? key}) : super(key: key);

  @override
  _EmployeeDeleteSelectState createState() => _EmployeeDeleteSelectState();
}

// flutter pub add http
class _EmployeeDeleteSelectState extends State<EmployeeDeleteSelect> {
  late List<DropdownMenuItem<String>> list;

  @override
  void initState() {
    super.initState();
    loadSessionVariable(context).then((listMap) {
      list = [];
      loadEmployees(context).then((listMap) {
        setState(() {});
      });
    });
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
              const SizedBox(height: 50),

              // wellcome back
              Text(
                "Welcome, $username",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),

              const SizedBox(height: 15),
              Image.asset(
                "lib/images/splash.png",
                height: MediaQuery.of(context).size.height / 3,
              ),
              const SizedBox(height: 10),

              // wellcome back
              const Text(
                "Select an employee to Delete:",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),

              DropdownButton(
                value: dropDownVal,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: dropdownItems.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onTap: () {
                  // setState(() {});
                },
                onChanged: (String? newValue) {
                  setState(() {
                    dropDownVal = newValue!;
                  });
                },
              ),

              const SizedBox(height: 25),

              ButtonNavigate(
                onTap: () {
                  if (dropDownVal != "") {
                    showAlertDialog(context);
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(const Duration(seconds: 3), () {
                            Navigator.of(context, rootNavigator: true)
                                .pop(true);
                          });
                          return const AlertDialog(
                            title: Text("No employee selected."),
                          );
                        });
                  }
                },
                buttonText: "Delete Employee",
              ),

              const SizedBox(height: 25),
              ButtonLogin(
                onTap: () async {
                  Future.delayed(const Duration(seconds: 0), () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Welcome()));
                  });
                },
                buttonText: "Back",
              ),
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
        deleteEmployee(context).then((listMap) {
          setState(() {});
        });
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
