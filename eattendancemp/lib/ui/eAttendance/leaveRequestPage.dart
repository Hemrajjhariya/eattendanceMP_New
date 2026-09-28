import 'package:eattendancemp/models/getLeaveData_model.dart';
import 'package:eattendancemp/models/submitLeavestatus_model.dart';
import 'package:eattendancemp/servies/getLeaveData_API.dart';
import 'package:eattendancemp/servies/submitLeavestatus_API.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eattendancemp/servies/getUserData_API.dart';
import 'package:eattendancemp/models/getUserData_model.dart';

/* ================== GRADIENTS ================== */

const LinearGradient appGradient = LinearGradient(
  colors: [Color(0xFF4527A0), Color(0xFF5E35B1), Color(0xFF3949AB)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient buttonGradient = LinearGradient(
  colors: [Color(0xFF5E35B1), Color(0xFF3949AB)],
);

const LinearGradient evenRowGradient = LinearGradient(
  colors: [Color(0xFFE9E4FF), Color(0xFFDCD6FF)],
);

const LinearGradient oddRowGradient = LinearGradient(
  colors: [Color(0xFFFFFFFF), Color(0xFFF3F1FF)],
);

// ignore: camel_case_types
class leaveRequestPage extends StatelessWidget {
  const leaveRequestPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: leavePage(title: ''),
    );
  }
}

