import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:eattendancemp/ui/eAttendance/previewPage.dart';
import 'package:flutter/material.dart';
import 'package:eattendancemp/models/saveUserAttendenceModel.dart';
import 'package:eattendancemp/models/getUserAttendenceModel.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

var userID = '';
var userImage = '';
var PunchDate = '';
var punchTime = '';
var punchType = 'NO';
var longitude = '';
var latitude = '';
var location = '';
late Map saveData;
dynamic time = "";
bool _isLoadingCamera = false;
bool _isLoading = false;
bool _isRefresh = false;
String userName = '';
TextEditingController nameController = TextEditingController();

late Future<saveUserAttendenceModel> saveUserAttendenceResponce;
late Future<getUserAttendenceModel> getUserAttendenceModelResponce;

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

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription>? cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    initValue();
    initCamera(widget.cameras![1]);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _cameraController.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      debugPrint("Camera error: $e");
    }
  }

  Future takePicture() async {
    setState(() => _isLoadingCamera = true);

    if (!_cameraController.value.isInitialized ||
        _cameraController.value.isTakingPicture) return;

    try {
      XFile picture = await _cameraController.takePicture();
      Uint8List originalBytes = await picture.readAsBytes();

      Uint8List compressedBytes = await FlutterImageCompress.compressWithList(
        originalBytes,
        quality: 70,
        minWidth: 400,
        minHeight: 400,
        format: CompressFormat.jpeg,
      );

      userImage = base64Encode(compressedBytes);

      postData(picture);
    } catch (e) {
      debugPrint("Picture error: $e");
    }
  }

  Future<void> postData(XFile picture) async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName')!;
    userID = prefs.getString('userId')!;

    saveData = {
      "UserId": userID,
      "PunchDate": PunchDate,
      "punchTime": punchTime,
      "PunchType": punchType,
      "Lattitude": latitude,
      "Longitude": longitude,
      "UserImage": userImage,
      "Location": location
    };

    setState(() => _isLoadingCamera = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PreviewPage(
          picture: picture,
          saveData: saveData,
        ),
      ),
    );
  }

  Future<void> initValue() async {
    time = DateFormat.jm().format(DateTime.now());
    setState(() => _isLoading = true);

    Position position = await _getGeoLocationPosition();
    latitude = '${position.latitude}';
    longitude = '${position.longitude}';
    await GetAddressFromLatLong(position);

    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName')!;
    userID = prefs.getString('userId')!;

    setState(() {
      _isRefresh = true;
      _isLoading = false;
    });
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    location =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';

    nameController.text = location;
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permission denied forever');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

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
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: _cameraController.value.isInitialized
                  ? CameraPreview(_cameraController)
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
            ),

            /// LOCATION
            Positioned(
              top: 20,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  nameController.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),

            /// TIME
            Positioned(
              bottom: 150,
              left: 0,
              right: 0,
              child: Text(
                time,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),

            /// CAPTURE BUTTON
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Visibility(
                  visible: _isRefresh,
                  child: GestureDetector(
                    onTap: _isLoadingCamera ? null : takePicture,
                    child: Container(
                      height: 72,
                      width: 72,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 96, 61, 157),
                      ),
                      child: _isLoadingCamera
                          ? const Padding(
                              padding: EdgeInsets.all(18),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Icon(Icons.camera_alt,
                              color: Colors.white, size: 32),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
