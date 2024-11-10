import 'package:packagetracker/components/ButtonNavigate.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:packagetracker/pages/employee_add.dart';
import 'package:packagetracker/pages/employee_delete.dart';
import 'package:packagetracker/pages/employee_edit_select.dart';
import 'package:packagetracker/pages/employee_edit.dart';
import 'package:packagetracker/pages/employee_delete_select.dart';
import 'package:packagetracker/components/MyAppBar.dart';
import 'dart:convert';
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

final _client = http.Client();
List<Map<String, String>> listOfColumns = [];

Future<void> loadEmployeesData(context) async {
  // print("hi");
  try {
    http.Response response = await _client
        .get(Uri.parse("http://127.0.0.1:13000/listemployeesdata"));
    var responseDecoded = jsonDecode(response.body);
    if (responseDecoded['employees_names_list'].length > 0) {
      listOfColumns = [];
      for (int k = 0; k < responseDecoded['employees_names_list'].length; k++) {
        listOfColumns.add({
          "ID number": responseDecoded['employees_IDs_list'][k],
          "Name": responseDecoded['employees_names_list'][k]
        });
      }
      // }
    } else {
      listOfColumns = [];
    }
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

class Employee extends StatefulWidget {
  const Employee({Key? key}) : super(key: key);

  @override
  _EmployeeState createState() => _EmployeeState();
}

// flutter pub add http
class _EmployeeState extends State<Employee> {
  @override
  void initState() {
    super.initState();
    loadSessionVariable(context).then((listMap) {
      listOfColumns = [];
      loadEmployeesData(context).then((listMap) {
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
              const SizedBox(height: 10),

              // wellcome back
              Text(
                "Welcome, $username",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),

              const SizedBox(height: 10),
              // wellcome back
              const Text(
                "What do you want to do today",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),
              Image.asset(
                "lib/images/splash.png",
                height: MediaQuery.of(context).size.height / 4,
              ),

              const SizedBox(height: 10),

              const Text(
                "Employees Information",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              //
              DataTable(
                columns: const [
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('ID number')),
                  DataColumn(label: Text('Name')),
                ],
                rows:
                    listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
                        .map(
                          ((element) => DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    SizedBox(
                                      width: 90,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    const EmployeeDelete(),
                                                settings: RouteSettings(
                                                  arguments: element["Name"],
                                                ),
                                              ));
                                            },
                                            icon: const Icon(Icons.cancel),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    const EmployeeEdit(),
                                                settings: RouteSettings(
                                                  arguments: element["Name"],
                                                ),
                                              ));
                                            },
                                            icon: const Icon(Icons.edit),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ), //Extracting from Map element the value
                                  DataCell(Text(element["ID number"]!)),
                                  DataCell(Text(element["Name"]!)),
                                ],
                              )),
                        )
                        .toList(),
              ),

              const SizedBox(height: 10),

              ButtonNavigate(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const EmployeeAdd()));
                },
                buttonText: "Add Employee",
              ),

              const SizedBox(height: 10),
              ButtonNavigate(
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
}
