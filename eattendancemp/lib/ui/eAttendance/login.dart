import 'dart:io';
import 'package:eattendancemp/models/getUserAttendenceModel.dart';
import 'package:eattendancemp/models/loginModel.dart';
import 'package:eattendancemp/models/saveUserAttendenceModel.dart';
import 'package:eattendancemp/servies/loginAPI.dart';
import 'package:eattendancemp/ui/eAttendance/eattendancePage.dart';
import 'package:eattendancemp/ui/eAttendance/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Future<loginModel> loginModelResponce;
late Future<saveUserAttendenceModel> saveUserAttendenceResponce;
late Future<getUserAttendenceModel> getUserAttendenceModelResponce;
bool _obscurePassword = true;
bool _isLoading = false;
String userName = '';
var userID = '';
var userImage = '';
var PunchDate = '';
var punchTime = '';
var punchType = 'NO';
var longitude = '';
var latitude = '';
var location = '';

/* ================= GRADIENTS ================= */

const LinearGradient mainGradient = LinearGradient(
  colors: [
    Color(0xFF4527A0),
    Color(0xFF5E35B1),
    Color(0xFF3949AB),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient cardGradient = LinearGradient(
  colors: [
    Colors.white,
    Color(0xFFF3E5F5),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

/* ================= LOGIN PAGE ================= */

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: mainGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: cardGradient,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /* ===== ICON ===== */
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB74D),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.fingerprint,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'VIRTUAL ATTENDANCE',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4527A0),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Attendance Management System',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 30),

                      /* ===== USERNAME ===== */
                      TextFormField(
                        controller: usernameCtrl,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Enter username' : null,
                        decoration: _inputDecoration(
                          'Username',
                          Icons.person_outline,
                        ),
                      ),
                      const SizedBox(height: 16),

                      /* ===== PASSWORD ===== */
                      TextFormField(
                        controller: passwordCtrl,
                        obscureText: _obscurePassword,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Enter password' : null,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      /* ===== LOGIN BUTTON ===== */
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _onLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4527A0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 6,
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 22),

                      /* ===== FOOTER ===== */
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Powered by ',
                            style: TextStyle(color: Colors.black54),
                          ),
                          Text(
                            'NIC',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3949AB),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /* ================= INPUT DECORATION ================= */

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  /* ================= LOGIN LOGIC (DEMO) ================= */

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty) {
        setState(() => _isLoading = true);

        login(
          usernameCtrl.text.trim(),
          passwordCtrl.text.trim(),
        );
      }
    } on SocketException {
      Fluttertoast.showToast(msg: "No Internet Connection");
    }
  }

  void login(String user, String password) {
    loginModelResponce = loginAPI().getLoginAPI(user, password);
    loginModelResponce.then((news) async {
      //print(news.response);
      if (news.response?.responseCode == "1") {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('login', false);
        await prefs.setString("userName", news.response!.userName!);
        await prefs.setString("userId", news.response!.userId!);
        await prefs.setString("muser", news.response!.muser!);
        await prefs.setString("password", password);
        userName = news.response!.userName!;
        userID = news.response!.userId!;
        /* ================= LOGIN LOGIC (DEMO) ================= */

        var muser = prefs.getString('muser')!;
        if (muser == "Y") {
          globals.isAdmin = true;
        } else {
          globals.isAdmin = false;
        }
        //getUserAttendenceModelResponce =
        //   getUserAttendenceAPI().getAttendenceAPI(userID);
        // ignore: use_build_context_synchronously

        await Future.delayed(const Duration(seconds: 2));

        setState(() => _isLoading = false);
        Fluttertoast.showToast(msg: "Login Successful");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => eattendancePage()),
        );
      } else {
        Fluttertoast.showToast(
            msg: "Invalid UserId/Password.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 5,
            backgroundColor: const Color.fromARGB(255, 172, 129, 247),
            textColor: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 16.0);
        Future.delayed(
          const Duration(seconds: 2),
          () => setState(() => _isLoading = false),
        );
      }
    });
  }
}
