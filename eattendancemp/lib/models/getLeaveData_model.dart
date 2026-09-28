class getLeaveData_model {
  Response? response;

  getLeaveData_model({this.response});

  getLeaveData_model.fromJson(Map<String, dynamic> json) {
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
  String? responseMessage;
  List<ResponseData>? responseData;

  Response({this.responseCode, this.responseMessage, this.responseData});

  Response.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    responseMessage = json['response_message'];
    if (json['response_data'] != null) {
      responseData = <ResponseData>[];
      json['response_data'].forEach((v) {
        responseData!.add(new ResponseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['response_message'] = this.responseMessage;
    if (this.responseData != null) {
      data['response_data'] =
          this.responseData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResponseData {
  int? requestid;
  String? username;
  String? fromdate;
  String? todate;
  String? leavereason;
  String? leavestatus;
  String? stationout;
  String? reasonstationout;
  String? applyDate;
  String? ofycrRemark;
  String? leavetype;
  String? dayoff;
  String? fromdateFSH;
  String? todateFSH;

  ResponseData(
      {this.requestid,
      this.username,
      this.fromdate,
      this.todate,
      this.leavereason,
      this.leavestatus,
      this.stationout,
      this.reasonstationout,
      this.applyDate,
      this.ofycrRemark,
      this.leavetype,
      this.dayoff,
      this.fromdateFSH,
      this.todateFSH});

  ResponseData.fromJson(Map<String, dynamic> json) {
    requestid = json['Requestid'];
    username = json['Username'];
    fromdate = json['Fromdate'];
    todate = json['Todate'];
    leavereason = json['Leavereason'];
    leavestatus = json['Leavestatus'];
    stationout = json['Stationout'];
    reasonstationout = json['Reasonstationout'];
    applyDate = json['ApplyDate'];
    ofycrRemark = json['OfycrRemark'];
    leavetype = json['Leavetype'];
    dayoff = json['Dayoff'];
    fromdateFSH = json['fromdateFSH'];
    todateFSH = json['todateFSH'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Requestid'] = this.requestid;
    data['Username'] = this.username;
    data['Fromdate'] = this.fromdate;
    data['Todate'] = this.todate;
    data['Leavereason'] = this.leavereason;
    data['Leavestatus'] = this.leavestatus;
    data['Stationout'] = this.stationout;
    data['Reasonstationout'] = this.reasonstationout;
    data['ApplyDate'] = this.applyDate;
    data['OfycrRemark'] = this.ofycrRemark;
    data['Leavetype'] = this.leavetype;
    data['Dayoff'] = this.dayoff;
    data['fromdateFSH'] = this.fromdateFSH;
    data['todateFSH'] = this.todateFSH;
    return data;
  }
}