class leavePage extends StatefulWidget {
  const leavePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<leavePage> {
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("विवाहित"), value: "विवाहित"),
      DropdownMenuItem(value: "अविवाहित", child: Text("अविवाहित")),
      DropdownMenuItem(child: Text("तलाकशुदा"), value: "तलाकशुदा"),
    ];
    return menuItems;
  }

  late Future<getUserData_model> getUserDataModel;

  int isRemarkIndex = -1;

  String? selectCast;
  bool _isLoading = false;

  bool isAll = false;
  bool isApprove = false;
  bool isPending = true;

  var userName = "";
  var userId = "";

  Future<getLeaveData_model>? _getModel;
  List<String> userList = [];
  String? userNames;
  String statusType = "P";

  TextEditingController txtRemark = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData(statusType, userId);

    //user list
    getUserDataModel = getUserData_API().getUserDataAPI();
    List<String> userListData = [];
    getUserDataModel.then((object) {
      userListData.add("All");
      for (var i = 0; i < object.response!.responseData!.length; i++) {
        var data = object.response!.responseData![i];
        userListData.add(data.userName!);
      }
      setState(() {
        userList = userListData;
      });
    });
  }

  Future<void> getData(String status, String userId) async {
    EasyLoading.show(status: 'loading...');
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = "Welcome : ${prefs.getString('userName')!}";
    });

    Map param = {
      "user_id": userId,
      "status": status,
    };

    //--- call get API
    _getModel = getLeaveData_API().getLeaveDataAPI(param);
    _getModel?.then((object) {
      if (object.response!.responseCode == "1") {
        EasyLoading.dismiss();
        // Fluttertoast.showToast(
        //     msg: object.response!.responseMessage!,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.white,
        //     textColor: Colors.black,
        //     fontSize: 16.0);
      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: "error",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: const Color.fromARGB(255, 172, 129, 247),
            textColor: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 16.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Leave Request'),
          backgroundColor: const Color.fromARGB(255, 96, 61, 157),
          flexibleSpace:
              Container(decoration: const BoxDecoration(gradient: appGradient)),
        ),
        body: Container(
          color: const Color(0xFFF6F7FB),
          child: ListView(shrinkWrap: true, children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              child: Stack(children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.fromLTRB(18, 10, 20, 0),
                    child: Text(
                      userName,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 96, 61, 157)),
                    )),
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: DropdownButtonFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'कृपया जिला दर्ज करें';
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        labelText: 'All',
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 76, 0, 39),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(149, 158, 158, 158),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 76, 0, 39),
                            width: 1.5,
                          ),
                        ),
                      ),

                      dropdownColor: Colors.white,
                      value: userNames,
                      onChanged: (String? newValue) {
                        isRemarkIndex = -1;
                        getUserDataModel.then((object) {
                          if (newValue == "All") {
                            userId = "";
                          } else {
                            for (var i = 0;
                                i < object.response!.responseData!.length;
                                i++) {
                              if (newValue ==
                                  object.response!.responseData![i].userName) {
                                userId =
                                    object.response!.responseData![i].userId!;
                              }
                            }
                          }

                          getData(statusType, userId);
                        });
                      },
                      items: userList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(15, 90, 15, 0),
                  child: Row(
                    children: [
                      gradientButton(
                        title: "All",
                        selected: isAll,
                        onTap: () {
                          statusType = "";
                          setState(() {
                            isRemarkIndex = -1;
                            isAll = true;
                            isApprove = false;
                            isPending = false;
                          });
                          getData(statusType, userId);
                        },
                      ),
                      const SizedBox(width: 8),
                      gradientButton(
                        title: "Approved",
                        selected: isApprove,
                        onTap: () {
                          statusType = "A";
                          setState(() {
                            isRemarkIndex = -1;
                            isAll = false;
                            isApprove = true;
                            isPending = false;
                          });
                          getData(statusType, userId);
                        },
                      ),
                      const SizedBox(width: 8),
                      gradientButton(
                        title: "Pending",
                        selected: isPending,
                        onTap: () {
                          statusType = "P";
                          setState(() {
                            isRemarkIndex = -1;
                            isAll = false;
                            isApprove = false;
                            isPending = true;
                          });
                          getData(statusType, userId);
                        },
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      // border: Border.all(
                      //   color: const Color.fromARGB(255, 96, 61, 157),
                      //   style: BorderStyle.solid,
                      //   width: 1.0,
                      // ),
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    margin: const EdgeInsets.only(top: 155),
                    height: screenSize.height / 1.6,
                    width: screenSize.width / 1.05,
                    child: ListView(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        children: <Widget>[
                          FutureBuilder<getLeaveData_model>(
                              future: _getModel,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data?.response
                                              ?.responseData?.length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        var data = snapshot.requireData
                                            .response!.responseData![index];
                                        var username = data.username;
                                        var leavereason = data.leavereason;
                                        var leavestatus = data.leavestatus;
                                        var stationout = data.stationout;
                                        var ofycrRemark = data.ofycrRemark;
                                        var fromdateFSH =
                                            data.fromdateFSH ?? "";
                                        var todateFSH = data.todateFSH ?? "";
                                        var reasonstationout =
                                            "Station Leave : ${data.reasonstationout}";
                                        var leavetype = data.leavetype ?? "";

                                        var date = "";
                                        if (fromdateFSH.isNotEmpty &&
                                            todateFSH.isNotEmpty) {
                                          date =
                                              "${data.fromdate!} ($fromdateFSH) To ${data.todate!} ($todateFSH) ";
                                        } else if (fromdateFSH.isNotEmpty &&
                                            todateFSH.isEmpty) {
                                          date =
                                              "${data.fromdate!} ($fromdateFSH) To ${data.todate!}";
                                        } else if (fromdateFSH.isEmpty &&
                                            todateFSH.isNotEmpty) {
                                          date =
                                              "${data.fromdate!} To ${data.todate!} ($todateFSH) ";
                                        } else {
                                          date =
                                              "${data.fromdate!} To ${data.todate!}  ";
                                        }

                                        //var day = data.dayoff ?? "";

                                        // var day =
                                        //   "${leavetype!}";

                                        var day = "";

                                        if (index.floor().isOdd) {
                                          return Card(
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 5),
                                                  decoration: BoxDecoration(
                                                    // color: const Color.fromARGB(
                                                    //     212, 222, 210, 246),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      color: const Color
                                                          .fromARGB(255, 96, 61,
                                                          157), // AppBar shade
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child: Column(children: [
                                                        IntrinsicHeight(
                                                          child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                      children: [
                                                                        Container(
                                                                            alignment: Alignment
                                                                                .topLeft,
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                11,
                                                                                5,
                                                                                10,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              textAlign: TextAlign.left,
                                                                              username!,
                                                                              style: const TextStyle(
                                                                                fontSize: 16,
                                                                                color: Color.fromARGB(255, 0, 0, 0),
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            )),
                                                                      ]),
                                                                ),
                                                                Container(
                                                                  height: 10,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          10,
                                                                          10,
                                                                          0,
                                                                          0),
                                                                ),
                                                                Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .fromLTRB(
                                                                            0,
                                                                            5,
                                                                            5,
                                                                            0),
                                                                    height: 30,
                                                                    // width: 30,
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      leavestatus ??
                                                                          "",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: (leavestatus ==
                                                                                "Pending")
                                                                            ? const Color.fromARGB(
                                                                                255,
                                                                                167,
                                                                                151,
                                                                                2)
                                                                            : (leavestatus == "Approved")
                                                                                ? const Color.fromARGB(255, 109, 209, 82)
                                                                                : const Color.fromARGB(255, 255, 0, 0),
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    )),
                                                              ]),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 5, 0, 0),
                                                          width: 340,
                                                          child: Text(
                                                            date,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      41,
                                                                      42,
                                                                      41),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ), //Textstyle
                                                          ),
                                                        ),
                                                        // Container(
                                                        //   padding:
                                                        //       const EdgeInsets
                                                        //           .fromLTRB(
                                                        //           0, 5, 0, 0),
                                                        //   width: 340,
                                                        //   child: Text(
                                                        //     day,
                                                        //     textAlign:
                                                        //         TextAlign.left,
                                                        //     style:
                                                        //         const TextStyle(
                                                        //       fontSize: 1,
                                                        //       color: Color
                                                        //           .fromARGB(
                                                        //               255,
                                                        //               41,
                                                        //               42,
                                                        //               41),
                                                        //       fontWeight:
                                                        //           FontWeight
                                                        //               .w500,
                                                        //     ), //Textstyle
                                                        //   ),
                                                        // ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 5, 0, 0),
                                                          width: 340,
                                                          child: Text(
                                                            leavereason!,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: Color
                                                                  .fromARGB(
                                                                      169,
                                                                      41,
                                                                      42,
                                                                      41),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ), //Textstyle
                                                          ),
                                                        ),
                                                        Visibility(
                                                            visible:
                                                                stationout ==
                                                                        "No"
                                                                    ? false
                                                                    : true,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      0,
                                                                      5,
                                                                      0,
                                                                      0),
                                                              width: 340,
                                                              child: Text(
                                                                reasonstationout,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          169,
                                                                          41,
                                                                          42,
                                                                          41),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ), //Textstyle
                                                              ),
                                                            )),
                                                        IntrinsicHeight(
                                                          child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                  // flex: 2,
                                                                  child: Column(
                                                                      children: [
                                                                        Container(
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                0,
                                                                                10,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                ElevatedButton(
                                                                              onPressed: () {
                                                                                if (statusType == "P") {
                                                                                  String requestid = snapshot.requireData.response!.responseData![index].requestid.toString();
                                                                                  _showAlertDialogConfirmation(requestid, "", "A");
                                                                                }
                                                                              },
                                                                              style: (leavestatus == "Approved") ? ElevatedButton.styleFrom(padding: const EdgeInsets.all(10.0), backgroundColor: const Color.fromARGB(255, 108, 217, 83), foregroundColor: const Color.fromARGB(255, 255, 255, 255)) : ElevatedButton.styleFrom(padding: const EdgeInsets.all(10.0), backgroundColor: const Color.fromARGB(255, 255, 255, 255), foregroundColor: const Color.fromARGB(255, 0, 0, 0)),
                                                                              child: const Text('    APPROVED    '),
                                                                            )),
                                                                      ]),
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                      children: [
                                                                        Container(
                                                                          padding: const EdgeInsets
                                                                              .fromLTRB(
                                                                              0,
                                                                              10,
                                                                              00,
                                                                              10),
                                                                          child:
                                                                              ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              if (statusType == "P") {
                                                                                setState(() {
                                                                                  isRemarkIndex = index;
                                                                                });
                                                                              }
                                                                            },
                                                                            style: (leavestatus == "Not Approved")
                                                                                ? ElevatedButton.styleFrom(padding: const EdgeInsets.all(10.0), backgroundColor: const Color.fromARGB(255, 255, 0, 0), foregroundColor: const Color.fromARGB(255, 255, 255, 255))
                                                                                : ElevatedButton.styleFrom(padding: const EdgeInsets.all(10.0), backgroundColor: const Color.fromARGB(255, 255, 255, 255), foregroundColor: const Color.fromARGB(255, 0, 0, 0)),
                                                                            child:
                                                                                const Text("       REJECT       "),
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                ),
                                                              ]),
                                                        ),
                                                        Visibility(
                                                            visible:
                                                                isRemarkIndex ==
                                                                        index
                                                                    ? true
                                                                    : false,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      10,
                                                                      10,
                                                                      10,
                                                                      0),
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .multiline,
                                                                maxLines: 2,
                                                                validator:
                                                                    (value) {
                                                                  if (value ==
                                                                          null ||
                                                                      value
                                                                          .isEmpty) {
                                                                    return 'Please enter reasons';
                                                                  }
                                                                  return null;
                                                                },
                                                                onChanged:
                                                                    (val) {},
                                                                controller:
                                                                    txtRemark,
                                                                decoration:
                                                                    InputDecoration(
                                                                  suffixIcon:
                                                                      Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          IconButton(
                                                                              icon: const Icon(Icons.send, color: Color.fromARGB(255, 96, 61, 157)),
                                                                              onPressed: () {
                                                                                if (txtRemark.text.trim().isNotEmpty) {
                                                                                  setState(() {
                                                                                    String requestid = snapshot.requireData.response!.responseData![index].requestid.toString();
                                                                                    _showAlertDialogConfirmation(requestid, txtRemark.text.trim(), "X");
                                                                                  });
                                                                                } else {
                                                                                  Fluttertoast.showToast(msg: "Please enter remark.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.TOP, timeInSecForIosWeb: 5, backgroundColor: Colors.white, textColor: Colors.black, fontSize: 16.0);
                                                                                }

                                                                                // String requestid = snapshot.requireData.response!.responseData![index].requestid.toString();
                                                                                // _showAlertDialogConfirmation(requestid, txtRemark.text.trim(), "X");
                                                                              }),
                                                                          IconButton(
                                                                              icon: const Icon(Icons.cancel, color: Color.fromARGB(255, 96, 61, 157)),
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  isRemarkIndex = -1;
                                                                                });
                                                                              }),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  // prefixIcon:
                                                                  //     const Padding(
                                                                  //   padding: EdgeInsets
                                                                  //       .only(
                                                                  //           top:
                                                                  //               0),
                                                                  //   child: Icon(
                                                                  //     Icons
                                                                  //         .edit,
                                                                  //     color: Color.fromARGB(
                                                                  //         255,
                                                                  //         96,
                                                                  //         61,
                                                                  //         157),
                                                                  //   ),
                                                                  // ),
                                                                  border:
                                                                      const OutlineInputBorder(),
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  labelText:
                                                                      'Reasons for reject leave* ',
                                                                  labelStyle: const TextStyle(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          96,
                                                                          61,
                                                                          157)),
                                                                  focusedBorder: const OutlineInputBorder(
                                                                      borderRadius: BorderRadius.all(
                                                                          Radius.circular(
                                                                              5.0)),
                                                                      borderSide: BorderSide(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              96,
                                                                              61,
                                                                              157))),
                                                                  filled: true,
                                                                ),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            )),
                                                        Visibility(
                                                          visible: (leavestatus ==
                                                                  "Not Approved")
                                                              ? true
                                                              : false,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    0, 0, 0, 0),
                                                            width: 340,
                                                            child: Text(
                                                              ofycrRemark ?? "",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                color: Color
                                                                    .fromARGB(
                                                                        169,
                                                                        255,
                                                                        0,
                                                                        0),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ), //Textstyle
                                                            ),
                                                          ),
                                                        ),
                                                      ]))));
                                        } else {
                                          return Card(
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 10),
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                      colors: [
                                                        Color.fromARGB(
                                                            255, 230, 224, 251),
                                                        Color(0xFFF5F7FF),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 96, 61, 157),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child: Column(children: [
                                                        IntrinsicHeight(
                                                          child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                      children: [
                                                                        Container(
                                                                            alignment: Alignment
                                                                                .topLeft,
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                11,
                                                                                5,
                                                                                10,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              textAlign: TextAlign.left,
                                                                              username!,
                                                                              style: const TextStyle(
                                                                                fontSize: 16,
                                                                                color: Color.fromARGB(255, 0, 0, 0),
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            )),
                                                                      ]),
                                                                ),
                                                                Container(
                                                                  height: 10,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          10,
                                                                          10,
                                                                          0,
                                                                          0),
                                                                ),
                                                                Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                        style: BorderStyle
                                                                            .solid,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      // color: Color.fromARGB(255, 123, 23, 69),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100.0),
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .fromLTRB(
                                                                            0,
                                                                            5,
                                                                            0,
                                                                            0),
                                                                    height: 30,
                                                                    // width: 30,
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      leavestatus ??
                                                                          "",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: (leavestatus ==
                                                                                "Pending")
                                                                            ? const Color.fromARGB(
                                                                                255,
                                                                                167,
                                                                                151,
                                                                                2)
                                                                            : (leavestatus == "Approved")
                                                                                ? const Color.fromARGB(255, 109, 209, 82)
                                                                                : const Color.fromARGB(255, 255, 0, 0),
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    )),
                                                              ]),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 5, 0, 0),
                                                          width: 340,
                                                          child: Text(
                                                            date,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      41,
                                                                      42,
                                                                      41),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ), //Textstyle
                                                          ),
                                                        ),
                                                        // Container(
                                                        //   padding:
                                                        //       const EdgeInsets
                                                        //           .fromLTRB(
                                                        //           0, 5, 0, 0),
                                                        //   width: 340,
                                                        //   child: Text(
                                                        //     day,
                                                        //     textAlign:
                                                        //         TextAlign.left,
                                                        //     style:
                                                        //         const TextStyle(
                                                        //       fontSize: 14,
                                                        //       color: Color
                                                        //           .fromARGB(
                                                        //               255,
                                                        //               41,
                                                        //               42,
                                                        //               41),
                                                        //       fontWeight:
                                                        //           FontWeight
                                                        //               .w500,
                                                        //     ), //Textstyle
                                                        //   ),
                                                        // ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 5, 0, 0),
                                                          width: 340,
                                                          child: Text(
                                                            day,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 1,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      41,
                                                                      42,
                                                                      41),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ), //Textstyle
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 5, 0, 0),
                                                          width: 340,
                                                          child: Text(
                                                            leavereason!,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: Color
                                                                  .fromARGB(
                                                                      169,
                                                                      41,
                                                                      42,
                                                                      41),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ), //Textstyle
                                                          ),
                                                        ),
                                                        Visibility(
                                                            visible:
                                                                stationout ==
                                                                        "No"
                                                                    ? false
                                                                    : true,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      0,
                                                                      5,
                                                                      0,
                                                                      0),
                                                              width: 340,
                                                              child: Text(
                                                                reasonstationout,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          169,
                                                                          41,
                                                                          42,
                                                                          41),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ), //Textstyle
                                                              ),
                                                            )),
                                                        IntrinsicHeight(
                                                          child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                  // flex: 2,
                                                                  child: Column(
                                                                      children: [
                                                                        Container(
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                0,
                                                                                10,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                ElevatedButton(
                                                                              onPressed: () {
                                                                                if (statusType == "P") {
                                                                                  String requestid = snapshot.requireData.response!.responseData![index].requestid.toString();
                                                                                  _showAlertDialogConfirmation(requestid, "", "A");
                                                                                }
                                                                              },
                                                                              style: (leavestatus == "Approved") ? ElevatedButton.styleFrom(padding: const EdgeInsets.all(10.0), backgroundColor: const Color.fromARGB(255, 108, 217, 83), foregroundColor: const Color.fromARGB(255, 255, 255, 255)) : ElevatedButton.styleFrom(padding: const EdgeInsets.all(10.0), backgroundColor: const Color.fromARGB(255, 255, 255, 255), foregroundColor: const Color.fromARGB(255, 0, 0, 0)),
                                                                              child: const Text('    APPROVED    '),
                                                                            )),
                                                                      ]),
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                      children: [
                                                                        Container(
                                                                          padding: const EdgeInsets
                                                                              .fromLTRB(
                                                                              0,
                                                                              10,
                                                                              00,
                                                                              10),
                                                                          child:
                                                                              ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              if (statusType == "P") {
                                                                                setState(() {
                                                                                  isRemarkIndex = index;
                                                                                });
                                                                              }
                                                                            },
                                                                            style: (leavestatus == "Not Approved")
                                                                                ? ElevatedButton.styleFrom(padding: const EdgeInsets.all(10.0), backgroundColor: const Color.fromARGB(255, 255, 0, 0), foregroundColor: const Color.fromARGB(255, 255, 255, 255))
                                                                                : ElevatedButton.styleFrom(padding: const EdgeInsets.all(10.0), backgroundColor: const Color.fromARGB(255, 255, 255, 255), foregroundColor: const Color.fromARGB(255, 0, 0, 0)),
                                                                            child:
                                                                                const Text("       REJECT       "),
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                ),
                                                              ]),
                                                        ),
                                                        Visibility(
                                                            visible:
                                                                isRemarkIndex ==
                                                                        index
                                                                    ? true
                                                                    : false,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      10,
                                                                      10,
                                                                      10,
                                                                      0),
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .multiline,
                                                                maxLines: 2,
                                                                validator:
                                                                    (value) {
                                                                  if (value ==
                                                                          null ||
                                                                      value
                                                                          .isEmpty) {
                                                                    return 'Please enter reasons';
                                                                  }
                                                                  return null;
                                                                },
                                                                onChanged:
                                                                    (val) {},
                                                                controller:
                                                                    txtRemark,
                                                                decoration:
                                                                    InputDecoration(
                                                                  suffixIcon:
                                                                      Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          IconButton(
                                                                              icon: const Icon(Icons.send, color: Color.fromARGB(255, 96, 61, 157)),
                                                                              onPressed: () {
                                                                                if (txtRemark.text.trim().isNotEmpty) {
                                                                                  setState(() {
                                                                                    String requestid = snapshot.requireData.response!.responseData![index].requestid.toString();
                                                                                    _showAlertDialogConfirmation(requestid, txtRemark.text.trim(), "X");
                                                                                  });
                                                                                } else {
                                                                                  Fluttertoast.showToast(msg: "Please enter remark.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.TOP, timeInSecForIosWeb: 5, backgroundColor: Colors.white, textColor: Colors.black, fontSize: 16.0);
                                                                                }
                                                                              }),
                                                                          IconButton(
                                                                              icon: const Icon(Icons.cancel, color: Color.fromARGB(255, 96, 61, 157)),
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  isRemarkIndex = -1;
                                                                                });
                                                                              }),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  // prefixIcon:
                                                                  //     const Padding(
                                                                  //   padding: EdgeInsets
                                                                  //       .only(
                                                                  //           top:
                                                                  //               0),
                                                                  //   child: Icon(
                                                                  //     Icons
                                                                  //         .edit,
                                                                  //     color: Color.fromARGB(
                                                                  //         255,
                                                                  //         96,
                                                                  //         61,
                                                                  //         157),
                                                                  //   ),
                                                                  // ),
                                                                  border:
                                                                      const OutlineInputBorder(),
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  labelText:
                                                                      'Reasons for reject leave* ',
                                                                  labelStyle: const TextStyle(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          96,
                                                                          61,
                                                                          157)),
                                                                  focusedBorder: const OutlineInputBorder(
                                                                      borderRadius: BorderRadius.all(
                                                                          Radius.circular(
                                                                              5.0)),
                                                                      borderSide: BorderSide(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              96,
                                                                              61,
                                                                              157))),
                                                                  filled: true,
                                                                ),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            )),
                                                        Visibility(
                                                            visible: (leavestatus ==
                                                                    "Not Approved")
                                                                ? true
                                                                : false,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      0,
                                                                      5,
                                                                      0,
                                                                      0),
                                                              width: 340,
                                                              child: Text(
                                                                ofycrRemark ??
                                                                    "",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          169,
                                                                          255,
                                                                          0,
                                                                          0),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ), //Textstyle
                                                              ),
                                                            )),
                                                      ]))));
                                        }
                                      });
                                } else {
                                  //EasyLoading.dismiss();
                                  return Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: const Text(
                                        'No Record Found',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(169, 255, 0, 0),
                                          fontWeight: FontWeight.w500,
                                        ), //Textstyle
                                      ));
                                  // return const Center(
                                  //     child: CircularProgressIndicator());
                                }
                              }),
                        ]),
                  ),

                  ////
                )
              ]),
            ),
            
          ]),
          
        ),

      /// 🏛️ NIC BRANDING FOOTER
      bottomNavigationBar: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF647DEE),
              Color(0xFF7F53AC),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'lib/assets/images/niclogo.png',
              height: 28,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
        );
  }

  Future<void> launchPhoneDialer(String contactNumber) async {}

  Future<void> _showAlertDialogConfirmation(
      String requestId, String remark, String status) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to confirm?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  txtRemark.text = "";
                  isRemarkIndex = -1;
                });
                submitLeavestatus(requestId, remark, status);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> submitLeavestatus(
      String requestId, String remark, String status) async {
    EasyLoading.show(status: 'loading...');
    final prefs = await SharedPreferences.getInstance();
    Map param = {
      "Requestid": requestId,
      "OfficerId": prefs.getString('userId')!,
      "Status": status,
      "Remark": remark,
    };
    print(param);
    //--- call get ward list API
    late Future<submitLeavestatus_model> _getModel;
    _getModel = submitLeavestatus_API().submitLeavestatusAPI(param);
    _getModel.then((object) {
      if (object.response!.responseCode == "1") {
        getData(statusType, userId);
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: object.response!.reponseMessage!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 5,
            backgroundColor: const Color.fromARGB(255, 172, 129, 247),
            textColor: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 16.0);
      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: "error",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 5,
            backgroundColor: const Color.fromARGB(255, 172, 129, 247),
            textColor: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 16.0);
      }
    });
  }

  Widget gradientButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: selected ? buttonGradient : null,
            color: selected ? null : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF5E35B1),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
