import 'dart:convert';
import 'package:eattendancemp/constant/strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:eattendancemp/models/saveUserAttendenceModel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class saveUserAttendenceAPI {
  Future<saveUserAttendenceModel> saveUserAttendence(Map userData) async {
    var postModel;
    postModel = null;
    var clinet = http.Client();
    var body = jsonEncode({
      //'data': {'user_id': '11'}
      'data': userData
    });
    print(userData);
    //  try {
    // await http
    //     .post(Strings.saveUserAttendence,
    //         headers: {"Content-Type": "application/x-www-form-urlencoded"},
    //         body: userData)
    var url = Uri.parse(Strings.saveUserAttendence);
    http
        .post(url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: userData)
        .then((http.Response response) {
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        Map<String, dynamic> user = jsonDecode(jsonString);
        postModel = saveUserAttendenceModel.fromJson(jsonMap);
        String message = user['response']['reponse_message'];
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: const Color.fromARGB(255, 172, 129, 247),
            textColor: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 16.0);
      } else {
        // Fluttertoast.showToast(
        //     msg: response.reasonPhrase,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.white,
        //     textColor: Colors.black,
        //     fontSize: 16.0);
      }
    });
    // } catch (Exception) {
    //   return postModel;
    // }
    return postModel;
  }
}
