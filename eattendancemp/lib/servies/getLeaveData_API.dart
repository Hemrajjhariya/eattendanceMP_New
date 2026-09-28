import 'dart:convert';
import 'package:eattendancemp/constant/strings.dart';
import 'package:eattendancemp/models/getLeaveData_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class getLeaveData_API {
  Future<getLeaveData_model> getLeaveDataAPI(Map param) async {
    try {
      final response = await http.post(
        Uri.parse(Strings.getLeaveData),
        headers: <String, String>{
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: param,
      );

      String mapData = jsonEncode(param);
      print(mapData);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        // then parse the JSON.
        return getLeaveData_model.fromJson(jsonDecode(response.body));
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
    } on Exception catch (_) {
      // make it explicit that this function can throw exceptions
      rethrow;
    }
  }
}
