import 'package:packagetracker/components/ButtonNavigate.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:packagetracker/pages/employee.dart';
import 'package:packagetracker/pages/task.dart';
import 'package:packagetracker/pages/tasks_current.dart';
import 'package:packagetracker/pages/vehicle.dart';
import 'package:packagetracker/pages/employee_schedule.dart';
import 'package:packagetracker/pages/task_edit.dart';
import 'package:packagetracker/pages/task_view.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:packagetracker/components/MyAppBar.dart';

final _client = http.Client();

List<Map<String, String>> listOfColumns = [];

dynamic username = "", userid = "", usertype = "";
Future<void> loadSessionVariable(context) async {
  username = await SessionManager().get("username");
  userid = await SessionManager().get("userid");
  usertype = await SessionManager().get("usertype");
}

_isThereCurrentDialogShowing(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;

Future<void> loadTasksData(context) async {
  // print("hi");
  try {
    http.Response response = await _client.post(Uri.parse(
        "http://127.0.0.1:13000/listtasksdata?usertype=$usertype&userid=$userid"));
    var responseDecoded = jsonDecode(response.body);
    print(responseDecoded);
    if (responseDecoded['tasks_numbers_list'].length > 0) {
      listOfColumns = [];
      for (int k = 0; k < responseDecoded['tasks_numbers_list'].length; k++) {
        listOfColumns.add({
          "Task number": responseDecoded['tasks_numbers_list'][k],
          "Load location": responseDecoded['loadlocations_list'][k],
          "Unload location": responseDecoded['unloadlocations_list'][k],
          "Deadline": responseDecoded['deadlines_list'][k]
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

class EmployeeSchedule extends StatefulWidget {
  const EmployeeSchedule({Key? key}) : super(key: key);
  @override
  _EmployeeScheduleState createState() => _EmployeeScheduleState();
}

// flutter pub add http
class _EmployeeScheduleState extends State<EmployeeSchedule> {
  @override
  void initState() {
    super.initState();
    loadSessionVariable(context).then((listMap) {
      listOfColumns = [];
      loadTasksData(context).then((listMap) {
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
                height: MediaQuery.of(context).size.height / 3,
              ),

              const SizedBox(height: 10),

              DataTable(
                columns: const [
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('Task number')),
                  DataColumn(label: Text('Load location')),
                  DataColumn(label: Text('Unload location')),
                  DataColumn(label: Text('Deadline')),
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
                                          // IconButton(
                                          //   onPressed: () {
                                          // Navigator.of(context)
                                          //     .push(MaterialPageRoute(
                                          //   builder: (context) =>
                                          //       const TaskDelete(),
                                          //   settings: RouteSettings(
                                          //     arguments:
                                          //         element["Task number"],
                                          //   ),
                                          // ));
                                          //   },
                                          //   icon: const Icon(Icons.done),
                                          // ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    const TaskView(),
                                                settings: RouteSettings(
                                                  arguments:
                                                      element["Task number"],
                                                ),
                                              ));
                                            },
                                            icon: const Icon(
                                                Icons.remove_red_eye),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ), //Extracting from Map element the value
                                  DataCell(Text(element["Task number"]!)),
                                  DataCell(Text(element["Load location"]!)),
                                  DataCell(Text(element["Unload location"]!)),
                                  DataCell(Text(element["Deadline"]!)),
                                ],
                              )),
                        )
                        .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
