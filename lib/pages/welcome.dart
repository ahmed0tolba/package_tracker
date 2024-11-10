import 'package:packagetracker/components/ButtonNavigate.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:packagetracker/components/MyAppBar.dart';
import 'package:packagetracker/pages/employee.dart';
import 'package:packagetracker/pages/task.dart';
import 'package:packagetracker/pages/tasks_current.dart';
import 'package:packagetracker/pages/vehicle.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

dynamic username = "", userid = "", usertype = "";
Future<void> loadSessionVariable(context) async {
  username = await SessionManager().get("username");
  userid = await SessionManager().get("userid");
  usertype = await SessionManager().get("usertype");
}

final usernameController = TextEditingController();
final passwordController = TextEditingController();

Future<void> signUserIn() async {
  final username = usernameController.text;
  final password = passwordController.text;
  var response = await post(
    Uri.http("127.0.0.1", "/login"),
    body: {'username': username, 'password': password},
  );
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

// flutter pub add http
class _WelcomeState extends State<Welcome> {
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
              const SizedBox(height: 50),

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

              const SizedBox(height: 15),
              Image.asset(
                "lib/images/splash.png",
                height: MediaQuery.of(context).size.height / 3,
              ),

              const SizedBox(height: 25),

              //
              ButtonNavigate(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Employee()));
                },
                buttonText: "Employee \n Information",
              ),

              const SizedBox(height: 25),

              ButtonNavigate(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Task()));
                },
                buttonText: "Manage Tasks",
              ),

              const SizedBox(height: 25),

              ButtonNavigate(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Vehicle()));
                },
                buttonText: "Vehicle",
              ),
              const SizedBox(height: 25),

              ButtonNavigate(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TasksCurrent()));
                },
                buttonText: "Task progresss",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
