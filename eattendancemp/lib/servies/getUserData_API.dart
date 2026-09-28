import 'dart:convert';
import 'package:eattendancemp/constant/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:eattendancemp/models/getUserData_model.dart';

class getUserData_API {
  Future<getUserData_model> getUserDataAPI() async {
    var getResponce;
    var url = Uri.parse(Strings.getUserData);
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      getResponce = getUserData_model.fromJson(jsonMap);
    } else {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "Oops, something went wrong. Please try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: const Color.fromARGB(255, 172, 129, 247),
          textColor: const Color.fromARGB(255, 255, 255, 255),
          fontSize: 16.0);
      throw Exception('error.');
    }

    return getResponce;
  }
}
