# Copilot Instructions for eAttendance App

## Project Overview
**eAttendancemp** is a Flutter mobile application for employee attendance tracking with geolocation and photo verification. The app integrates with government HR systems (MP e-District) for real-time attendance management.

## Architecture Overview

### Core Data Flow
1. **Authentication Layer** (`loginAPI.dart` → `loginModel.dart`): Device-specific login that captures device token
2. **Attendance Recording** (`cameraPage.dart` + `geolocator` → `saveUserAttendenceAPI.dart`): Captures selfie + GPS coordinates
3. **Dashboard** (`eattendancePage.dart`): Displays mark-in/mark-out records with working hours calculation
4. **Leave Management** (`leaveApplyPage.dart` → various leave APIs): Separate flow for leave requests

### Directory Structure
- **`lib/models/`**: Data models with `.fromJson()` constructors for API responses
- **`lib/servies/`** (sic): API service classes - **naming convention uses "servies"** not "services"
- **`lib/ui/eAttendance/`**: All UI screens; state management via `globals.dart`
- **`lib/constant/strings.dart`**: Centralized API endpoint URLs (government ASPX web service)

## Critical Patterns & Conventions

### API Service Pattern
Services are simple classes wrapping HTTP calls, returning model instances. Example:
```dart
// lib/servies/loginAPI.dart
class loginAPI {
  Future<loginModel> getLoginAPI(String user, String password) async {
    var url = Uri.parse(Strings.loginString + user + passwords + devicetoken);
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      login = loginModel.fromJson(json.decode(response.body));
    }
    return login;
  }
}
```
**Important**: APIs use `get()` for queries but expect form-encoded POST bodies in some endpoints.

### Data Model Pattern
All models follow this structure: nested `Response` class inside main model. Example:
```dart
// lib/models/loginModel.dart
class loginModel {
  Response? response;
  
  loginModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null 
        ? Response.fromJson(json['response']) 
        : null;
  }
}

class Response {
  String? responseCode;
  String? reponseMessage; // Note: typo "reponse" is in API responses
  String? userId;
  // ... other fields
}
```

### Geolocation & Permission Flow
- `geolocator` package for GPS coordinates (latitude, longitude)
- `geocoding` package for reverse-geocoding address
- Permissions required: `ACCESS_FINE_LOCATION` (Android), `NSLocationWhenInUseUsageDescription` (iOS)
- **Critical**: `_getGeoLocationPosition()` called in `eattendancePage.initState()`

### Camera Workflow
1. **Capture**: `cameraPage.dart` uses `camera` package for selfie
2. **Compression**: `flutter_image_compress` reduces image size before upload
3. **Preview**: `previewPage.dart` **mirrors front-camera image** using `Transform(transform: Matrix4.rotationY(pi))`
4. **Upload**: Base64 encoded image sent in POST body to `saveUserAttendenceAPI`

### Authentication State
- `SharedPreferences` persists session state with keys: `login`, `userName`, `userId`, `muser` (admin flag)
- `main.dart` routes to `LoginPage` or `eattendancePage` based on `prefs.getBool('login')`
- **Platform-specific device token** appended to login: `devicetoken=Android{user}` or `devicetoken=iPhone{user}`

### UI Theme & Colors
```dart
const Color primaryColor = Color(0xFF5E3B9C);      // Purple
const Color accentColor = Color(0xFF8E6AD8);      // Light purple
const Color bgLight = Color(0xFFF4F1FA);          // Off-white

// Standard gradient for headers/backgrounds
const LinearGradient mainGradient = LinearGradient(
  colors: [Color(0xFF4527A0), Color(0xFF5E35B1), Color(0xFF3949AB)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
```

### Global State Management
`globals.dart` stores simple app state (no BLoC/Provider):
```dart
var mobileNumber = "";
bool isAdmin = false;
```
Accessed via `globals.isAdmin` after `SharedPreferences` lookup in `eattendancePage.reloadData()`.

## Key Dependencies
- `http: ^0.13.5` - Network requests
- `shared_preferences: ^2.0.15` - Session persistence
- `camera: ^0.10.2` - Photo capture
- `geolocator: ^9.0.2` - GPS tracking
- `geocoding: ^2.1.0` - Address lookup
- `intl: ^0.18.1` - Date/time formatting
- `fluttertoast: ^8.0.9` - User notifications
- `webview_flutter: ^4.10.0` - Embedded dashboard URL
- `flutter_easyloading` - Loading overlays

## Common Workflows

### Adding a New Attendance API Endpoint
1. Create model in `lib/models/{endpoint}_model.dart` with nested `Response` class
2. Create API service in `lib/servies/{endpoint}_API.dart` extending `loginAPI` pattern
3. Add URL constant to `lib/constant/strings.dart`
4. Call service in UI, handle response via `.then()` (no async/await patterns observed)

### Modifying Login Flow
Edit `lib/ui/eAttendance/login.dart` - form validation + `loginAPI().getLoginAPI()` call saves session to `SharedPreferences` with keys: `login=true`, `userName`, `userId`, `muser`.

### Camera/Geolocation Enhancements
- Camera: `cameraPage.dart` handles initialization; mirror check in `previewPage.dart` for front-camera
- Location: Ensure `_getGeoLocationPosition()` in `eattendancePage.dart` completes before attendance submission

## Important Notes
- **Typo in API fields**: Response class uses `reponseMessage` (not `responseMessage`) - matches actual API contracts
- **Package naming**: `servies` folder is intentional (not `services`)
- **No async state**: UI relies on `.then()` callbacks and `late Future` variables; not fully async/await
- **WebView dashboard**: `dashboard.dart` loads external government ASPX page with unrestricted JavaScript
- **API endpoint format**: Mix of GET with query params and POST with form-encoded bodies; check `Strings.dart` for each endpoint type

## Testing & Build Commands
```bash
# Standard Flutter commands
flutter pub get
flutter run
flutter build apk      # Android
flutter build ios      # iOS
flutter analyze        # Lint
```

Ensure device/emulator has location permissions granted before testing attendance features.
