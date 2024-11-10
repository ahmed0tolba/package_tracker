import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';
import 'package:packagetracker/components/MyAppBar.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

dynamic username = "", userid = "", usertype = "";
Future<void> loadSessionVariable(context) async {
  username = await SessionManager().get("username");
  userid = await SessionManager().get("userid");
  usertype = await SessionManager().get("usertype");
}

late int
    employeesIDsdropdownItemsselectedIndex; //where I want to store the selected index
String employeeID = "";
List<String> employeesIDsdropdownItems = [''];
late int
    VehiclesIDsdropdownItemsselectedIndex; //where I want to store the selected index
String Vehicleid = "";
List<String> VehiclesIDsdropdownItems = [''];
final tasknumberController = TextEditingController();
DateTime deadline = DateTime.now();
final taskdescriptionController = TextEditingController();
final loadlocationController = TextEditingController();
final unloadlocationController = TextEditingController();
String loadlocation = "Mekka";
String unloadlocation = "jeddah";

List<String> _locationsOptions = [''];

final _client = http.Client();
// late CameraTargetBounds boundingbox;
CameraTargetBounds boundingbox = CameraTargetBounds(LatLngBounds(
    northeast: const LatLng(27.6683619, 85.3101895),
    southwest: const LatLng(27.6683619, 85.3101895)));
String originaltasknumber = '';
LatLng mapcenter = const LatLng(27.6683619, 85.3101895);
LatLng vehiclelocation = const LatLng(27.6683619, 85.3101895);

LatLng startLocation = const LatLng(27.6683619, 85.3101895);
LatLng endLocation = const LatLng(27.6688312, 85.3077329);

Future<void> getroute() async {
  // print("hi");
  try {
    http.Response response = await _client.post(Uri.parse(
        "http://127.0.0.1:13000/getroute?destination=$unloadlocation&origin=$loadlocation&Vehicleid=$Vehicleid"));
    var responseDecoded = jsonDecode(response.body);
    print(responseDecoded);
    boundingbox = CameraTargetBounds(LatLngBounds(
        northeast: LatLng(responseDecoded['northeast']["lat"],
            responseDecoded['northeast']["lng"]),
        southwest: LatLng(responseDecoded['southwest']["lat"],
            responseDecoded['southwest']["lng"])));
    // print(boundingbox);
    mapcenter = LatLng(responseDecoded['mapcenter']["lat"],
        responseDecoded['mapcenter']["lng"]);
    // print(mapcenter);
    vehiclelocation = LatLng(responseDecoded['vehiclelocation']["lat"],
        responseDecoded['vehiclelocation']["lng"]);
    if (responseDecoded['polylinePoints'].length > 0) {
      polylinepointsList = [];
      polylineList = [];
      polylineList.clear();
      // print(responseDecoded['polylinePoints'][0]["lat"]);
      for (int k = 0; k < responseDecoded['polylinePoints'].length; k++) {
        polylinepointsList.add(LatLng(
            responseDecoded['polylinePoints'][k]["lat"],
            responseDecoded['polylinePoints'][k]["lng"]));
      }
      polylineList = [
        Polyline(
            polylineId: const PolylineId("1"),
            points: polylinepointsList,
            color: Colors.green)
      ];
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: mapcenter, zoom: 11)));
      markersList = <Marker>[
        Marker(
            markerId: const MarkerId('Vehicle'),
            position: vehiclelocation,
            infoWindow: InfoWindow.noText)
      ];
    } else {
      polylinepointsList = [];
      polylineList = [
        const Polyline(
            polylineId: PolylineId("1"), points: [], color: Colors.green)
      ];
    }
    // print(polylineList);
    // employeeID = employeesIDsdropdownItems[0];
    // print(dropdownItems);
    // setState(() {});
  } on Exception catch (_) {}
}

class TaskRoute extends StatefulWidget {
  const TaskRoute({Key? key}) : super(key: key);

  @override
  _TaskRouteState createState() => _TaskRouteState();
}

Set<Marker> markers = {};
List<Marker> markersList = [
  const Marker(
    markerId: MarkerId('Marker1'),
    position: LatLng(32.195476, 74.2023563),
    // infoWindow: InfoWindow(title: 'Business 1'),
    // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  ),
  const Marker(
    markerId: MarkerId('Marker2'),
    position: LatLng(31.110484, 72.384598),
    // infoWindow: InfoWindow(title: 'Business 2'),
    // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  ),
];

List<LatLng> polylinepointsList = [];

List<Polyline> polylineList = [
  // const Polyline(
  //     polylineId: PolylineId("1"),
  //     points: [
  //       LatLng(31.110484, 72.384598),
  //       LatLng(31.110484, 75.384598),
  //       LatLng(35.110484, 79.384598)
  //     ],
  //     color: Colors.green)
];

late GoogleMapController mapController;

// flutter pub add http
class _TaskRouteState extends State<TaskRoute> {
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    polylinepointsList = [];
    polylineList = [];
    polylineList.clear();
    setState(() {});
    getroute().then((listMap) {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    loadSessionVariable(context).then((listMap) {
      setState(() {});
    });
    // getroute().then((listMap) {
    // setState(() {});
    // });
    // markers.add(Marker(
    //   //add start location marker
    //   markerId: MarkerId(startLocation.toString()),
    //   position: startLocation, //position of marker
    //   infoWindow: const InfoWindow(
    //     //popup info
    //     title: 'Starting Point ',
    //     snippet: 'Start Marker',
    //   ),
    //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    // ));

    // markers.add(Marker(
    //   //add distination location marker
    //   markerId: MarkerId(endLocation.toString()),
    //   position: endLocation, //position of marker
    //   infoWindow: const InfoWindow(
    //     //popup info
    //     title: 'Destination Point ',
    //     snippet: 'Destination Marker',
    //   ),
    //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    // ));

    // getDirections(); //fetch direction polylines from Google API
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic>? args = ModalRoute.of(context)!.settings.arguments as List?;
    loadlocation = args![0] as String;
    unloadlocation = args[1] as String;
    Vehicleid = args[2] as String;
    // print(loadlocation);
    // print(unloadlocation);
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
        appBar: MyAppBar(
          usertype: usertype,
          context: context,
        ),
        body: GoogleMap(
          cameraTargetBounds: boundingbox,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: mapcenter,
            zoom: 3.0,
          ),
          markers: Set.from(markersList),
          polylines: Set.from(polylineList),
        ),
      ),
    );
  }
}
