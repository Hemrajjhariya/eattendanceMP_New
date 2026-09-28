import 'package:eattendancemp/ui/eAttendance/eattendancePage.dart';
import 'package:eattendancemp/ui/eAttendance/login.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart'
    show
        BuildContext,
        Colors,
        MaterialApp,
        StatelessWidget,
        ThemeData,
        Widget,
        WidgetsFlutterBinding,
        runApp;
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

// /// 🎨 THEME COLORS
const Color primaryColor = Color(0xFF5E3B9C);
const Color accentColor = Color(0xFF8E6AD8);
const Color bgLight = Color(0xFFF4F1FA);

Future<void> main() async {
  // Obtain shared preferences.

  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool? login = prefs.getBool('login');

  if (login == false) {
    runApp(MyApp1());
  } else {
    runApp(MyApp());
  }
  configLoading();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: false,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: HomePage(),
      debugShowCheckedModeBanner: false,

      home: const LoginPage(),
      builder: EasyLoading.init(),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.wave
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.deepOrange
    ..backgroundColor = const Color.fromARGB(255, 96, 61, 157)
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.black26
    ..userInteractions = false
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class MyApp1 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: false,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: HomePage(),
      debugShowCheckedModeBanner: false,
      home: eattendancePage(),
      builder: EasyLoading.init(),
    );
  }
}
