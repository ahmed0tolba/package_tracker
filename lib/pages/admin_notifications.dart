import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:packagetracker/pages/task.dart';
import 'package:packagetracker/components/MyAppBar.dart';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:packagetracker/pages/task_request.dart';

dynamic username = "", userid = "", usertype = "";
Future<void> loadSessionVariable(context) async {
  username = await SessionManager().get("username");
  userid = await SessionManager().get("userid");
  usertype = await SessionManager().get("usertype");
}

final _client = http.Client();
List<Map<String, String>> listOfColumns = [];
int requests_count_notify = 0;
int wrong_count_notify = 0;
String requests_message = "You have no pending requests";
String wrong_message = "";

_isThereCurrentDialogShowing(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;

Future<void> loadTasksData(context) async {
  // print("hi");
  listOfColumns = [];
  try {
    http.Response response = await _client.post(Uri.parse(
        "http://127.0.0.1:13000/listtasksdata?username=$username&usertype=$usertype&userid=$userid"));
    var responseDecoded = jsonDecode(response.body);
    print(responseDecoded);
    String approvedTF = "Not Approved";
    requests_count_notify = 0;
    wrong_count_notify = 0;
    if (responseDecoded['tasks_numbers_list'].length > 0) {
      listOfColumns = [];
      for (int k = 0; k < responseDecoded['tasks_numbers_list'].length; k++) {
        if (responseDecoded['approved_list'][k] == "0") {
          approvedTF = "Not Approved";
          requests_count_notify++;
        } else {
          approvedTF = "Approved";
        }
        if (responseDecoded['status_list'][k] == "wrong") {
          wrong_count_notify++;
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
    if (requests_count_notify == 1) {
      requests_message = "You have ($requests_count) pending request.";
    }
    if (requests_count_notify > 1) {
      requests_message = "You have ($requests_count) pending requests.";
    }
    if (wrong_count_notify == 1) {
      wrong_message = "You have ($requests_count) wrong drop.";
    }
    if (wrong_count_notify > 1) {
      wrong_message = "You have ($requests_count) wrong drops.";
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

class AdminNotificationsPage extends StatefulWidget {
  const AdminNotificationsPage({Key? key}) : super(key: key);

  @override
  _AdminNotificationsPageState createState() => _AdminNotificationsPageState();
}

// flutter pub add http
class _AdminNotificationsPageState extends State<AdminNotificationsPage> {
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
                height: MediaQuery.of(context).size.height / 4,
              ),

              const SizedBox(height: 10),

              const Text(
                "Notifications",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              //
              DataTable(
                columns: const [
                  DataColumn(label: Text('')),
                ],
                rows: <DataRow>[
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text(requests_message)),
                    ],
                    onLongPress: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const TaskRequest()));
                    },
                  ),
                  if (wrong_count_notify > 0)
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text(wrong_message)),
                      ],
                      onLongPress: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Task()));
                      },
                    ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
