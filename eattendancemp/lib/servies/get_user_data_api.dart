import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class GetUserDataAPI {
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    const String url =
        "https://mpedistrict.gov.in/eattendance/AttendenceWebAPI.asmx";

    final headers = {
      "Content-Type": "text/xml; charset=utf-8",
      "SOAPAction": "http://tempuri.org/GetUserData",
    };

    final body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xmlns:xsd="http://www.w3.org/2001/XMLSchema"
               xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetUserData xmlns="http://tempuri.org/">
      <UserId>$userId</UserId>
    </GetUserData>
  </soap:Body>
</soap:Envelope>
''';

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode != 200) return null;

    final document = XmlDocument.parse(response.body);
    final result = document.findAllElements('GetUserDataResult').first.text;

    return json.decode(result);
  }
}
