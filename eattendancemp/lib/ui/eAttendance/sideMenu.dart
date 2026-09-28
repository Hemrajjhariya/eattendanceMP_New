import 'dart:convert';
import 'package:eattendancemp/ui/eAttendance/leaveApplyPage.dart';
import 'package:eattendancemp/ui/eAttendance/leaveHistoryPage.dart';
import 'package:eattendancemp/ui/eAttendance/leaveRequestPage.dart';
import 'package:eattendancemp/ui/eAttendance/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'package:crypto/crypto.dart';
import 'globals.dart' as globals;

/* ================= THEME ================= */

const LinearGradient drawerGradient = LinearGradient(
  colors: [
    Color(0xFF4527A0),
    Color(0xFF5E35B1),
    Color(0xFF3949AB),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class sideMenu extends StatefulWidget {
  const sideMenu({super.key});

  @override
  State<sideMenu> createState() => _sideMenuState();
}

class _sideMenuState extends State<sideMenu> {
  String userName = "";

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? "";
      globals.isAdmin = prefs.getString('muser') == "Y";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF4F6FA),
      child: Column(
        children: [
          /* ================= HEADER ================= */

          Container(
            height: 220,
            decoration: const BoxDecoration(gradient: drawerGradient),
            padding: const EdgeInsets.fromLTRB(20, 45, 20, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'lib/assets/images/attndanceIconSide.png',
                    height: 34,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userName.isEmpty ? "User" : userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /* ================= MENU ================= */

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                _sectionTitle("MAIN"),
                _menuTile(
                  context,
                  icon: Icons.dashboard_outlined,
                  title: "Dashboard",
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final password = prefs.getString('password')!;
                    final userID = prefs.getString('userId')!.trim();

                    const salt = '807172';
                    final hPassword = sha256.convert(utf8.encode(password));
                    final hUser = sha256.convert(utf8.encode(userID));
                    final token =
                        sha256.convert(utf8.encode('$hPassword$salt'));

                    final timestamp = DateTime.now().millisecondsSinceEpoch;

                    final appData =
                        "https://mpedistrict.gov.in/eattendance/eattandvalidate.aspx"
                        "?appData=$token|$salt|$hUser|$timestamp";

                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => dashboard(appData),
                      ),
                    );
                  },
                ),
                if (!globals.isAdmin) ...[
                  _sectionTitle("LEAVE"),
                  _menuTile(
                    context,
                    icon: Icons.edit_calendar_outlined,
                    title: "Apply Leave",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => leaveApplyPage()),
                      );
                    },
                  ),
                  _menuTile(
                    context,
                    icon: Icons.history_outlined,
                    title: "Leave History",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const leaveHistoryPage()),
                      );
                    },
                  ),
                ],
                if (globals.isAdmin) ...[
                  _sectionTitle("ADMIN"),
                  _menuTile(
                    context,
                    icon: Icons.assignment_outlined,
                    title: "Leave Requests",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const leaveRequestPage()),
                      );
                    },
                  ),
                ],
                const Divider(),
                _menuTile(
                  context,
                  icon: Icons.logout,
                  title: "Logout",
                  color: Colors.red,
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                ),
              ],
            ),
          ),

          /* ================= FOOTER ================= */

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                Image.asset(
                  'lib/assets/images/niclogo.png',
                  height: 30,
                ),
                const SizedBox(height: 6),
                const Text(
                  "NIC • eAttendance v1.0",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /* ================= HELPERS ================= */

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          letterSpacing: 1.2,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _menuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = const Color(0xFF4527A0),
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      onTap: onTap,
    );
  }
}
