// ignore: file_names
// ignore: unused_import, import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

class Strings {
  /*
  static String postUrl =
      'http://13.57.228.121:4012/api/music-event-podcast-list';
  static String newsUrl =
      'http://newsapi.org/v2/everything?q=tesla&from=2021-01-10&sortBy=publishedAt&apiKey=4fbb3756ad504d638d9faa84046885ff';
  static String getEncryptedString =
      'http://164.100.196.42/mobileapi/public_apis.asmx/get_encrypted_string?key=VwAxYoM3C0Y=';
  // static String loginString =
  //    'http://164.100.196.44/cmoportal/monitlogin.asmx/get_GT_Login?userId=';
  static String cmmointString =
      'http://164.100.196.44/cmoportal/monitlogin.asmx/get_cmmonit_details?key=';
  static String cmrfString =
      'http://164.100.196.44/cmoportal/monitlogin.asmx/get_cmrf_details?key=';
  static String searchString =
      'http://164.100.196.44/cmoportal/monitlogin.asmx/get_officer_list?encr=H2sURS39/0s=';
  static String ePassString =
      'http://164.100.196.44/cmoportal/monitlogin.asmx/InsertVEPassDataNew';
  static String getAppVersionString =
      'http://164.100.196.44/cmoportal/monitlogin.asmx/get_app_version';
      */

//Eattendance app
//old:- http://mid.mp.nic.in/csomp/eattandvalidate.aspx
  static String loginString =
      'https://mpedistrict.gov.in/eattendance/AttendenceWebAPI.asmx/getEmpLoginData?user_id=';

  static String EditContactURL =
      "https://mpedistrict.gov.in/eattendance/AttendenceWebAPI.asmx?cont=";
  // Web url
  static String dashboardWebURL =
      "https://mpedistrict.gov.in/eattendance/AttendenceWebAPI.asmx?appData";

  static String saveUserAttendence =
      'https://mpedistrict.gov.in/eattendance/AttendenceWebAPI.asmx/InsertEmpData';

  static String getUserAttendence =
      'https://mpedistrict.gov.in/eattendance/AttendenceWebAPI.asmx/SelectEmpData?user_id=';

  static String InsertLeaveData =
      "https://mpedistrict.gov.in/eattendance/AttendenceWebAPI.asmx/InsertLeaveData";

  static String getLeaveData =
      "https://mpedistrict.gov.in/eattendance/AttendenceWebAPI.asmx/GetLeaveData";

  static String getUserData =
      "https://mpedistrict.gov.in/eattendance/AttendenceWebAPI.asmx/GetUserData";

  static String submitLeavestatus =
      "https://mpedistrict.gov.in/eattendance/AttendenceWebAPI.asmx/SubmitLeavestatus";

  static String deleteLeave =
      "https://mpedistrict.gov.in/eattendance/AttendenceWebAPI.asmx/DeleteLeave";
}
