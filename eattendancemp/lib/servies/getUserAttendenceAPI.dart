import 'dart:convert';
import 'package:eattendancemp/Constant/strings.dart';
import 'package:http/http.dart' as http;
import 'package:eattendancemp/models/getUserAttendenceModel.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:device_info/device_info.dart';

class getUserAttendenceAPI {
  Future<getUserAttendenceModel> getAttendenceAPI(String user) async {
    var getResponce;
    var url = Uri.parse(Strings.getUserAttendence + user);
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      //Map<String, dynamic> user = jsonDecode(jsonString);
      getResponce = getUserAttendenceModel.fromJson(jsonMap);
      //String message = user['response']['reponse_message'];
    }
    // } on Exception {
    //   return getEncryptedString;
    // }
    return getResponce;
  }
}
