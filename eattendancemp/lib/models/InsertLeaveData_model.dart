class InsertLeaveData_model {
  Response? response;

  InsertLeaveData_model({this.response});

  InsertLeaveData_model.fromJson(Map<String, dynamic> json) {
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

  Response({this.responseCode, this.reponseMessage});

  Response.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    reponseMessage = json['reponse_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['reponse_message'] = this.reponseMessage;
    return data;
  }
}
