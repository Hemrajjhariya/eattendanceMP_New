import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:eattendancemp/constant/strings.dart';
import 'package:eattendancemp/models/saveUserAttendenceModel.dart';
import 'package:eattendancemp/ui/eAttendance/eattendancePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

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

const LinearGradient cardGradient = LinearGradient(
  colors: [
    Color(0xFFFFFFFF),
    Color(0xFFF3E5F5),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

bool _isLoadingCamera = false;

// ignore: must_be_immutable
class PreviewPage extends StatelessWidget {
  late Map saveData;
  PreviewPage({
    Key? key,
    required this.picture,
    required this.saveData,
  }) : super(key: key);

  final XFile picture;

  /// 🔁 Assume front camera (selfie)
  /// If you later add camera switch, make this dynamic
  final bool isFrontCamera = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('e-Attendance'),
        centerTitle: true,
        flexibleSpace:
            Container(decoration: const BoxDecoration(gradient: mainGradient)),
      ),
      body: Stack(
        children: [
          /// IMAGE PREVIEW (MIRRORED FOR FRONT CAMERA)
          Positioned.fill(
            child: isFrontCamera
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: Image.file(
                      File(picture.path),
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.file(
                    File(picture.path),
                    fit: BoxFit.cover,
                  ),
          ),

          /// DARK OVERLAY
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),

          /// LOCATION
          Positioned(
            top: 30,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                saveData['Location'],
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          /// TIME
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  DateFormat.jm().format(DateTime.now()),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          /// FLOATING DONE BUTTON (NO WHITE BG)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (_isLoadingCamera) return;

                  _isLoadingCamera = true;
                  EasyLoading.show(status: 'Saving...');
                  saveUserAttendenceAPI(
                    param: saveData,
                    context: context,
                  );
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 96, 61, 157),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _isLoadingCamera
                      ? const Padding(
                          padding: EdgeInsets.all(18),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 32,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= API =================
  void saveUserAttendenceAPI({
    required Map param,
    required BuildContext context,
  }) async {
    try {
      var url = Uri.parse(Strings.saveUserAttendence);

      http
          .post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: param,
      )
          .then((http.Response response) {
        EasyLoading.dismiss();
        _isLoadingCamera = false;

        if (response.statusCode == 200) {
          Map<String, dynamic> user = jsonDecode(response.body);

          String message = user['response']['reponse_message'];
          String code = user['response']['response_code'];

          Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: const Color.fromARGB(255, 172, 129, 247),
            textColor: Colors.white,
            fontSize: 16,
          );

          if (code == "1") {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => eattendancePage(),
              ),
            );
          }
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      _isLoadingCamera = false;
    }
  }
}
