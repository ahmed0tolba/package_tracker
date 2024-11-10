import 'dart:convert';
import 'package:packagetracker/components/TextInputLogin.dart';
import 'package:packagetracker/components/ButtonLogin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:maps_places_autocomplete/maps_places_autocomplete.dart';
import 'package:maps_places_autocomplete/model/place.dart';
import 'package:maps_places_autocomplete/model/suggestion.dart';
import 'package:packagetracker/components/MyAppBar.dart';
import 'package:packagetracker/pages/task.dart';
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
TextEditingValue unloadlocationTEV = const TextEditingValue(text: "");
TextEditingValue loadlocationTEV = const TextEditingValue(text: "");
String loadlocation = "Search Location";
String unloadlocation = "Search Location";

List<String> _locationsOptions = [''];

final _client = http.Client();

String originaltasknumber = '';

class TaskEdit extends StatefulWidget {
  const TaskEdit({Key? key}) : super(key: key);

  @override
  _TaskEditState createState() => _TaskEditState();
}

// flutter pub add http
class _TaskEditState extends State<TaskEdit> {
  late List<DropdownMenuItem<String>> list;

  Future<void> loadEmployeesIDs(context) async {
    // print("hi");
    try {
      http.Response response = await _client
          .get(Uri.parse("http://127.0.0.1:13000/listemployeesdata"));
      var responseDecoded = jsonDecode(response.body);
      if (responseDecoded['employees_IDs_list'].length > 0) {
        employeesIDsdropdownItems = [];
        for (int k = 0; k < responseDecoded['employees_IDs_list'].length; k++) {
          employeesIDsdropdownItems
              .add(responseDecoded['employees_IDs_list'][k]);
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

  Future<void> updateTask(context) async {
    String tasknumber = tasknumberController.text;
    String taskdescription = taskdescriptionController.text;
    // loadlocation = loadlocationController.text;
    // unloadlocation = unloadlocationController.text;

    try {
      http.Response response = await _client.post(Uri.parse(
          "http://127.0.0.1:13000/updatetask?originaltasknumber=$originaltasknumber&tasknumber=$tasknumber&employeeid=$employeeID&vehicleid=$VehicleID&deadline=$deadline&loadlocation=$loadlocation&unloadlocation=$unloadlocation&taskdescription=$taskdescription"));
      var responseDecoded = jsonDecode(response.body);
      print(responseDecoded);
      bool accepted = responseDecoded['success'];
      String message = responseDecoded['message'];

      if (response.statusCode == 200) {
        if (accepted) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Task updated successfuly."),
                );
              });
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context, rootNavigator: true).pop(true);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const Task()));
          });
        } else {
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(const Duration(seconds: 10), () {
                  Navigator.of(context, rootNavigator: true).pop(true);
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: deadline,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2025));
    if (picked != null && picked != deadline) {
      setState(() {
        deadline = picked;
      });
    }
  }

  Future<void> loadTaskData() async {
    try {
      http.Response response = await _client.post(Uri.parse(
          "http://127.0.0.1:13000/gettaskdata?tasknumber=$originaltasknumber"));
      var responseDecoded = jsonDecode(response.body);
      print(responseDecoded);
      tasknumberController.text = responseDecoded['tasknumber'];
      if (responseDecoded['employeeid'] != null) {
        employeeID = responseDecoded['employeeid'];
      }
      if (responseDecoded['vehicleid'] != null) {
        VehicleID = responseDecoded['vehicleid'];
      }
      loadlocationController.text = responseDecoded['loadlocation'];
      loadlocationTEV = TextEditingValue(text: responseDecoded['loadlocation']);
      unloadlocation = responseDecoded['unloadlocation'] ?? "";
      unloadlocationController.text = responseDecoded['unloadlocation'] ?? "";
      unloadlocationTEV =
          TextEditingValue(text: responseDecoded['unloadlocation'] ?? "");
      taskdescriptionController.text = responseDecoded['taskdescription'];
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
          loadTaskData().then((listMap) {
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
    List<dynamic>? args = ModalRoute.of(context)!.settings.arguments as List?;
    originaltasknumber = args![0] as String;
    loadlocation = args[1] as String;
    loadlocationTEV = TextEditingValue(text: loadlocation);
    loadlocationController.text = loadlocation;
    unloadlocation = args[2] as String;
    unloadlocationTEV = TextEditingValue(text: unloadlocation);
    unloadlocationController.text = unloadlocation;
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
                      onChanged: (String? newValue) {
                        setState(() {
                          VehicleID = newValue!;
                        });
                      },
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
                      onChanged: (String? newValue) {
                        setState(() {
                          employeeID = newValue!;
                        });
                      },
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
                    child: Autocomplete<String>(
                      initialValue: loadlocationTEV,
                      optionsBuilder:
                          (TextEditingValue textEditingValue) async {
                        loadlocation = textEditingValue.text;
                        try {
                          http.Response response = await _client.post(Uri.parse(
                              "http://127.0.0.1:13000/mapsautocomplete?input=${textEditingValue.text}"));
                          var responseDecoded = jsonDecode(response.body);
                          if (responseDecoded['suggestions'].length > 0) {
                            _locationsOptions = [];
                            for (int k = 0;
                                k < responseDecoded['suggestions'].length;
                                k++) {
                              _locationsOptions
                                  .add(responseDecoded['suggestions'][k][0]);
                            }
                            if (textEditingValue.text == '') {
                              return const Iterable<String>.empty();
                            }
                            return _locationsOptions;
                            // }
                          } else {
                            _locationsOptions = [''];
                          }
                        } on Exception catch (_) {}
                        return _locationsOptions;
                      },
                      onSelected: (String selection) {
                        loadlocation = selection;
                      },
                      // fieldViewBuilder: (BuildContext context,
                      //     TextEditingController textEditingController,
                      //     FocusNode focusNode,
                      //     VoidCallback onFieldSubmitted) {
                      //   return TextField(
                      //     decoration:
                      //         InputDecoration(border: OutlineInputBorder()),
                      //     controller: loadlocationController,
                      //     focusNode: focusNode,
                      //     onSubmitted: (String value) {},
                      //   );
                      // },
                    ),
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
                    child: AutocompleteBasicExample2(
                        val: unloadlocation, context: context),
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
                      onPressed: () => _selectDate(context),
                      child: Text("${deadline.toLocal()}".split(' ')[0]),
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

              const SizedBox(height: 10),

              // sign in button
              ButtonLogin(
                onTap: () async {
                  await updateTask(context);
                },
                buttonText: "Update Task",
              ),

              const SizedBox(height: 20),
              ButtonLogin(
                onTap: () async {
                  Future.delayed(const Duration(seconds: 0), () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Task()));
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
      initialValue: loadlocationTEV,

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
        } on Exception catch (_) {}
        return _locationsOptions;
      },
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
        loadlocation = selection;
      },
      // fieldViewBuilder: (BuildContext context,
      //     TextEditingController textEditingController,
      //     FocusNode focusNode,
      //     VoidCallback onFieldSubmitted) {
      //   return TextField(
      //     decoration: InputDecoration(border: OutlineInputBorder()),
      //     controller: unloadlocationController,
      //     focusNode: focusNode,
      //     onSubmitted: (String value) {},
      //   );
      // },
    );
  }
}

class AutocompleteBasicExample2 extends StatelessWidget {
  AutocompleteBasicExample2({super.key, required this.val, required context});
  String val;
  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: unloadlocationTEV,
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
        } on Exception catch (_) {}
        return _locationsOptions;
      },
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
        unloadlocation = selection;
      },
      // fieldViewBuilder: (BuildContext context,
      //     TextEditingController unloadlocationController,
      //     FocusNode focusNode,
      //     VoidCallback onFieldSubmitted) {
      //   return TextField(
      //     controller: unloadlocationController,
      //   );
      // },
    );
  }
}
