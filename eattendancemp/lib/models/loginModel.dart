class loginModel {
  Response? response;

  loginModel({this.response});

  loginModel.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? userName;
  String? lattitude;
  String? longitude;
  String? muser;
  String? officerange;
  String? officename;
  String? devicetoken;

  Response(
      {this.responseCode,
      this.reponseMessage,
      this.userId,
      this.userName,
      this.lattitude,
      this.longitude,
      this.muser,
      this.officerange,
      this.officename,
      this.devicetoken});

  Response.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    reponseMessage = json['reponse_message'];
    userId = json['user_id'];
    userName = json['user_name'];
    lattitude = json['lattitude'];
    longitude = json['longitude'];
    muser = json['muser'];
    officerange = json['officerange'];
    officename = json['officename'];
    devicetoken = json['devicetoken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['reponse_message'] = this.reponseMessage;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['lattitude'] = this.lattitude;
    data['longitude'] = this.longitude;
    data['muser'] = this.muser;
    data['officerange'] = this.officerange;
    data['officename'] = this.officename;
    data['devicetoken'] = this.devicetoken;
    return data;
  }
}
