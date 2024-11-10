import 'dart:convert';
import 'package:packagetracker/components/TextInputLogin.dart';
import 'package:packagetracker/components/ButtonLogin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:packagetracker/components/MyAppBar.dart';
import 'package:packagetracker/pages/employee_welcome.dart';
import 'package:packagetracker/components/ButtonNavigate.dart';
import 'package:packagetracker/pages/task_route.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

dynamic username = "", userid = "", usertype = "";
Future<void> loadSessionVariable(context) async {
  username = await SessionManager().get("username");
  userid = await SessionManager().get("userid");
  usertype = await SessionManager().get("usertype");
}

_isThereCurrentDialogShowing(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;

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
final taskdescriptionController = TextEditingController();
final loadlocationController = TextEditingController();
final unloadlocationController = TextEditingController();
String loadlocation = "Jeddah";
String unloadlocation = "mekka";
String unloadeddate = "";
int finished = 0;
int approved = 0;
String finishedbutton = "Finish Task";
int started = 0;
bool active = true;
List<String> _locationsOptions = [''];

final _client = http.Client();

String originaltasknumber = '';

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

class TaskView extends StatefulWidget {
  const TaskView({Key? key}) : super(key: key);

  @override
  _TaskViewState createState() => _TaskViewState();
}

// flutter pub add http
class _TaskViewState extends State<TaskView> {
  late List<DropdownMenuItem<String>> list;

  Future<void> loadTaskData() async {
    try {
      http.Response response = await _client.post(Uri.parse(
          "http://127.0.0.1:13000/gettaskdata?tasknumber=$originaltasknumber"));
      var responseDecoded = jsonDecode(response.body);
      finished = responseDecoded['finished'];
      if (finished == 1) {
        active = false;
        finishedbutton = "Finished";
      }
      tasknumberController.text = responseDecoded['tasknumber'];
      employeeID =
          responseDecoded['employeeid'] ?? employeesIDsdropdownItems[0];
      VehicleID = responseDecoded['vehicleid'] ?? VehiclesIDsdropdownItems[0];
      loadlocationController.text = responseDecoded['loadlocation'];
      loadlocation = responseDecoded['loadlocation'];
      unloadlocationController.text = responseDecoded['unloadlocation'] ?? "";
      unloadlocation = responseDecoded['unloadlocation'] ?? "";
      taskdescriptionController.text = responseDecoded['taskdescription'];
      started = responseDecoded['started'];
      approved = responseDecoded['approved'];
      unloadeddate = responseDecoded['unloadeddate'];
      deadline = DateTime.parse(
          responseDecoded['deadline']); // no thing excutes after this line
      setState(() {});
    } on Exception catch (_) {}
  }

  Future<void> startTask(context) async {
    // print("hi");
    try {
      http.Response response = await _client.post(Uri.parse(
          "http://127.0.0.1:13000/starttask?tasknumber=$originaltasknumber"));
      var responseDecoded = jsonDecode(response.body);
      bool accepted = responseDecoded['success'];

      if (response.statusCode == 200) {
        loadTaskData();
        if (accepted) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Task Started successfuly."),
                );
              });
          Future.delayed(const Duration(seconds: 3), () {
            if (_isThereCurrentDialogShowing(context)) {
              Navigator.of(context, rootNavigator: true).pop(true);
            }
            setState(() {});
          });
        }
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
      return;
    }
  }

  Future<void> finishTask(context) async {
    // print("hi");
    try {
      http.Response response = await _client.post(Uri.parse(
          "http://127.0.0.1:13000/finishtask?tasknumber=$originaltasknumber"));
      var responseDecoded = jsonDecode(response.body);
      bool accepted = responseDecoded['success'];

      if (response.statusCode == 200) {
        if (accepted) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Task Finished successfuly."),
                );
              });
          setState(() {});
        }
      }
    } on Exception catch (_) {
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(const Duration(seconds: 3), () {
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

  @override
  void initState() {
    super.initState();
    loadSessionVariable(context).then((listMap) {
      loadVehiclesIDs(context).then((listMap1) {
        loadEmployeesIDs(context).then((listMap1) {
          loadTaskData().then((listMap1) {
            setState(() {});
          });
        });
      });
    });
    list = [];
  }

  @override
  Widget build(BuildContext context) {
    originaltasknumber = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: MyAppBar(usertype: usertype, context: context),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // const SizedBox(height: 10),
              // Image.asset(
              //   "lib/images/splash.png",
              //   height: MediaQuery.of(context).size.height / 7,
              // ),
              const SizedBox(height: 15),
              Image.asset(
                "lib/images/splash.png",
                height: MediaQuery.of(context).size.height / 4,
              ),
              const SizedBox(height: 5),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: // First Name
                        Text(
                      "Task Number:",
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
                      controller: tasknumberController,
                      hintText: 'Task Unique Number',
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
                    flex: 3,
                    child: // First Name
                        Text(
                      "Vehicle:",
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
                        DropdownButton(
                      value: VehicleID,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: VehiclesIDsdropdownItems.map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onTap: () {
                        // setState(() {});
                      },
                      onChanged: null,
                    ),
                  ),
                  const Expanded(flex: 3, child: Text(""))
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: // First Name
                        Text(
                      "Employee:",
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
                        DropdownButton(
                      value: employeeID,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: employeesIDsdropdownItems.map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onTap: () {
                        // setState(() {});
                      },
                      onChanged: null,
                    ),
                  ),
                  const Expanded(flex: 3, child: Text(""))
                ],
              ),

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

              const SizedBox(height: 10),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: // First Name
                        Text(
                      'Unload Location: ',
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
                      controller: unloadlocationController,
                      hintText: 'unload location',
                      obscureText: false,
                      enabled: false,
                    ),
                  ),
                  const Expanded(flex: 3, child: Text(""))
                ],
              ),

              const SizedBox(height: 10),
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

              const SizedBox(height: 10),

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

              if (started == 0 && approved == 1)
                ButtonLogin(
                  onTap: () {
                    showAlertDialogStart(context);
                  },
                  buttonText: "Start Task",
                ),

              const SizedBox(height: 10),

              // sign in button
              ButtonLogin(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TaskRoute(),
                    settings: RouteSettings(
                      arguments: [loadlocation, unloadlocation, VehicleID],
                    ),
                  ));
                },
                buttonText: "Show traffic route",
              ),

              const SizedBox(height: 10),

              if (unloadeddate != "")
                ButtonNavigate(
                  active: active,
                  onTap: () {
                    showAlertDialogFinish(context);
                  },
                  buttonText: finishedbutton,
                ),
              const SizedBox(height: 10),
              ButtonLogin(
                onTap: () async {
                  Future.delayed(const Duration(seconds: 0), () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const EmployeeWelcome()));
                  });
                },
                buttonText: "Back",
              ),

              const SizedBox(height: 10)
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

  showAlertDialogFinish(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Finish"),
      onPressed: () {
        Navigator.pop(context);
        finishTask(context).then((listMap) {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm Finish"),
      content:
          const Text("Are you sure you want to mark that task as finished?"),
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

  showAlertDialogStart(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Start"),
      onPressed: () {
        startTask(context).then((listMap) {
          setState(() {});
        });
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm start"),
      content:
          const Text("Are you sure you want to mark that task as started?"),
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
