import 'dart:convert';
import 'dart:io';
import 'package:eattendancemp/Constant/strings.dart';
import 'package:http/http.dart' as http;
import 'package:eattendancemp/models/loginModel.dart';
//import 'package:device_info/device_info.dart';
//import 'package:device_info_plus/device_info_plus.dart';

class loginAPI {
  Future<loginModel> getLoginAPI(String user, String password) async {
    var login;
    var passwords = '&password=$password';
    var devicetoken = '';
    //DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      //AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      devicetoken = '&devicetoken=Android$user';
    } else if (Platform.isIOS) {
      //IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      devicetoken = '&devicetoken=iPhone$user';
    }

    var url = Uri.parse(Strings.loginString + user + passwords + devicetoken);
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      // Map<String, dynamic> user = jsonDecode(jsonString);
      login = loginModel.fromJson(jsonMap);
      //String message = user['response']['reponse_message'];
    }
    // } on Exception {
    //   return getEncryptedString;
    // }
    return login;
  }
}
