import 'dart:convert';
import 'package:packagetracker/components/TextInputLogin.dart';
import 'package:packagetracker/components/ButtonLogin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:packagetracker/components/MyAppBar.dart';
import 'package:packagetracker/pages/vehicle.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

dynamic username = "", userid = "", usertype = "";
Future<void> loadSessionVariable(context) async {
  username = await SessionManager().get("username");
  userid = await SessionManager().get("userid");
  usertype = await SessionManager().get("usertype");
}

_isThereCurrentDialogShowing(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;

final vehicleIDController = TextEditingController();
final manufacturerController = TextEditingController();
final modelyearController = TextEditingController();
final colorController = TextEditingController();
final sizeeController = TextEditingController();
final trackeridController = TextEditingController();

final _client = http.Client();
String originalvehicleID = '';
Future<void> deleteVehicle(context) async {
  try {
    http.Response response = await _client.post(Uri.parse(
        "http://127.0.0.1:13000/deletevehicle?vehicleID=$originalvehicleID"));
    var responseDecoded = jsonDecode(response.body);
    print(responseDecoded);
    bool accepted = responseDecoded['success'];
    String message = responseDecoded['message'];
    int status = responseDecoded['status'];
    if (response.statusCode == 200) {
      if (accepted) {
        Future.delayed(const Duration(seconds: 3), () {
          if (_isThereCurrentDialogShowing(context)) {
            Navigator.of(context, rootNavigator: true).pop(true);
          }
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Vehicle()));
        });
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Vehicle Deleted successfuly."),
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

class VehicleDelete extends StatefulWidget {
  const VehicleDelete({Key? key}) : super(key: key);

  @override
  _VehicleDeleteState createState() => _VehicleDeleteState();
}

class _VehicleDeleteState extends State<VehicleDelete> {
  Future<void> loadVehicleData(context) async {
    try {
      http.Response response = await _client.post(Uri.parse(
          "http://127.0.0.1:13000/getvehicledata?vehicleID=$originalvehicleID"));
      var responseDecoded = jsonDecode(response.body);

      vehicleIDController.text = responseDecoded['vehicleID'];
      manufacturerController.text = responseDecoded['manufacturer'];
      modelyearController.text = responseDecoded['modelyear'];
      colorController.text = responseDecoded['color'];
      sizeeController.text = responseDecoded['sizee'];
      trackeridController.text = responseDecoded['trackerid'] ?? "";
    } on Exception catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    originalvehicleID = ModalRoute.of(context)!.settings.arguments as String;
    loadVehicleData(context);

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
                    flex: 2,
                    child: // First Name
                        Text(
                      "Vehicle ID (Plate number):",
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
                      controller: vehicleIDController,
                      hintText: 'First Name',
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
                    flex: 2,
                    child: // First Name
                        Text(
                      "Manufacturer company:",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: // Last Name field
                        MyTextField(
                      controller: manufacturerController,
                      hintText: 'Manufacturer company',
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
                    flex: 2,
                    child: // Birthday
                        Text(
                      "Model year:",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: //
                        // Birthday
                        MyTextField(
                      controller: modelyearController,
                      hintText: 'Model year',
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
                    flex: 2,
                    child: // Phone
                        Text(
                      "Color:",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: //
                        // Birthday
                        MyTextField(
                      controller: colorController,
                      hintText: 'Color',
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
                    flex: 2,
                    child: // Phone
                        Text(
                      "Size:",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: //
                        // Email
                        MyTextField(
                      controller: sizeeController,
                      hintText: 'Size',
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
                    flex: 2,
                    child: // Phone
                        Text(
                      "Tracker ID:",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: //
                        // Email
                        MyTextField(
                      controller: trackeridController,
                      hintText: 'Tracker ID',
                      obscureText: false,
                      enabled: false,
                    ),
                  ),
                  const Expanded(flex: 2, child: Text(""))
                ],
              ),

              const SizedBox(height: 10),
              // sign in button
              ButtonLogin(
                onTap: () async {
                  await deleteVehicle(context);
                },
                buttonText: "Delete Vehicle",
              ),

              const SizedBox(height: 25),
              ButtonLogin(
                onTap: () async {
                  Future.delayed(const Duration(seconds: 0), () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Vehicle()));
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
