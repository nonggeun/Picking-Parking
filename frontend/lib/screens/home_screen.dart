import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/components/common/button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/screens/charging_screen.dart';
import 'package:frontend/screens/car_setting_screen.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MainController controller = Get.find<MainController>();
  final ApiService apiService = ApiService();
  List<dynamic> myParkingZones = [];
  List<dynamic> myReservations = [];
  List<dynamic> myCar = [];

  @override
  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();
    _fetchMyParkingZones();
    _fetchReservations();
    _fetchMyCar();
  }

  /// 사용자 로그인 여부 확인
  void _checkUserLoggedIn() {
    if (controller.userName.value.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => const LoginScreen());
      });
    }
  }

  Future<void> _fetchReservations() async {
    final data = await apiService.searchMyReservation();
    if (mounted && data is List) {
      setState(() {
        myReservations = data;
      });
    } else if (data is Map && data.containsKey('error')) {
    } else {}
  }

  Future<void> _fetchMyParkingZones() async {
    final data = await apiService.searchMyParkingZone();
    if (data is List) {
      if (mounted) {
        setState(() {
          myParkingZones = data;
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(onNotificationTap: () {}),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPointContainer(context),
            const SizedBox(height: 20),
            _buildSectionHeaderWithIcon(
              SvgPicture.asset('assets/icons/icon_management.svg',
                  width: 24, height: 24),
              "내 주차장",
            ),
            const SizedBox(height: 4),
            _buildMyParkingZones(),
            const SizedBox(height: 20),
            _buildSectionHeaderWithIcon(
              SvgPicture.asset('assets/icons/icon_reservation.svg',
                  width: 24, height: 24),
              "내 예약",
            ),
            const SizedBox(height: 4),
            _buildMyReservations(),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: [
                _buildVehicleCard(width: _getCardWidth(context)),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        onTap: (int index) {
          controller.changePage(index);
        },
      ),
    );
  }

  double _getCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 800) {
      return screenWidth / 3 - 32;
    } else if (screenWidth > 600) {
      return screenWidth / 2 - 32;
    } else {
      return screenWidth - 32;
    }
  }

  Widget _buildSectionHeaderWithIcon(Widget icon, String title) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPointContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "내 포인트",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              const Text(
                "100000 P",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C99F3)),
              ),
              Button(
                text: "충전",
                onPressed: () {
                  Get.to(() => ChargingScreen());
                },
                backgroundColor: Theme.of(context).primaryColor,
                contentColor: Colors.white,
                fontSize: 10,
              ),
            ],
          ),
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

  Widget _buildMyParkingZones() {
    return Column(
      children: myParkingZones.map((zone) {
        return _buildParkingCard(
          location: zone['location'],
          status: zone['status'] == "B" ? "예약 가능" : "사용 중",
          carNumber: "30하 1234",
        );
      }).toList(),
    );
  }

  Widget _buildMyReservations() {
    if (myReservations.isEmpty) return const Text("예약 정보 없음");

    final latestReservation = myReservations.last;
    String formattedTime = _formatReservationTime(
      latestReservation['startTime'],
      latestReservation['endTime'],
    );

    String status =
        latestReservation['status'] == "RESERVATION" ? "예약 중" : "사용 중";

    return _buildReservationCard(
      status: status,
      location: "서울 역삼 멀티캠퍼스 주차장", // 더미 데이터 사용
      time: formattedTime,
    );
  }

  Widget _buildParkingCard({
    required String location,
    required String status,
    required String carNumber,
  }) {
    return Card(
      elevation: 2,
      color: const Color(0xFFF6F6F6),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(status,
                        style: const TextStyle(color: Color(0xFF4C99F3))),
                    Text(carNumber,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationCard({
    required String status,
    required String location,
    required String time,
  }) {
    return Card(
      elevation: 2,
      color: const Color(0xFFF6F6F6),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(status,
                        style: const TextStyle(color: Color(0xFF4C99F3))),
                    const SizedBox(height: 4),
                    Text(time,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard({required double width}) {
    // 차량 번호가 있는지 확인하고 가져오기
    String carPlate = myCar.isNotEmpty ? myCar[0]['plate'] : "등록된 차량 없음";

    return Container(
      width: width,
      child: Card(
        elevation: 2,
        color: const Color(0xFFF6F6F6),
        child: ListTile(
          title: const Text("내 차량"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                carPlate,
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
          onTap: () {
            Get.to(() => const CarSettingScreen());
          },
        ),
      ),
    );
  }
}
