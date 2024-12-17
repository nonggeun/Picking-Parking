import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/components/common/bottom_navigation_bar.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/parking_zone_history_screen.dart';
import 'package:frontend/components/common/custom_modal.dart';
import 'package:frontend/screens/parking_zone_setting_screen.dart';
import 'package:frontend/screens/parking_zone_detail_screen.dart';
import 'package:frontend/services/api_service.dart';
import 'dart:async';

class ParkingZoneManagementScreen extends StatefulWidget {
  const ParkingZoneManagementScreen({Key? key}) : super(key: key);

  @override
  _ParkingZoneManagementScreenState createState() =>
      _ParkingZoneManagementScreenState();
}

class _ParkingZoneManagementScreenState
    extends State<ParkingZoneManagementScreen> {
  final MainController controller = Get.find<MainController>();
  final ApiService apiService = ApiService();
  List<dynamic> myParkingZones = [];
  List<dynamic> myReservations = [];
  List<dynamic> jsonNano = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchMyParkingZones();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _fetchJsonNano();
    });
  }

  Future<void> _fetchJsonNano() async {
    final data = await apiService.searchJsonNano();
    if (mounted && data is List && data.isNotEmpty) {
      setState(() {
        jsonNano = [data.last];
      });
    }
  }

  Future<void> _fetchMyReservations(int zoneSeq) async {
    final data = await apiService.searchMyParkingZoneReservations(zoneSeq);
    if (mounted && data is List && data.isNotEmpty) {
      setState(() {
        myReservations = data;
      });
    }
  }

  Future<void> _fetchMyParkingZones() async {
    final data = await apiService.searchMyParkingZone();
    if (mounted && data is List) {
      setState(() {
        myParkingZones = data.map((zone) {
          return {
            'seq': zone['seq'],
            'location': zone['location'],
            'status': zone['status'] == "B" ? "예약 가능" : "사용 중",
            'price': "${zone['price']} P/분",
          };
        }).toList();
      });

      for (var zone in myParkingZones) {
        if (mounted) {
          await _fetchMyReservations(zone['seq']);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double iconSize = screenWidth < 400 ? 50 : 60;
    double fontSize = screenWidth < 400 ? 10 : 13;
    String reservedVehicle = "24모7216";

    return Scaffold(
      appBar: TopBar(onNotificationTap: () {}),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("내 주차장"),
              const SizedBox(height: 8),
              _buildParkingInfo(context, reservedVehicle),
              const SizedBox(height: 16),
              _buildActionButtons(context, iconSize, fontSize),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        onTap: (int index) {
          controller.changePage(index);
        },
      ),
    );
  }

  String _formatReservationTime(String startTime, String endTime) {
    final startDateTime = DateTime.parse(startTime);
    final endDateTime = DateTime.parse(endTime);

    final startFormatted =
        "${startDateTime.month}월 ${startDateTime.day}일 (${_getWeekday(startDateTime.weekday)}) ${startDateTime.hour}:${startDateTime.minute.toString().padLeft(2, '0')}";
    final endFormatted =
        "${endDateTime.month}월 ${endDateTime.day}일 (${_getWeekday(endDateTime.weekday)}) ${endDateTime.hour}:${endDateTime.minute.toString().padLeft(2, '0')}";

    return "$startFormatted ~ $endFormatted";
  }

  String _getWeekday(int weekday) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[weekday - 1];
  }

  Widget _buildParkingInfo(BuildContext context, String reservedVehicle) {
    String? currentLicensePlate;
    if (jsonNano.isNotEmpty && jsonNano[0] is Map) {
      currentLicensePlate = jsonNano[0]['licensePlate'];
    }

    return Column(
      children: List.generate(myParkingZones.length, (index) {
        var zone = myParkingZones[index];
        String reservationTime = "예약 정보 없음";
        if (myReservations.isNotEmpty) {
          final reservation = myReservations[0];
          reservationTime = _formatReservationTime(
            reservation['startTime'],
            reservation['endTime'],
          );
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(zone['location'], style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 8),
              _buildParkingDetailRow(
                context,
                "현재 주차중인 차량",
                currentLicensePlate ?? "차량 정보 없음",
                reservedVehicle: reservedVehicle,
              ),
              _buildParkingDetailRow(
                context,
                "접수된 예약",
                reservationTime,
              ),
              _buildParkingDetailRow(
                context,
                "예약 차량",
                reservedVehicle,
              ),
              _buildParkingDetailRow(
                context,
                "시간당 요금",
                zone['price'],
              ),
              _buildParkingDetailRow(
                context,
                "상태",
                zone['status'],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildParkingDetailRow(
      BuildContext context, String label, String value,
      {String? reservedVehicle}) {
    Color getStatusColor(String currentVehicle, String? reservedVehicle) {
      return (reservedVehicle != null && currentVehicle == reservedVehicle)
          ? Theme.of(context).primaryColor
          : Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 10,
                color: label == "현재 주차중인 차량"
                    ? getStatusColor(value, reservedVehicle)
                    : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildActionButtons(
    BuildContext context, double iconSize, double fontSize) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _buildActionIcon(
        Icons.access_time,
        "예약 관리",
        iconSize,
        fontSize,
        onTap: () => Get.to(() => const ParkingZoneDetailScreen()),
      ),
      _buildActionIcon(
        Icons.report,
        "간편 신고",
        iconSize,
        fontSize,
        onTap: () => _showReportModal(context),
      ),
      _buildActionIcon(
        Icons.receipt,
        "각종 내역",
        iconSize,
        fontSize,
        onTap: () => Get.to(() => ParkingZoneHistoryScreen()),
      ),
      _buildActionIcon(
        Icons.settings,
        "주차장 설정",
        iconSize,
        fontSize,
        onTap: () => Get.to(ParkingZoneSettingScreen()),
      ),
    ],
  );
}

void _showReportModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomModal(
        title: "신고 확인",
        content: "현재 주차중인 차량을 신고하시겠습니까?",
        onConfirm: () {
          Navigator.of(context).pop();
          _showCompletionModal(context);
        },
        onCancel: () => Navigator.of(context).pop(),
      );
    },
  );
}

void _showCompletionModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomModal(
        title: "신고 완료",
        content: "신고가 성공적으로 접수되었습니다.",
        onConfirm: () => Navigator.of(context).pop(),
      );
    },
  );
}

Widget _buildActionIcon(
  IconData iconData,
  String label,
  double iconSize,
  double fontSize, {
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(iconData, size: iconSize * 0.5, color: Colors.blue),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: fontSize)),
      ],
    ),
  );
}

Widget _buildSectionHeader(String title) {
  return Text(
    title,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    ),
  );
}
