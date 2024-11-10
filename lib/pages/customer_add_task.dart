import 'dart:convert';
import 'package:packagetracker/components/TextInputLogin.dart';
import 'package:packagetracker/components/ButtonLogin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:packagetracker/components/MyAppBar.dart';
import 'package:packagetracker/pages/customer_tasks.dart';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:packagetracker/pages/customer_welcome.dart';

dynamic username = "", customerid = "", usertype = "";
Future<void> loadSessionVariable(context) async {
  username = await SessionManager().get("username");
  customerid = await SessionManager().get("userid");
  usertype = await SessionManager().get("usertype");
}

// import 'package:dio/dio.dart';

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
DateTime unloaddate = DateTime.now();
final taskdescriptionController = TextEditingController();
String loadlocation = "Search Location";
String unloadlocation = "Search Location";

List<String> _locationsOptions = [''];

final _client = http.Client();

_isThereCurrentDialogShowing(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;

Future<void> addTaskbycustomer(context) async {
  final String tasknumber = tasknumberController.text;

  // final String loadlocation = loadlocationController.text;
  // final String unloadlocation = unloadlocationController.text;
  final String taskdescription = taskdescriptionController.text;

  try {
    http.Response response = await _client.post(Uri.parse(
        "http://127.0.0.1:13000/addtaskbycustomer?loaddate=$loaddate&unloaddate=$unloaddate&deadline=$deadline&loadlocation=$loadlocation&unloadlocation=$unloadlocation&taskdescription=$taskdescription&customerid=$customerid"));
    var responseDecoded = jsonDecode(response.body);
    print(responseDecoded);
    bool accepted = responseDecoded['success'];
    String message = responseDecoded['message'];
    int status = responseDecoded['status'];
    if (response.statusCode == 200) {
      if (accepted) {
        Future.delayed(const Duration(milliseconds: 3000), () {
          if (_isThereCurrentDialogShowing(context)) {
            Navigator.of(context, rootNavigator: true).pop(true);
          }
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CustomerTasks()));
        });
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Request added successfuly."),
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

Future<void> loadEmployeesIDs(context) async {
  // print("hi");
  try {
    http.Response response = await _client
        .get(Uri.parse("http://127.0.0.1:13000/listemployeesdata"));
    var responseDecoded = jsonDecode(response.body);
    // print(responseDecoded['employees_names_list'].length);
    if (responseDecoded['employees_IDs_list'].length > 0) {
      employeesIDsdropdownItems = [];
      for (int k = 0; k < responseDecoded['employees_IDs_list'].length; k++) {
        // print(responseDecoded['employees_names_list'][k]);
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

class CustomerAddTask extends StatefulWidget {
  const CustomerAddTask({Key? key}) : super(key: key);

  @override
  _CustomerAddTaskState createState() => _CustomerAddTaskState();
}

// flutter pub add http
class _CustomerAddTaskState extends State<CustomerAddTask> {
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

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: loaddate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != loaddate) {
      setState(() {
        loaddate = picked;
      });
    }
  }

  Future<void> _selectDate3(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: unloaddate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != unloaddate) {
      setState(() {
        unloaddate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadSessionVariable(context).then((listMap) {
      setState(() {});
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
              Image.asset(
                "lib/images/splash.png",
                height: MediaQuery.of(context).size.height / 6,
              ),

              const SizedBox(height: 10),

              Text(
                "Send Request Form:",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
                textAlign: TextAlign.right,
              ),

              const SizedBox(height: 10),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: // First Name
                        Text(
                      'Select Load Location: ',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: // username field
                        AutocompleteBasicExample(val: loadlocation),
                  ),
                  const Expanded(flex: 3, child: Text(""))
                ],
              ),

              const SizedBox(height: 15),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: // First Name
                        Text(
                      'Select Unload Location: ',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: // username field
                        AutocompleteBasicExample2(val: unloadlocation),
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
                        Text('Enter Request Time'),
                  ),
                  Expanded(
                    flex: 4,
                    child: // First Name
                        ElevatedButton(
                      onPressed: () => _selectDate(context),
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
                        Text('Enter Load Date'),
                  ),
                  Expanded(
                    flex: 4,
                    child: // First Name
                        ElevatedButton(
                      onPressed: () => _selectDate2(context),
                      child: Text("${loaddate.toLocal()}".split(' ')[0]),
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
                        Text('Enter unLoad Date'),
                  ),
                  Expanded(
                    flex: 4,
                    child: // First Name
                        ElevatedButton(
                      onPressed: () => _selectDate3(context),
                      child: Text("${unloaddate.toLocal()}".split(' ')[0]),
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
                    ),
                  ),
                  const Expanded(flex: 1, child: Text(""))
                ],
              ),

              const SizedBox(height: 20),

              // sign in button
              ButtonLogin(
                onTap: () async {
                  await addTaskbycustomer(context);
                },
                buttonText: "Send",
              ),

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
        debugPrint('You just selected $selection');
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
        debugPrint('You just selected $selection');
        unloadlocation = selection;
      },
    );
  }
}
