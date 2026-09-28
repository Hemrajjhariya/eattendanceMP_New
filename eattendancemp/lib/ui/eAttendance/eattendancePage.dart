import 'package:camera/camera.dart';
import 'package:eattendancemp/servies/getUserAttendenceAPI.dart';
import 'package:eattendancemp/ui/eAttendance/cameraPage.dart';
import 'package:eattendancemp/ui/eAttendance/sideMenu.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'globals.dart' as globals;
import 'dart:convert';
import 'package:http/http.dart' as http;

/* ================== GLOBAL STATE ================== */

bool _isLoading = true;
bool isAttendanceCompleted = false;
bool isLessThanEightHours = false;
String userName = '';
var userID = '';
List<String> birthdayEmployees = [];
String markInTimeDetails = "Time : -";
String markInLlocationDetails = "Location : -";
String markOutimeDetails = "Time : -";
String markOutLlocationDetails = "Location : -";
String workingHours = "Working Hours : -";

late Future getUserAttendenceModelResponce;

/* ================== THEME ================== */

const LinearGradient mainGradient = LinearGradient(
  colors: [
    Color(0xFF4527A0),
    Color(0xFF5E35B1),
    Color(0xFF3949AB),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

/* ================== PAGE ================== */

class eattendancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: sideMenu(),
      appBar: AppBar(
        title: const Text('e-Attendance'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: mainGradient),
        ),
      ),

      body: const _AttendanceView(),

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

/* ================== VIEW ================== */

class _AttendanceView extends StatefulWidget {
  const _AttendanceView();

  @override
  State<_AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<_AttendanceView> {
  @override
  void initState() {
    super.initState();

    // ✅ RESET OLD DATA (VERY IMPORTANT)
    _isLoading = true;
    isAttendanceCompleted = false;
    isLessThanEightHours = false;

    markInTimeDetails = "Time : -";
    markOutimeDetails = "Time : -";
    markInLlocationDetails = "Location : -";
    markOutLlocationDetails = "Location : -";
    workingHours = "Working Hours : -";

    birthdayEmployees.clear();

    reloadData();
    initLocation();
    loadBirthdayData();
  }

  Future<void> loadBirthdayData() async {
    try {
      final result = await GetBirthdayAPI().getBirthdayUsers();

      setState(() {
        birthdayEmployees = result;
      });
    } catch (e) {
      birthdayEmployees = [];
    }
  }

  Future<void> reloadData() async {
    setState(() => _isLoading = true);
    EasyLoading.show(status: 'Loading...');

    final prefs = await SharedPreferences.getInstance();
    globals.isAdmin = prefs.getString('muser') == "Y";
    userName = prefs.getString('userName') ?? "";
    userID = prefs.getString('userId') ?? "";

    getUserAttendenceModelResponce =
        getUserAttendenceAPI().getAttendenceAPI(userID);

    getUserAttendenceData();
  }

  Future<void> initLocation() async {
    await _getGeoLocationPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F6FA),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _birthdayBanner(),
          _infoTile(Icons.person, "Welcome", userName),
          _infoTile(Icons.calendar_today, "Date", getCurrentDate()),
          const SizedBox(height: 20),
          _attendanceCard(
            title: "Mark In",
            icon: Icons.login,
            time: markInTimeDetails,
            location: markInLlocationDetails,
          ),
          const SizedBox(height: 14),
          _attendanceCard(
            title: "Mark Out",
            icon: Icons.logout,
            time: markOutimeDetails,
            location: markOutLlocationDetails,
          ),
          // 👇 SPACE BETWEEN MARK OUT & WORKING HOURS
          const SizedBox(height: 20),

          if (isAttendanceCompleted) _workingHoursCard(),

          const SizedBox(height: 26),
          _actionButton(),
        ],
      ),
    );
  }

  Widget _birthdayBanner() {
    if (birthdayEmployees.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD54F), Color(0xFFFFA000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.cake, color: Colors.white, size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "🎉 Today's Birthdays",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  birthdayEmployees.join(", "),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /* ================== WIDGETS ================== */

  Widget _infoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.deepPurple.shade100,
            child: Icon(icon, color: Colors.deepPurple),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value),
            ],
          )
        ],
      ),
    );
  }

  Widget _attendanceCard({
    required String title,
    required IconData icon,
    required String time,
    required String location,
  }) {
    final bool isDone = !time.contains("-");

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDone
              ? [Color(0xFFE8F5E9), Color(0xFFC8E6C9)]
              : [Colors.white, Color(0xFFF3E5F5)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDone ? Colors.green : Colors.deepPurple.shade100,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: isDone ? Colors.green : Colors.deepPurple),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDone ? Colors.green : Colors.deepPurple,
                ),
              ),
              const Spacer(),
              if (isDone)
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
            ],
          ),
          const Divider(),
          _row(Icons.access_time, time),
          const SizedBox(height: 6),
          _row(Icons.location_on, location),
        ],
      ),
    );
  }

  Widget _workingHoursCard() {
    return Container(
      height: 58, // ✅ same height
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLessThanEightHours
              ? [Colors.red.shade400, Colors.red.shade700]
              : [Color(0xFF43CEA2), Color(0xFF185A9D)],
        ),
        borderRadius: BorderRadius.circular(22), // ✅ same curve
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          Text(
            workingHours,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _onSubmit,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          gradient: mainGradient,
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.camera_alt, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "MARK ATTENDANCE",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.deepPurple),
        const SizedBox(width: 6),
        Expanded(child: Text(text)),
      ],
    );
  }

  // Widget _actionButton() {
  //   return GestureDetector(
  //     onTap: (_isLoading || isAttendanceCompleted) ? null : _onSubmit,
  //     child: AnimatedOpacity(
  //       duration: const Duration(milliseconds: 300),
  //       opacity: isAttendanceCompleted ? 0.6 : 1,
  //       child: Container(
  //         height: 58,
  //         decoration: BoxDecoration(
  //           gradient: isAttendanceCompleted
  //               ? const LinearGradient(
  //                   colors: [Colors.grey, Colors.grey],
  //                 )
  //               : mainGradient,
  //           borderRadius: BorderRadius.circular(22),
  //           boxShadow: const [
  //             BoxShadow(color: Colors.black26, blurRadius: 10),
  //           ],
  //         ),
  //         child: Center(
  //           child: isAttendanceCompleted
  //               ? const Row(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Icon(Icons.lock, color: Colors.white),
  //                     SizedBox(width: 10),
  //                     Text(
  //                       "ATTENDANCE COMPLETED",
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.bold,
  //                         letterSpacing: 0.6,
  //                       ),
  //                     ),
  //                   ],
  //                 )
  //               : const Row(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Icon(Icons.camera_alt, color: Colors.white),
  //                     SizedBox(width: 10),
  //                     Text(
  //                       "MARK ATTENDANCE",
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  /* ================== LOGIC ================== */

  void _onSubmit() {
    availableCameras().then(
      (value) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CameraPage(cameras: value)),
      ),
    );
  }

  String getCurrentDate() {
    return DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  void getUserAttendenceData() {
    getUserAttendenceModelResponce.then((news) {
      if (news.response?.responseCode == "1") {
        final data = news.response?.data;

        markInTimeDetails = "Time : ${data?.punchInTime ?? "-"}";
        markInLlocationDetails = "Location : ${data?.inLocation ?? "-"}";

        markOutimeDetails = "Time : ${data?.punchOutTime ?? "-"}";
        markOutLlocationDetails = "Location : ${data?.outLocation ?? "-"}";

        if (data?.punchInTime != null && data?.punchOutTime != null) {
          isAttendanceCompleted = true;
          workingHours =
              calculateWorkingHours(data?.punchInTime, data?.punchOutTime);
        } else {
          isAttendanceCompleted = false;
          workingHours = "Working Hours : -";
        }
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
      if (mounted) setState(() => _isLoading = false);
    });
  }

  String calculateWorkingHours(String? inTime, String? outTime) {
    if (inTime == null || outTime == null) return "Working Hours : -";

    final format = DateFormat("HH:mm:ss");
    final inDate = format.parse(inTime);
    final outDate = format.parse(outTime);

    final diff = outDate.difference(inDate);

    return "Working Hours : ${diff.inHours}h ${diff.inMinutes % 60}m";
  }

  Future<Position> _getGeoLocationPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
    }
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}

class GetBirthdayAPI {
  Future<List<String>> getBirthdayUsers() async {
    final response = await http.post(
      Uri.parse(
        "https://mpedistrict.gov.in/eattendance/AttendenceWebAPI.asmx/GetUserData",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      /*
        Example response assume:
        {
          "d": [
            { "UserName": "Rahul" },
            { "UserName": "Anita" }
          ]
        }
      */

      final List data = decoded["d"] ?? [];

      return data.map<String>((e) => e["UserName"].toString()).toList();
    } else {
      return [];
    }
  }
}
