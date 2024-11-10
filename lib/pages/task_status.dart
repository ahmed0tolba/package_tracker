import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:packagetracker/components/ButtonLogin.dart';
import 'package:packagetracker/components/MyAppBar.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:packagetracker/pages/welcome.dart';

dynamic username = "", userid = "", usertype = "";
Future<void> loadSessionVariable(context) async {
  username = await SessionManager().get("username");
  userid = await SessionManager().get("userid");
  usertype = await SessionManager().get("usertype");
}

final tasknumberController = TextEditingController();

String tasknumber = '';
String approveddate = "";
String starteddate = "";
String loadeddate = "";
String unloadeddate = "";
String finisheddate = "";

final _client = http.Client();

class TaskStatus extends StatefulWidget {
  const TaskStatus({Key? key}) : super(key: key);

  @override
  _TaskStatusState createState() => _TaskStatusState();
}

// flutter pub add http
class _TaskStatusState extends State<TaskStatus> {
  Future<void> loadTaskData() async {
    try {
      http.Response response = await _client.post(Uri.parse(
          "http://127.0.0.1:13000/gettaskdata?tasknumber=$tasknumber"));
      var responseDecoded = jsonDecode(response.body);
      // print("responseDecoded");
      print(responseDecoded);
      tasknumberController.text = responseDecoded['tasknumber'];
      approveddate = responseDecoded['approveddate'] ?? "";
      starteddate = responseDecoded['starteddate'] ?? "";
      loadeddate = responseDecoded['loadeddate'] ?? "";
      unloadeddate = responseDecoded['unloadeddate'] ?? "";
      finisheddate = responseDecoded['finisheddate'] ?? "";
      // print(approveddate);
      // print(starteddate);
    } on Exception catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    loadSessionVariable(context).then((listMap) {
      List<dynamic>? args = ModalRoute.of(context)!.settings.arguments as List?;
      tasknumber = args![0] as String;
      loadTaskData().then((listMap) {
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
              Image.asset(
                "lib/images/splash.png",
                height: MediaQuery.of(context).size.height / 4,
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: // First Name
                        Text(
                      "Task Number : ",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      "  $tasknumber",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ), // username field
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        finisheddate,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  if (finisheddate == "")
                    const Expanded(
                      flex: 1,
                      child: Icon(Icons.circle_outlined),
                    ),
                  if (finisheddate != "")
                    const Expanded(
                      flex: 1,
                      child: Icon(Icons.check_circle_outline_rounded),
                    ),
                  const Expanded(flex: 4, child: Text("Task finished"))
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: // First Name
                          Text(
                        unloadeddate,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  if (unloadeddate == "")
                    const Expanded(
                      flex: 1,
                      child: Icon(Icons.circle_outlined),
                    ),
                  if (unloadeddate != "")
                    const Expanded(
                      flex: 1,
                      child: Icon(Icons.check_circle_outline_rounded),
                    ),
                  const Expanded(flex: 4, child: Text("Package unloaded"))
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: // First Name
                          Text(
                        loadeddate,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  if (loadeddate == "")
                    const Expanded(
                      flex: 1,
                      child: Icon(Icons.circle_outlined),
                    ),
                  if (loadeddate != "")
                    const Expanded(
                      flex: 1,
                      child: Icon(Icons.check_circle_outline_rounded),
                    ),
                  const Expanded(flex: 4, child: Text("Package Loaded"))
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: // First Name
                          Text(
                        starteddate,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  if (starteddate == "")
                    const Expanded(
                      flex: 1,
                      child: Icon(Icons.circle_outlined),
                    ),
                  if (starteddate != "")
                    const Expanded(
                      flex: 1,
                      child: Icon(Icons.check_circle_outline_rounded),
                    ),
                  const Expanded(flex: 4, child: Text("Task Started"))
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: // First Name
                          Text(
                        approveddate,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  if (approveddate == "")
                    const Expanded(
                      flex: 1,
                      child: Icon(Icons.circle_outlined),
                    ),
                  if (approveddate != "")
                    const Expanded(
                      flex: 1,
                      child: Icon(Icons.check_circle_outline_rounded),
                    ),
                  const Expanded(flex: 4, child: Text("Task approved"))
                ],
              ),
              const SizedBox(height: 20),
              ButtonLogin(
                onTap: () async {
                  Future.delayed(const Duration(seconds: 0), () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Welcome()));
                  });
                },
                buttonText: "Back",
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
