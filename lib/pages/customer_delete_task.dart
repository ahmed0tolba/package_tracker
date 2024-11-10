import 'dart:convert';
import 'package:packagetracker/components/TextInputLogin.dart';
import 'package:packagetracker/components/ButtonLogin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:packagetracker/components/MyAppBar.dart';
import 'package:packagetracker/pages/customer_tasks.dart';
import 'package:packagetracker/components/ButtonNavigate.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:packagetracker/pages/customer_welcome.dart';

dynamic username = "", customerid = "", usertype = "";
Future<void> loadSessionVariable(context) async {
  username = await SessionManager().get("username");
  customerid = await SessionManager().get("userid");
  usertype = await SessionManager().get("usertype");
}

late int
    employeesIDsdropdownItemsselectedIndex; //where I want to store the selected index
String employeeID = "";
List<String> employeesIDsdropdownItems = [''];
late int
    VehiclesIDsdropdownItemsselectedIndex; //where I want to store the selected index
String VehicleID = "";
List<String> VehiclesIDsdropdownItems = [''];
final tasknumberController = TextEditingController();
DateTime deadline = DateTime.now();
DateTime loaddate = DateTime.now();
final taskdescriptionController = TextEditingController();
final loadlocationController = TextEditingController();
final unloadlocationController = TextEditingController();
String loadlocation = "Search Location";
String unloadlocation = "Search Location";

List<String> _locationsOptions = [''];

final _client = http.Client();

String originaltasknumber = '';

