class saveUserAttendenceModel {
  Response? response;

  saveUserAttendenceModel({this.response});

  saveUserAttendenceModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  String? responseCode;
  String? reponseMessage;
  Data? data;

  Response({this.responseCode, this.reponseMessage, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    reponseMessage = json['reponse_message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['reponse_message'] = this.reponseMessage;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? punchType;
  String? punchDate;
  String? punchInTime;
  String? inLattitude;
  String? inLongitude;
  String? inLocation;
  String? outLattitude;
  String? outLongitude;
  String? outLocation;
  String? punchOutTime;

  Data(
      {this.punchType,
      this.punchDate,
      this.punchInTime,
      this.inLattitude,
      this.inLongitude,
      this.inLocation,
      this.outLattitude,
      this.outLongitude,
      this.outLocation,
      this.punchOutTime});

  Data.fromJson(Map<String, dynamic> json) {
    punchType = json['PunchType'];
    punchDate = json['PunchDate'];
    punchInTime = json['PunchInTime'];
    inLattitude = json['InLattitude'];
    inLongitude = json['InLongitude'];
    inLocation = json['InLocation'];
    outLattitude = json['OutLattitude'];
    outLongitude = json['OutLongitude'];
    outLocation = json['OutLocation'];
    punchOutTime = json['PunchOutTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PunchType'] = this.punchType;
    data['PunchDate'] = this.punchDate;
    data['PunchInTime'] = this.punchInTime;
    data['InLattitude'] = this.inLattitude;
    data['InLongitude'] = this.inLongitude;
    data['InLocation'] = this.inLocation;
    data['OutLattitude'] = this.outLattitude;
    data['OutLongitude'] = this.outLongitude;
    data['OutLocation'] = this.outLocation;
    data['PunchOutTime'] = this.punchOutTime;
    return data;
  }
}
