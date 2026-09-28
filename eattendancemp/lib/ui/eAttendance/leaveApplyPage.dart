import 'package:eattendancemp/models/InsertLeaveData_model.dart';
import 'package:eattendancemp/servies/InsertLeaveData_API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:shared_preferences/shared_preferences.dart';
/* ================== APP TYPOGRAPHY ================== */

class AppText {
  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xFF4527A0),
    letterSpacing: 0.3,
  );

  static const TextStyle section = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Color(0xFF5E35B1),
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );

  static const TextStyle option = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    //color: Color(0xFF4527A0),
  );

  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: Colors.white,
  );
}

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

class leaveApplyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Leave'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: appGradient),
        ),
      ),

      body: const MyStatefulWidget(),

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
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final _formKey = GlobalKey<FormState>();
  String? selectLeaveType = null;
  int Grpleave = 1;
  int GrpDay = 0;
  var compareFromdate = "";
  var compareToate = "";
  bool _isLoading = false;
  bool isStation = false;
  bool isFromFull = false;
  bool isFromHalf = false;
  bool isToFull = false;
  bool isToHalf = false;
  bool isToTxtFiled = true;
  TextEditingController txtFromDate = TextEditingController();
  TextEditingController txtToDate = TextEditingController();
  TextEditingController txtResone = TextEditingController();
  TextEditingController txtYes = TextEditingController();

  List<DateTime?> _dialogCalendarPickerValue = [
    DateTime.now(),
    // DateTime.now().add(const Duration(days: 1)),
  ];

  List<DropdownMenuItem<String>> get dropdownItemsLeaveType {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "SL", child: Text("Sick Leave")),
      const DropdownMenuItem(value: "CL", child: Text("Casual Leave")),
    ];
    return menuItems;
  }

  int segmentedControlGroupValueFromDate = 0;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("First Half"),
    1: Text("Second Half")
  };

  int segmentedControlGroupValueToDate = 0;
  final Map<int, Widget> myTab = const <int, Widget>{
    0: Text("First Half"),
    1: Text("Second Half")
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Form(
        key: _formKey,
        child: Container(
            color: const Color.fromARGB(90, 208, 183, 250),
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  child: Stack(children: <Widget>[
                    Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 96, 61, 157),
                                style: BorderStyle.solid,
                                width: 1.5,
                              ),
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            padding: const EdgeInsets.fromLTRB(2, 10, 2, 0),
                            margin: const EdgeInsets.only(top: 10),
                            height: screenSize.height / 1.25,
                            width: screenSize.width / 1.06,
                            child: ListView(children: <Widget>[
                              Container(
                                  alignment: Alignment.topLeft,
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  child: const Text(
                                    'Apply Leave',
                                    textAlign: TextAlign.center,
                                    style: AppText.title,
                                  )),
                              Container(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 0,
                                      groupValue: GrpDay,
                                      onChanged: (int? value) {
                                        GrpDay = value!;
                                        setState(() {
                                          isFromFull = false;
                                          isFromHalf = false;
                                          isToFull = false;
                                          isToHalf = false;
                                          isToTxtFiled = true;
                                          txtFromDate.text = "";
                                          txtToDate.text = "";
                                          txtResone.text = "";
                                          GrpDay = value;
                                          switch (value) {
                                            case 0:
                                              break;
                                            case 1:
                                              break;
                                          }
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Single Day',
                                      style: AppText.section,
                                    ),
                                    Radio(
                                      value: 1,
                                      groupValue: GrpDay,
                                      onChanged: (int? value) {
                                        GrpDay = value!;
                                        setState(() {
                                          isFromFull = false;
                                          isFromHalf = false;
                                          isToFull = false;
                                          isToHalf = false;
                                          isToTxtFiled = true;
                                          txtFromDate.text = "";
                                          txtToDate.text = "";
                                          txtResone.text = "";
                                          GrpDay = value;
                                          switch (value) {
                                            case 0:
                                              break;
                                            case 1:
                                              break;
                                          }
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Multiple Day',
                                      style: AppText.section,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  alignment: Alignment.topLeft,
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Visibility(
                                            visible: true,
                                            child:
                                                _buildCalendarDialogButton()),
                                      ),
                                      // Container(
                                      //   width: 1,
                                      // ),
                                      Expanded(
                                        child: Container(
                                            alignment: Alignment.topLeft,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: isFromFull == true
                                                        ? ElevatedButton.styleFrom(
                                                            padding: const EdgeInsets.all(
                                                                0.0),
                                                            backgroundColor:
                                                                const Color.fromARGB(
                                                                    255, 96, 61, 157),
                                                            foregroundColor:
                                                                const Color.fromARGB(
                                                                    255, 255, 255, 255))
                                                        : ElevatedButton.styleFrom(
                                                            padding: const EdgeInsets.all(
                                                                0.0),
                                                            backgroundColor:
                                                                const Color.fromARGB(
                                                                    255, 255, 255, 255),
                                                            foregroundColor:
                                                                const Color.fromARGB(255, 96, 61, 157)),
                                                    onPressed: () {
                                                      setState(() {
                                                        isFromFull = true;
                                                        isFromHalf = false;
                                                      });
                                                    },
                                                    child: const Text(
                                                      'Full',
                                                      style: AppText.option,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: isFromHalf == true
                                                        ? ElevatedButton.styleFrom(
                                                            padding: const EdgeInsets.all(
                                                                10.0),
                                                            backgroundColor:
                                                                const Color.fromARGB(
                                                                    255, 96, 61, 157),
                                                            foregroundColor:
                                                                const Color.fromARGB(
                                                                    255, 255, 255, 255))
                                                        : ElevatedButton.styleFrom(
                                                            padding: const EdgeInsets.all(
                                                                10.0),
                                                            backgroundColor:
                                                                const Color.fromARGB(
                                                                    255, 255, 255, 255),
                                                            foregroundColor:
                                                                const Color.fromARGB(255, 96, 61, 157)),
                                                    onPressed: () {
                                                      setState(() {
                                                        isFromFull = false;
                                                        isFromHalf = true;
                                                        if (GrpDay == 1) {
                                                          segmentedControlGroupValueFromDate =
                                                              1;
                                                        }
                                                      });
                                                    },
                                                    child: const Text(
                                                      'Half',
                                                      style: AppText.option,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  )),
                              Visibility(
                                  visible: isFromHalf == true ? true : false,
                                  child: Container(
                                      margin: const EdgeInsets.all(10.0),
                                      padding: const EdgeInsets.all(1.0),
                                      child: CupertinoSlidingSegmentedControl(
                                          // thumbColor:
                                          //     Color.fromARGB(255, 96, 61, 157),
                                          // backgroundColor: const Color.fromARGB(
                                          //     255, 96, 61, 157),
                                          groupValue:
                                              segmentedControlGroupValueFromDate,
                                          children: myTabs,
                                          onValueChanged: (i) {
                                            setState(() {
                                              if (GrpDay == 1) {
                                                segmentedControlGroupValueFromDate =
                                                    1;
                                              } else {
                                                segmentedControlGroupValueFromDate =
                                                    i!;
                                              }
                                            });
                                          }))),
                              Visibility(
                                  visible: GrpDay == 0 ? false : true,
                                  child: Container(
                                      alignment: Alignment.topLeft,
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Visibility(
                                                visible: true,
                                                child:
                                                    _buildCalendarDialogButtonTo()),
                                          ),
                                          // Container(
                                          //   width: 1,
                                          // ),
                                          Visibility(
                                              visible: isToTxtFiled,
                                              child: Expanded(
                                                child: Container(
                                                  alignment: Alignment.topLeft,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: isToFull == true
                                                              ? ElevatedButton.styleFrom(
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                          0.0),
                                                                  backgroundColor:
                                                                      const Color.fromARGB(
                                                                          255,
                                                                          96,
                                                                          61,
                                                                          157),
                                                                  foregroundColor:
                                                                      const Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255))
                                                              : ElevatedButton.styleFrom(
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                          0.0),
                                                                  backgroundColor:
                                                                      const Color.fromARGB(255, 255, 255, 255),
                                                                  foregroundColor: const Color.fromARGB(255, 96, 61, 157)),
                                                          onPressed: () {
                                                            setState(() {
                                                              isToFull = true;
                                                              isToHalf = false;
                                                            });
                                                          },
                                                          child: const Text(
                                                              'Full'),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: isToHalf == true
                                                              ? ElevatedButton.styleFrom(
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                          0.0),
                                                                  backgroundColor:
                                                                      const Color.fromARGB(
                                                                          255,
                                                                          96,
                                                                          61,
                                                                          157),
                                                                  foregroundColor:
                                                                      const Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255))
                                                              : ElevatedButton.styleFrom(
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                          00.0),
                                                                  backgroundColor:
                                                                      const Color.fromARGB(255, 255, 255, 255),
                                                                  foregroundColor: const Color.fromARGB(255, 96, 61, 157)),
                                                          onPressed: () {
                                                            setState(() {
                                                              isToFull = false;
                                                              isToHalf = true;

                                                              if (GrpDay == 1) {
                                                                segmentedControlGroupValueToDate =
                                                                    0;
                                                              }
                                                            });
                                                          },
                                                          child: const Text(
                                                              'Half'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ))),
                              Visibility(
                                  visible: isToTxtFiled,
                                  child: Container(
                                      child: Visibility(
                                          visible:
                                              isToHalf == true ? true : false,
                                          child: Container(
                                              margin:
                                                  const EdgeInsets.all(10.0),
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: CupertinoSlidingSegmentedControl(
                                                  // thumbColor:
                                                  //     Color.fromARGB(255, 96, 61, 157),
                                                  // backgroundColor: const Color.fromARGB(
                                                  //     255, 96, 61, 157),
                                                  groupValue: segmentedControlGroupValueToDate,
                                                  children: myTab,
                                                  onValueChanged: (i) {
                                                    setState(() {
                                                      if (GrpDay == 1) {
                                                        segmentedControlGroupValueToDate =
                                                            0;
                                                      } else {
                                                        segmentedControlGroupValueToDate =
                                                            i!;
                                                      }
                                                    });
                                                  }))))),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '';
                                    }
                                    return null;
                                  },
                                  onChanged: (val) {},
                                  controller: txtResone,
                                  decoration: const InputDecoration(
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(top: 0),
                                      child: Icon(
                                        Icons.edit,
                                        color: Color.fromARGB(255, 96, 61, 157),
                                      ),
                                    ),
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.white,
                                    labelText: 'Reasons For Leave *',
                                    labelStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 96, 61, 157)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(1.0)),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                    filled: true,
                                  ),
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: DropdownButtonFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '';
                                      }
                                      return null;
                                    },
                                    style: AppText.option,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      labelStyle: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 96, 61, 157)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 96, 61, 157))),
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            width: 1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      labelText: 'Leave Type',
                                    ),
                                    dropdownColor: Colors.white,
                                    value: selectLeaveType,
                                    onChanged: (String? newValue) {
                                      selectLeaveType = newValue;
                                    },
                                    items: dropdownItemsLeaveType,
                                  )),
                              Container(
                                  height: 40,
                                  padding:
                                      const EdgeInsets.fromLTRB(14, 15, 10, 0),
                                  child: const Text(
                                    'Station Leave * ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto-Light.ttf',
                                        color:
                                            Color.fromARGB(255, 96, 61, 157)),
                                  )),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 0,
                                      groupValue: Grpleave,
                                      onChanged: (int? value) {
                                        Grpleave = value!;
                                        setState(() {
                                          Grpleave = value;
                                          isStation = true;
                                          switch (value) {
                                            case 0:
                                              break;
                                            case 1:
                                              break;
                                          }
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Yes',
                                      style: AppText.option,
                                    ),
                                    Radio(
                                      value: 1,
                                      groupValue: Grpleave,
                                      onChanged: (int? value) {
                                        Grpleave = value!;
                                        setState(() {
                                          Grpleave = value;
                                          isStation = false;
                                          switch (value) {
                                            case 0:
                                              break;
                                            case 1:
                                              break;
                                          }
                                        });
                                      },
                                    ),
                                    const Text(
                                      'No',
                                      style: AppText.option,
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                  visible: isStation,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    child: TextFormField(
                                      // keyboardType: TextInputType.multiline,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '';
                                        }
                                        return null;
                                      },
                                      onChanged: (val) {},
                                      controller: txtYes,
                                      decoration: const InputDecoration(
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.only(top: 0),
                                          child: Icon(
                                            Icons.edit,
                                            color: Color.fromARGB(
                                                255, 96, 61, 157),
                                          ),
                                        ),
                                        border: OutlineInputBorder(),
                                        fillColor: Colors.white,
                                        labelText: 'Where * ',
                                        labelStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 96, 61, 157)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(1.0)),
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 96, 61, 157))),
                                        filled: true,
                                      ),
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  )),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              ),
                              Container(
                                  height: 70,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: ElevatedButton.icon(
                                    onPressed: _isLoading ? null : _onSubmit,
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(10.0),
                                        backgroundColor: const Color.fromARGB(
                                            255, 96, 61, 157)),
                                    icon: _isLoading
                                        ? Container(
                                            width: 24,
                                            height: 24,
                                            padding: const EdgeInsets.all(2.0),
                                            child:
                                                const CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : const Icon(Icons.login),
                                    label: const Text('Apply Leave'),
                                  )),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ])))
                  ]),
                ),
              ],
            )));
  }
  /* ================== TEXT STYLES ================== */

  TextStyle headingText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xFF4527A0),
    letterSpacing: 0.4,
  );

  TextStyle labelText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Color(0xFF5E35B1),
  );

  TextStyle optionText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF4527A0),
  );

  TextStyle buttonText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: Colors.white,
  );

  Future<void> _onSubmit() async {
    // station leave
    var strTitleGrp = "";
    if (Grpleave == 0) {
      strTitleGrp = "Y";
    } else if (Grpleave == 1) {
      strTitleGrp = "N";
    }

//To day first half and second half
    // var isToDay = "";
    // if (isToFirstHalf == true) {
    //   isToDay = "FH";
    // } else if (isToSecondHalf == true) {
    //   isToDay = "SH";
    // }

    if (_formKey.currentState!.validate()) {
      if (isFromFull == false &&
          isFromHalf == false &&
          isToFull == false &&
          isFromHalf == false) {
        Fluttertoast.showToast(
            msg: "Please select full/Half day.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 5,
            backgroundColor: const Color.fromARGB(255, 172, 129, 247),
            textColor: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 16.0);
        return;
      }

      if (isFromFull == false && isFromHalf == false) {
        Fluttertoast.showToast(
            msg: "Please select from date full/Half day.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 5,
            backgroundColor: const Color.fromARGB(255, 172, 129, 247),
            textColor: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 16.0);
        return;
      }
// for muliple day validation
      if (GrpDay == 1) {
        if (isToFull == false && isToHalf == false) {
          Fluttertoast.showToast(
              msg: "Please select to date full/Half day.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 5,
              backgroundColor: const Color.fromARGB(255, 172, 129, 247),
              textColor: const Color.fromARGB(255, 255, 255, 255),
              fontSize: 16.0);
          return;
        }
      }

      // //FUll day / half day
      var fromDtDayFH = "";
      var toDtDayFH = "";
      var strLeaveDayF_FSH = "";
      var strLeaveDayT_FSH = "";
      //Single day
      if (GrpDay == 0) {
        txtToDate.text = txtFromDate.text;
        if (isFromFull == true) {
          fromDtDayFH = "F";
          toDtDayFH = "F";
        } else if (isFromHalf == true) {
          fromDtDayFH = "H";
          toDtDayFH = "H";

          if (segmentedControlGroupValueFromDate == 0) {
            strLeaveDayF_FSH = "FH";
            strLeaveDayT_FSH = "FH";
          } else {
            strLeaveDayF_FSH = "SH";
            strLeaveDayT_FSH = "SH";
          }
        }
      } else {
        //multiple day
        if (isFromFull == true) {
          fromDtDayFH = "F";
        } else {
          fromDtDayFH = "H";
          strLeaveDayF_FSH = "SH";
        }

        if (isToFull == true) {
          toDtDayFH = "F";
          //strLeaveDayTo = "F";
        } else {
          toDtDayFH = "H";
          strLeaveDayT_FSH = "FH";
        }
      }

      EasyLoading.show(status: 'loading...');

// LeaveDayF_FSH // First/Second Half from date
// Value - FH/SH

// LeaveDayT_FSH // First/Second Half Todate
// Value - FH/SH

// LeaveDayFH // HALF/Full Day
// Value - F/H

      final prefs = await SharedPreferences.getInstance();
      Map param = {
        "user_id": prefs.getString('userId')!,
        "FromDt": txtFromDate.text.toString(),
        "ToDt": txtToDate.text.toString(),
        "Leavereason": txtResone.text.trim(),
        "Stationout": strTitleGrp,
        "Reasonout": txtYes.text.trim(),
        "FromDtDayFH": fromDtDayFH.toString(),
        "ToDtDayFH": toDtDayFH.toString(),
        "LeaveDayF_FSH": strLeaveDayF_FSH.toString(),
        "LeaveDayT_FSH": strLeaveDayT_FSH.toString(),
        "Leavetype": selectLeaveType.toString()
      };
      print(param);

      //--- call get ward list API
      late Future<InsertLeaveData_model> _getModel;
      _getModel = InsertLeaveData_API().InsertLeaveDataAPI(param);
      _getModel.then((object) {
        if (object.response!.responseCode == "1") {
          EasyLoading.dismiss();
          Fluttertoast.showToast(
              msg: object.response!.reponseMessage!,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 5,
              backgroundColor: const Color.fromARGB(255, 172, 129, 247),
              textColor: const Color.fromARGB(255, 255, 255, 255),
              fontSize: 16.0);

          setState(() {
            txtFromDate.text = "";
            txtToDate.text = "";
            txtResone.text = "";
            txtYes.text = "";
            //isStation = false;
            isFromFull = false;
            isFromHalf = false;
            isToFull = false;
            isToHalf = false;
            isToTxtFiled = true;
          });
        } else {
          EasyLoading.dismiss();
          Fluttertoast.showToast(
              msg: object.response!.reponseMessage!,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 5,
              backgroundColor: const Color.fromARGB(255, 172, 129, 247),
              textColor: const Color.fromARGB(255, 255, 255, 255),
              fontSize: 16.0);
        }
      });
    }
  }

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null).toString();

    // var valueText = (values.isNotEmpty ? values[0] : null)
    //     .toString()
    //     .replaceAll('00:00:00.000', '');
    // final startDate = values[0].toString().replaceAll('00:00:00.000', '');
    // valueText = values[0]
    //     .toString(); //"${values[0]!.day}/${values[0]!.month}/${values[0]!.year}";
    print(values[0]);

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
              .map((v) => v.toString().replaceAll('00:00:00.000', ''))
              .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        //DateFormat('dd/MM/yyyy').format(pickedDate);
        //final fromDate = values[0].toString().replaceAll('00:00:00.000', '');
        valueText = "${values[0]!.day}/${values[0]!.month}/${values[0]!.year}";
        // txtFromDate.text = fromDate;
        // if (values.length > 1) {
        //   var toDate =
        //       "${values[1]!.day}/${values[1]!.month}/${values[1]!.year}";
        //   txtToDate = toDate;
        // } else {
        //   var toDate =
        //       "${values[0]!.day}/${values[0]!.month}/${values[0]!.year}";
        //   txtToDate = toDate;
        // }

        // print(txtFromDate);
        // print(txtToDate);
        // final endDate = values.length > 1
        //     ? values[1].toString().replaceAll('00:00:00.000', '')
        //     : startDate;
        // valueText = '$startDate to $endDate';
        // valueText = fromDate;
      } else {
        return 'null';
      }
    }

    return valueText;
  }

  _buildCalendarDialogButton() {
    const dayTextStyle = TextStyle(
        color: Color.fromARGB(255, 96, 61, 157), fontWeight: FontWeight.w700);
    final weekendTextStyle =
        TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400],
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      // selectableDayPredicate: (day) => !day
      //     .difference(DateTime.now().subtract(const Duration(days: 1)))
      //     .isNegative,
      calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.single,
      selectedDayHighlightColor: const Color.fromARGB(255, 96, 61, 157),
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Color.fromARGB(255, 96, 61, 157),
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Color.fromARGB(255, 96, 61, 157),
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: TextFormField(
          enableInteractiveSelection: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            return null;
          },
          onTap: () async {
            final values = await showCalendarDatePicker2Dialog(
              context: context,
              config: config,
              dialogSize: const Size(325, 400),
              borderRadius: BorderRadius.circular(15),
              value: _dialogCalendarPickerValue,
              dialogBackgroundColor: Colors.white,
            );
            if (values != null) {
              // ignore: avoid_print
              print(_getValueText(
                config.calendarType,
                values,
              ));
              setState(() {
                _dialogCalendarPickerValue = values;
              });

              compareFromdate = _getValueText(
                config.calendarType,
                values,
              );
              txtFromDate.text =
                  "${values[0]!.day}/${values[0]!.month}/${values[0]!.year}";

              if (GrpDay == 0) {
                setState(() {
                  txtToDate.text = txtFromDate.text;

                  //sameDayLeave == "Yes";
                  txtToDate.text = txtFromDate.text;
                  isToFull = isFromFull;
                  isToHalf = isFromHalf;
                  isToTxtFiled = false;
                });
              } else {
                txtToDate.text = "";
                isToTxtFiled = true;
                isToFull = false;
                isToHalf = false;
              }
              setState(() {
                isFromFull = false;
                isFromHalf = false;
              });

              //  "${txtFromdate[0]!.day}/${txtFromdate[0]!.month}/${txtFromdate[0]!.year}";

              // if (compareToate.isNotEmpty && compareFromdate.isNotEmpty) {
              //   DateTime dt1 = DateTime.parse(compareFromdate);
              //   DateTime dt2 = DateTime.parse(compareToate);

              //   if (dt1.compareTo(dt2) == 0) {
              //     print("Both date time are at same moment.");
              //     sameDayLeave = "Yes";
              //   }

              //   if (dt1.compareTo(dt2) < 0) {
              //     sameDayLeave = "No";
              //     print("DT1 is before DT2");
              //   }

              //   if (dt1.compareTo(dt2) > 0) {
              //     sameDayLeave = "No";
              //     print("DT1 is after DT2");
              //   }
              // }
            } else {
              //cancel
              txtFromDate.text = "";
            }
          },
          readOnly: true,
          controller: txtFromDate,
          decoration: const InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.only(top: 0),
              child: Icon(
                Icons.date_range,
                color: Color.fromARGB(255, 96, 61, 157),
              ),
            ),
            border: OutlineInputBorder(),
            fillColor: Colors.white,
            labelText: 'From Date *',
            labelStyle: TextStyle(color: Color.fromARGB(255, 96, 61, 157)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(1.0)),
              borderSide: BorderSide(
                width: 1,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            filled: true,
          ),
          style: const TextStyle(fontSize: 13, color: Colors.black),
        ),
      ),
    );
  }

  _buildCalendarDialogButtonTo() {
    const dayTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
        TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400],
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      // selectableDayPredicate: (day) => !day
      //     .difference(DateTime.now().subtract(const Duration(days: 1)))
      //     .isNegative,
      calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.single,
      selectedDayHighlightColor: const Color.fromARGB(255, 96, 61, 157),
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        // padding: const EdgeInsets.all(5),
                        // margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: TextFormField(
          enabled: isToTxtFiled,
          enableInteractiveSelection: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            return null;
          },
          onTap: () async {
            final values = await showCalendarDatePicker2Dialog(
              context: context,
              config: config,
              dialogSize: const Size(325, 400),
              borderRadius: BorderRadius.circular(15),
              value: _dialogCalendarPickerValue,
              dialogBackgroundColor: Colors.white,
            );
            if (values != null) {
              // ignore: avoid_print
              print(_getValueText(
                config.calendarType,
                values,
              ));
              setState(() {
                _dialogCalendarPickerValue = values;
              });
              compareToate = _getValueText(
                config.calendarType,
                values,
              );

              txtToDate.text =
                  "${values[0]!.day}/${values[0]!.month}/${values[0]!.year}";
              // to date compare if same date selected then full day n half day hide
//for set bydefault set full
              setState(() {
                isToFull = false;
                isToHalf = false;
              });

              if (compareToate.isNotEmpty && compareFromdate.isNotEmpty) {
                DateTime dt1 = DateTime.parse(compareFromdate);
                DateTime dt2 = DateTime.parse(compareToate);

                if (dt1.compareTo(dt2) == 0) {
                  print("Both date time are at same moment.");
                  // sameDayLeave = "Yes";

                  if (GrpDay == 1) {
                    txtToDate.text = "";

                    Fluttertoast.showToast(
                        msg:
                            "Oops, Please select to date greate than from date.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 5,
                        backgroundColor:
                            const Color.fromARGB(255, 172, 129, 247),
                        textColor: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16.0);
                  }
                  //  HafDayLogic();
                }

                if (dt1.compareTo(dt2) < 0) {
                  // sameDayLeave = "No";
                  print("DT1 is before DT2");
                }

                if (dt1.compareTo(dt2) > 0) {
                  // sameDayLeave = "No";
                  print("DT1 is after DT2");
                  if (GrpDay == 1) {
                    txtToDate.text = "";

                    Fluttertoast.showToast(
                        msg:
                            "Oops, Please select to date greate than from date.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 5,
                        backgroundColor:
                            const Color.fromARGB(255, 172, 129, 247),
                        textColor: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16.0);
                  }
                }
              }
            } else {
              txtToDate.text = "";
            }
          },
          readOnly: true,
          controller: txtToDate,
          decoration: const InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.only(top: 0),
              child: Icon(
                Icons.date_range,
                color: Color.fromARGB(255, 96, 61, 157),
              ),
            ),
            border: OutlineInputBorder(),
            fillColor: Colors.white,
            labelText: 'To Date *',
            labelStyle: TextStyle(color: Color.fromARGB(255, 96, 61, 157)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(1.0)),
              borderSide: BorderSide(
                width: 1,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            filled: true,
          ),
          style: const TextStyle(fontSize: 13, color: Colors.black),
        ),
      ),
    );
  }
}