_isThereCurrentDialogShowing(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;

Future<void> deleteTaskbyCustomer(context) async {
  try {
    http.Response response = await _client.post(Uri.parse(
        "http://127.0.0.1:13000/deletetask?tasknumber=$originaltasknumber"));
    var responseDecoded = jsonDecode(response.body);
    // print(responseDecoded);
    bool accepted = responseDecoded['success'];

    if (response.statusCode == 200) {
      Future.delayed(const Duration(seconds: 3), () {
        if (_isThereCurrentDialogShowing(context)) {
          Navigator.of(context, rootNavigator: true).pop(true);
        }
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CustomerTasks()));
      });
      if (accepted) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Request Deleted successfuly."),
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

Future<void> loadEmployeesIDs(context) async {
  // print("hi");
  try {
    http.Response response = await _client
        .get(Uri.parse("http://127.0.0.1:13000/listemployeesdata"));
    var responseDecoded = jsonDecode(response.body);
    if (responseDecoded['employees_IDs_list'].length > 0) {
      employeesIDsdropdownItems = [];
      for (int k = 0; k < responseDecoded['employees_IDs_list'].length; k++) {
        employeesIDsdropdownItems.add(responseDecoded['employees_IDs_list'][k]);
      }
      // }
    } else {
      employeesIDsdropdownItems = [''];
    }
    employeeID = employeesIDsdropdownItems[0];
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

Future<void> loadVehiclesIDs(context) async {
  // print("hi");
  try {
    http.Response response =
        await _client.get(Uri.parse("http://127.0.0.1:13000/listvehicles"));
    var responseDecoded = jsonDecode(response.body);
    // print(responseDecoded['employees_names_list'].length);
    if (responseDecoded['vehicles_ids_list'].length > 0) {
      VehiclesIDsdropdownItems = [];
      for (int k = 0; k < responseDecoded['vehicles_ids_list'].length; k++) {
        // print(responseDecoded['employees_names_list'][k]);
        VehiclesIDsdropdownItems.add(responseDecoded['vehicles_ids_list'][k]);
      }
      // }
    } else {
      VehiclesIDsdropdownItems = [''];
    }
    VehicleID = VehiclesIDsdropdownItems[0];
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

class CustomerDeleteTask extends StatefulWidget {
  const CustomerDeleteTask({Key? key}) : super(key: key);

  @override
  _CustomerDeleteTaskState createState() => _CustomerDeleteTaskState();
}

// flutter pub add http
class _CustomerDeleteTaskState extends State<CustomerDeleteTask> {
  late List<DropdownMenuItem<String>> list;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: deadline,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != deadline) {
      setState(() {
        deadline = picked;
      });
    }
  }

  Future<void> loadTasksData(context) async {
    try {
      http.Response response = await _client.post(Uri.parse(
          "http://127.0.0.1:13000/gettaskdata?tasknumber=$originaltasknumber"));
      var responseDecoded = jsonDecode(response.body);
      print(responseDecoded);
      tasknumberController.text = responseDecoded['tasknumber'];
      employeeID = responseDecoded['employeeid'] ?? "";
      VehicleID = responseDecoded['vehicleid'] ?? "";
      loadlocationController.text = responseDecoded['loadlocation'];
      unloadlocationController.text = responseDecoded['unloadlocation'] ?? "";
      taskdescriptionController.text = responseDecoded['taskdescription'];
      loaddate = DateTime.parse(responseDecoded['loaddate']);
      deadline = DateTime.parse(responseDecoded['deadline']);
    } on Exception catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    loadSessionVariable(context).then((listMap) {
      list = [];
      loadVehiclesIDs(context).then((listMap) {
        loadEmployeesIDs(context).then((listMap) {
          originaltasknumber =
              ModalRoute.of(context)!.settings.arguments as String;
          loadTasksData(context).then((listMap) {
            setState(() {});
          });
        });
      });
    });

    // loadTasksData().then((listMap) {
    //   setState(() {});
    // });
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
              Image.asset(
                "lib/images/splash.png",
                height: MediaQuery.of(context).size.height / 6,
              ),

              const SizedBox(height: 10),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: // First Name
                        Text(
                      'Load Location: ',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: MyTextField(
                      controller: loadlocationController,
                      hintText: 'Load location',
                      obscureText: false,
                      enabled: false,
                    ),
                  ),
                  const Expanded(flex: 3, child: Text(""))
                ],
              ),

              const SizedBox(height: 15),

              Row(
                children: <Widget>[
                  const Expanded(flex: 1, child: Text("")),
                  const Expanded(
                    flex: 2,
                    child: // username field
                        Text('DeadLine'),
                  ),
                  Expanded(
                    flex: 4,
                    child: // First Name
                        ElevatedButton(
                      onPressed: () {},
                      child: Text("${deadline.toLocal()}".split(' ')[0]),
                    ),
                  ),
                  const Expanded(flex: 1, child: Text(""))
                ],
              ),

              const SizedBox(height: 15),

              Row(
                children: <Widget>[
                  const Expanded(flex: 1, child: Text("")),
                  const Expanded(
                    flex: 2,
                    child: // username field
                        Text('Load Date'),
                  ),
                  Expanded(
                    flex: 4,
                    child: // First Name
                        ElevatedButton(
                      onPressed: () {},
                      child: Text("${loaddate.toLocal()}".split(' ')[0]),
                    ),
                  ),
                  const Expanded(flex: 1, child: Text(""))
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: <Widget>[
                  const Expanded(flex: 1, child: Text("")),
                  Expanded(
                    flex: 2,
                    child: // Birthday
                        Text(
                      "Description:",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: //
                        // Birthday
                        MyTextField(
                      controller: taskdescriptionController,
                      hintText: 'Note (load type, location description, etc)',
                      obscureText: false,
                      minLines: 4,
                      enabled: false,
                    ),
                  ),
                  const Expanded(flex: 1, child: Text(""))
                ],
              ),

              const SizedBox(height: 10),

              // sign in button
              ButtonNavigate(
                onTap: () {
                  showAlertDialog(context);
                },
                buttonText: "Delete Task",
              ),

              const SizedBox(height: 25),
              const SizedBox(height: 20),
              ButtonLogin(
                onTap: () async {
                  Future.delayed(const Duration(seconds: 0), () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CustomerWelcome()));
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
        deleteTaskbyCustomer(context).then((listMap) {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm Delete"),
      content: const Text("Are you sure you want to delete that request?"),
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

class AutocompleteBasicExample extends StatelessWidget {
  AutocompleteBasicExample({super.key, required this.val});
  String val;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        loadlocation = textEditingValue.text;
        try {
          http.Response response = await _client.post(Uri.parse(
              "http://127.0.0.1:13000/mapsautocomplete?input=${textEditingValue.text}"));
          var responseDecoded = jsonDecode(response.body);
          if (responseDecoded['suggestions'].length > 0) {
            _locationsOptions = [];
            for (int k = 0; k < responseDecoded['suggestions'].length; k++) {
              _locationsOptions.add(responseDecoded['suggestions'][k][0]);
            }
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return _locationsOptions;
            // }
          } else {
            _locationsOptions = [''];
          }
        } on Exception catch (_) {
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(const Duration(seconds: 20), () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                });
                return const AlertDialog(
                  title: Text(
                      '404 , unable to establish connection with server, check internet , make sure the server is running , type http://127.0.0.1:13000'),
                );
              });
        }
        return _locationsOptions;
      },
      onSelected: (String selection) {
        loadlocation = selection;
      },
    );
  }
}

class AutocompleteBasicExample2 extends StatelessWidget {
  AutocompleteBasicExample2({super.key, required this.val});
  String val;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        unloadlocation = textEditingValue.text;
        try {
          http.Response response = await _client.post(Uri.parse(
              "http://127.0.0.1:13000/mapsautocomplete?input=${textEditingValue.text}"));
          var responseDecoded = jsonDecode(response.body);
          if (responseDecoded['suggestions'].length > 0) {
            _locationsOptions = [];
            for (int k = 0; k < responseDecoded['suggestions'].length; k++) {
              _locationsOptions.add(responseDecoded['suggestions'][k][0]);
            }
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return _locationsOptions;
            // }
          } else {
            _locationsOptions = [''];
          }
        } on Exception catch (_) {
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(const Duration(seconds: 20), () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                });
                return const AlertDialog(
                  title: Text(
                      '404 , unable to establish connection with server, check internet , make sure the server is running , type http://127.0.0.1:13000'),
                );
              });
        }
        return _locationsOptions;
      },
      onSelected: (String selection) {
        unloadlocation = selection;
      },
    );
  }
}
