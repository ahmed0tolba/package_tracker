import 'package:packagetracker/components/ButtonLogin.dart';
import 'package:packagetracker/components/ButtonNavigate.dart';
import 'package:flutter/material.dart';
import 'package:packagetracker/pages/employee.dart';
import 'package:packagetracker/pages/employee_edit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:packagetracker/components/MyAppBar.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

dynamic username = "", userid = "", usertype = "";
Future<void> loadSessionVariable(context) async {
  username = await SessionManager().get("username");
  userid = await SessionManager().get("userid");
  usertype = await SessionManager().get("usertype");
}

_isThereCurrentDialogShowing(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;

final _client = http.Client();
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

class EmployeeEditSelect extends StatefulWidget {
  const EmployeeEditSelect({Key? key}) : super(key: key);

  @override
  _EmployeeEditSelectState createState() => _EmployeeEditSelectState();
}

// flutter pub add http
class _EmployeeEditSelectState extends State<EmployeeEditSelect> {
  late List<DropdownMenuItem<String>> list;

  @override
  void initState() {
    super.initState();
    loadSessionVariable(context).then((listMap) {
      setState(() {});
    });
    list = [];
    loadEmployees(context).then((listMap) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // loadEmployees(context);
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
                "Select an employee to edit:",
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
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const EmployeeEdit(),
                    settings: RouteSettings(
                      arguments: dropDownVal,
                    ),
                  ));
                },
                buttonText: "Edit Employee",
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
            ],
          ),
        ),
      ),
    );
  }
}
