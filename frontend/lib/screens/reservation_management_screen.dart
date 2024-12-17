import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/components/common/bottom_navigation_bar.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/reservation_history_screen.dart';
import 'package:frontend/screens/reservation_detail_screen.dart';
import 'package:frontend/screens/car_setting_screen.dart';
import 'package:frontend/services/api_service.dart';
import 'dart:async';

class ReservationManagementScreen extends StatefulWidget {
  const ReservationManagementScreen({Key? key}) : super(key: key);

  @override
  _ReservationManagementScreenState createState() =>
      _ReservationManagementScreenState();
}

class _ReservationManagementScreenState
    extends State<ReservationManagementScreen> {
  final MainController controller = Get.find<MainController>();
  final ApiService apiService = ApiService();
  List<dynamic> myReservations = [];
  List<dynamic> jsonNano = [];
  List<dynamic> myCar = [];
  Timer? _timer;

  String hourlyPrice = "정보 없음";
  String parkingLocation = "정보 없음";

  @override
  void initState() {
    super.initState();
    _fetchReservations();
    _fetchMyCar();
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

  Future<void> _fetchReservations() async {
    final data = await apiService.searchMyReservation();
    if (mounted && data is List) {
      setState(() {
        myReservations = data;
      });

      if (myReservations.isNotEmpty) {
        final lastReservationSeq = myReservations.last['zoneSeq'];
        if (mounted) {
          await _fetchReservationPrice(lastReservationSeq);
        }
      }
    } else if (data is Map && data.containsKey('error')) {
      if (mounted) {
        print("예약 정보 가져오기 실패: ${data['error']}");
      }
    }
  }

  Future<void> _fetchMyCar() async {
    final data = await apiService.searchMyCar();
    if (data is List) {
      if (mounted) {
        setState(() {
          myCar = data;
        });
      }
    }
  }

  Future<void> _fetchJsonNano() async {
    final data = await apiService.searchJsonNano();
    if (mounted && data is List && data.isNotEmpty) {
      setState(() {
        jsonNano = [data.last];
      });
      print("주차 구역 데이터 갱신: $jsonNano");
    }
  }

  Future<void> _fetchReservationPrice(int lastReservationSeq) async {
    final data = await apiService.searchSpecificParkingZone(lastReservationSeq);
    if (mounted && data is Map && data.isNotEmpty) {
      setState(() {
        hourlyPrice = "${data['price']} P/분";
        parkingLocation = data['location'] ?? "정보 없음";
      });
    } else if (data is Map && data.containsKey('error')) {
      print("가격 정보 가져오기 실패: ${data['error']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double iconSize = screenWidth < 400 ? 50 : 60;
    double fontSize = screenWidth < 400 ? 10 : 13;

    return Scaffold(
      appBar: TopBar(onNotificationTap: () {}),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("내 예약"),
              const SizedBox(height: 8),
              _buildReservationInfo(context),
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

  Widget _buildReservationInfo(BuildContext context) {
    String reservationTime = "예약 정보 없음";

    if (myReservations.isNotEmpty) {
      final latestReservation = myReservations.last;
      reservationTime = _formatReservationTime(
        latestReservation['startTime'],
        latestReservation['endTime'],
      );
    }

    String parkingStatus = "주차 가능";
    Color statusColor = Colors.black;

    String? myCarPlate = myCar.isNotEmpty ? myCar.first['plate'] : null;

    if (jsonNano.isNotEmpty && jsonNano[0] is Map) {
      final recentData = jsonNano[0];
      bool isMatched = recentData['isMatched'] ?? false;
      String licensePlate = recentData['licensePlate'] ?? "번호판 정보 없음";

      if (isMatched && licensePlate == myCarPlate) {
        parkingStatus = "정상 주차중";
        statusColor = Theme.of(context).primaryColor;
      } else {
        parkingStatus = "다른 차량 주차중";
        statusColor = Colors.red;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            parkingLocation,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 8),
          _buildReservationDetailRow(
            context,
            "현재 주차장 상태",
            parkingStatus,
            statusColor: statusColor,
          ),
          _buildReservationDetailRow(context, "예약 시간", reservationTime),
          _buildReservationDetailRow(context, "시간당 요금", hourlyPrice),
        ],
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

  Widget _buildReservationDetailRow(
    BuildContext context,
    String label,
    String value, {
    Color statusColor = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 10,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
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
          onTap: () => Get.to(() => const ReservationDetailScreen()),
        ),
        _buildActionIcon(
          Icons.receipt_long,
          "각종 내역",
          iconSize,
          fontSize,
          onTap: () => Get.to(() => const ReservationHistoryScreen()),
        ),
        _buildActionIcon(
          Icons.settings,
          "차량 설정",
          iconSize,
          fontSize,
          onTap: () => Get.to(() => const CarSettingScreen()),
        ),
      ],
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
}
