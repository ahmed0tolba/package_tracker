import 'package:flutter/material.dart';
import 'package:packagetracker/pages/admin_notifications.dart';
import 'package:packagetracker/pages/employee_edit.dart';
import 'package:packagetracker/pages/login_page.dart';
import 'package:packagetracker/pages/welcome.dart';
import 'package:packagetracker/pages/customer_welcome.dart';
import 'package:packagetracker/pages/employee_welcome.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

dynamic username = "", userid = "", usertype = "";
Future<void> loadSessionVariable(context) async {
  username = await SessionManager().get("username");
  userid = await SessionManager().get("userid");
  usertype = await SessionManager().get("usertype");
}

List<Map<String, String>> listOfColumns = [];
final _client = http.Client();
int requests_count = 0;

// ignore: must_be_immutable
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  String usertype;
  String userid;
  BuildContext context;
  MyAppBar(
      {super.key,
      this.usertype = "admin",
      this.userid = "",
      required this.context});
  bool isVisible = true;

  Future<void> loadTasksData(context) async {
    // print("hi");
    requests_count = 0;
    listOfColumns = [];
    try {
      http.Response response = await _client.post(Uri.parse(
          "http://127.0.0.1:13000/listtasksdata?username=$username&usertype=$usertype&userid=$userid"));
      var responseDecoded = jsonDecode(response.body);
      // print(responseDecoded);
      requests_count = 0;
      String approvedTF = "Not Approved";
      if (responseDecoded['tasks_numbers_list'].length > 0) {
        listOfColumns = [];
        for (int k = 0; k < responseDecoded['tasks_numbers_list'].length; k++) {
          if (responseDecoded['approved_list'][k] == "0") {
            approvedTF = "Not Approved";
            requests_count++;
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
      if (requests_count == 1) {
        requests_message = "You have ($requests_count) pending request.";
      }
      if (requests_count > 1) {
        requests_message = "You have ($requests_count) pending requests.";
      }
      // print(dropdownItems);
      // setState(() {});
    } on Exception catch (_) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (usertype == "admin") {
      isVisible = false;
    }

    loadTasksData(context);
    return AppBar(
      // title: Text("Hello Appbar"),
      backgroundColor: const Color.fromARGB(255, 245, 208, 96),
      leading: GestureDetector(
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onTap: () {
          // Navigator.of(context).pop();
          Navigator.of(
            context,
            rootNavigator: true,
          ).pop(
            context,
          );
        },
      ),

      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 40.0),
            child: GestureDetector(
              onTap: () {
                if (usertype == "admin") {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Welcome()));
                }
                if (usertype == "employee") {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const EmployeeWelcome()));
                }
                if (usertype == "customer") {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CustomerWelcome()));
                }
              },
              child: const Icon(
                Icons.home,
                size: 26.0,
              ),
            )),
        Padding(
            padding: const EdgeInsets.only(right: 40.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const EmployeeEdit(),
                  settings: const RouteSettings(
                    arguments: "",
                  ),
                ));
              },
              child: const Icon(
                Icons.person,
                size: 26.0,
              ),
            )),
        if (requests_count == 0 && usertype == "admin")
          Padding(
              padding: const EdgeInsets.only(right: 40.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AdminNotificationsPage()));
                },
                child: const Icon(
                  Icons.notifications,
                  size: 26.0,
                ),
              )),
        if (requests_count > 0 && usertype == "admin")
          Padding(
              padding: const EdgeInsets.only(right: 40.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AdminNotificationsPage()));
                },
                child: const Icon(
                  Icons.notification_add_rounded,
                  size: 26.0,
                ),
              )),
        Padding(
            padding: const EdgeInsets.only(right: 40.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: const Icon(
                Icons.logout,
                size: 26.0,
              ),
            )),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
