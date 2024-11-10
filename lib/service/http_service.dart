// import 'dart:io'; // support all but web
// import 'package:http/io_client.dart';
import 'package:http/http.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:loginwithapi/views/dashboard.dart';
// import 'package:loginwithapi/views/welcome.dart';

class HttpService {
  static final client = Client();

  // static var _loginUrl = Uri.parse('http://127.0.0.1:80/login');

  // static var _registerUrl = Uri.http('127.0.0.1:5000/register');

  Future<void> login(email, password, context) async {
    // var response = await client.post(
    //   Uri.http("127.0.0.1", "/login"),
    //   body: {'name': 'doodle', 'color': 'blue'},
    // );
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    // request.headers
    //     .set(HttpHeaders.contentTypeHeader, "plain/text"); // or headers.add()

    // final response = await request.close();
    // request.headers
    //     .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    // request.write('{"email": $email,"password": $password}');

    // final response = await request.close();
    // debugPrint(request);
    // response.transform(utf8.decoder).listen((contents) {
    //   print(contents);
    // });

    // http.Response response = await _client.post(_loginUrl, body: {
    //   "email": email,
    //   "password": password,
    // });

    // if (response.statusCode == 200) {
    //   print(jsonDecode(response.body));
    //   var json = jsonDecode(response.body);

    //   if (json[0] == 'success') {
    //     await EasyLoading.showSuccess(json[0]);
    //     await Navigator.push(
    //         context, MaterialPageRoute(builder: (context) => Dashboard()));
    //   } else {
    //     EasyLoading.showError(json[0]);
    //   }
    // } else {
    //   await EasyLoading.showError(
    //       "Error Code : ${response.statusCode.toString()}");
    // }
  }

  static register(email, password, context) async {
    // http.Response response = await client.post(_registerUrl, body: {
    //   "email": email,
    //   "password": password,
    // });

    // if (response.statusCode == 200) {
    //   var json = jsonDecode(response.body);
    //   if (json[0] == 'username already exist') {
    //     await EasyLoading.showError(json[0]);
    //   } else {
    //     await EasyLoading.showSuccess(json[0]);
    //     Navigator.push(
    //         context, MaterialPageRoute(builder: (context) => Dashboard()));
    //   }
    // } else {
    //   await EasyLoading.showError(
    //       "Error Code : ${response.statusCode.toString()}");
    // }
  }
}
