import 'package:eattendancemp/models/deleteLeave_model.dart';
import 'package:eattendancemp/models/getLeaveData_model.dart';
import 'package:eattendancemp/servies/deleteLeave_API.dart';
import 'package:eattendancemp/servies/getLeaveData_API.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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

/* ================== PAGE ================== */

class leaveHistoryPage extends StatelessWidget {
  const leaveHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LeaveHistoryView();
  }
}

class LeaveHistoryView extends StatefulWidget {
  const LeaveHistoryView({Key? key}) : super(key: key);

  @override
  State<LeaveHistoryView> createState() => _LeaveHistoryViewState();
}

class _LeaveHistoryViewState extends State<LeaveHistoryView> {
  Future<getLeaveData_model>? _getModel;
  String userName = "";

  bool isAll = false;
  bool isApprove = false;
  bool isPending = true;

  @override
  void initState() {
    super.initState();
    getData("P");
  }

  /* ================== DATA ================== */

  Future<void> getData(String status) async {
    EasyLoading.show(status: 'Loading...');
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = "Welcome : ${prefs.getString('userName') ?? ""}";
    });

    Map param = {
      "user_id": prefs.getString('userId')!,
      "Status": status,
    };

    _getModel = getLeaveData_API().getLeaveDataAPI(param);
    _getModel!.then((object) {
      EasyLoading.dismiss();
      if (object.response?.responseCode != "1") {
        Fluttertoast.showToast(msg: "Error loading data");
      }
    });
  }

  /* ================== DATE CHECK ================== */

  bool canDeleteLeave(String? fromDate) {
    if (fromDate == null || fromDate.isEmpty) return false;

    try {
      // API format assumed: dd/MM/yyyy
      final formatter = DateFormat("dd/MM/yyyy");
      final leaveFrom = formatter.parse(fromDate);

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      return leaveFrom.isAtSameMomentAs(today) || leaveFrom.isAfter(today);
    } catch (e) {
      return false;
    }
  }

  /* ================== UI ================== */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("Leave History"),
        centerTitle: true,
        flexibleSpace:
            Container(decoration: const BoxDecoration(gradient: appGradient)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            /// USER NAME
            Text(
              userName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5E35B1),
              ),
            ),

            const SizedBox(height: 16),

            /// FILTER BUTTONS
            Row(
              children: [
                _filterBtn("All", isAll, () {
                  getData("");
                  setState(() {
                    isAll = true;
                    isApprove = false;
                    isPending = false;
                  });
                }),
                _filterBtn("Approved", isApprove, () {
                  getData("A");
                  setState(() {
                    isAll = false;
                    isApprove = true;
                    isPending = false;
                  });
                }),
                _filterBtn("Pending", isPending, () {
                  getData("P");
                  setState(() {
                    isAll = false;
                    isApprove = false;
                    isPending = true;
                  });
                }),
              ],
            ),

            const SizedBox(height: 16),

            /// LIST
            Expanded(
              child: FutureBuilder<getLeaveData_model>(
                future: _getModel,
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data!.response!.responseData!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Record Found",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w500),
                      ),
                    );
                  }

                  final list = snapshot.data!.response!.responseData!;

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final data = list[index];
                      final String status = data.leavestatus ?? "";

                      final bool canDelete =
                          status == "Pending" && canDeleteLeave(data.fromdate);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient:
                              index.isEven ? evenRowGradient : oddRowGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// DATE + STATUS
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${data.fromdate} → ${data.todate}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    _statusChip(status),
                                    if (canDelete)
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => _confirmDelete(
                                            context, data.requestid as String?),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data.leavereason ?? "",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
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

  /* ================== UI HELPERS ================== */

  Widget _filterBtn(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              gradient: active ? buttonGradient : null,
              color: active ? null : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFF5E35B1)),
              boxShadow: active
                  ? const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                      )
                    ]
                  : [],
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: active ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color;
    switch (status) {
      case "Pending":
        color = Colors.orange;
        break;
      case "Approved":
        color = Colors.green;
        break;
      default:
        color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  /* ================== DELETE ================== */

  void _confirmDelete(BuildContext context, String? requestId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this request?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteLeaveRequest(requestId);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void deleteLeaveRequest(String? requestId) {
    EasyLoading.show(status: 'Loading...');
    deleteLeave_API().deleteLeaveAPI({"Requestid": requestId}).then((object) {
      EasyLoading.dismiss();
      if (object.response?.responseCode == "1") {
        getData(isAll
            ? ""
            : isApprove
                ? "A"
                : "P");
        Fluttertoast.showToast(msg: object.response!.reponseMessage!);
      } else {
        Fluttertoast.showToast(msg: "Error");
      }
    });
  }
}
