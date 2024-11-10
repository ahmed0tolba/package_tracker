import 'package:packagetracker/components/ButtonLogin.dart';
import 'package:packagetracker/components/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:packagetracker/pages/task_add.dart';
import 'package:packagetracker/pages/task_edit.dart';
import 'package:packagetracker/pages/task_delete.dart';
import 'package:packagetracker/pages/task_approve.dart';
import 'dart:convert';
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
List<Map<String, String>> listOfColumns = [];

Future<void> loadTasksData(context) async {
  // print("hi");
  try {
    http.Response response = await _client.post(Uri.parse(
        "http://127.0.0.1:13000/listtasksdata?username=$username&usertype=$usertype&userid=$userid"));
    var responseDecoded = jsonDecode(response.body);
    print(responseDecoded);
    String approvedTF = "Not Approved";
    if (responseDecoded['tasks_numbers_list'].length > 0) {
      listOfColumns = [];
      for (int k = 0; k < responseDecoded['tasks_numbers_list'].length; k++) {
        if (responseDecoded['approved_list'][k] == "0") {
          approvedTF = "Not Approved";
        } else {
          approvedTF = "Approved";
        }
        listOfColumns.add({
          "Task number": responseDecoded['tasks_numbers_list'][k],
          "Load location": responseDecoded['loadlocations_list'][k],
          "Unload location": responseDecoded['unloadlocations_list'][k] ?? "",
          "Deadline": responseDecoded['deadlines_list'][k],
          "approved": responseDecoded['approved_list'][k],
          "approvedTF": approvedTF,
          "started": responseDecoded['started_list'][k],
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

class TaskRequest extends StatefulWidget {
  const TaskRequest({Key? key}) : super(key: key);

  @override
  _TaskRequestState createState() => _TaskRequestState();
}

// flutter pub add http
class _TaskRequestState extends State<TaskRequest> {
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
                height: MediaQuery.of(context).size.height / 5,
              ),

              const SizedBox(height: 10),

              DataTable(
                headingRowHeight: 40,
                dataRowHeight: 70,
                columns: const [
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('Request number')),
                  DataColumn(label: Text('Load location')),
                  DataColumn(label: Text('Deadline')),
                ],
                rows:
                    listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
                        .map(
                          ((element) => DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    SizedBox(
                                      width: 130,
                                      child: Row(
                                        children: [
                                          if (element["approvedTF"] ==
                                                  "Not Approved" &&
                                              element["started"] == "0")
                                            IconButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      const TaskApprove(),
                                                  settings: RouteSettings(
                                                    arguments: [
                                                      element["Task number"],
                                                      element["Load location"],
                                                      element[
                                                          "Unload location"],
                                                    ],
                                                  ),
                                                ));
                                              },
                                              icon: const Icon(Icons
                                                  .check_box_outline_blank),
                                            ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    const TaskDelete(),
                                                settings: RouteSettings(
                                                  arguments: [
                                                    element["Task number"],
                                                    element["Load location"],
                                                    element["Unload location"],
                                                  ],
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
                                                    const TaskEdit(),
                                                settings: RouteSettings(
                                                  arguments: [
                                                    element["Task number"],
                                                    element["Load location"],
                                                    element["Unload location"],
                                                  ],
                                                ),
                                              ));
                                            },
                                            icon: const Icon(Icons.edit),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ), //Extracting from Map element the value
                                  DataCell(Text(
                                      "${element["Task number"]!} ( ${element["approvedTF"]!} ) ")),
                                  DataCell(Text(element["Load location"]!)),
                                  DataCell(Text(element["Deadline"]!)),
                                ],
                              )),
                        )
                        .toList(),
              ),

              const SizedBox(height: 10),

              ButtonLogin(
                onTap: () async {
                  Future.delayed(const Duration(seconds: 0), () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const TaskAdd()));
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

Widget _verticalDivider = const VerticalDivider(
  color: Colors.black,
  thickness: 1,
);
