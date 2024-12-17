import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation_bar.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/reservation_management_screen.dart';
import 'package:frontend/screens/parking_zone_management_screen.dart';
import 'package:frontend/screens/parking_zone_submit_screen.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.find<MainController>();
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWideScreen = screenWidth > 600;

    return Scaffold(
      appBar: TopBar(onNotificationTap: () {}),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Picking Parking",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const TextSpan(
                      text: "은 다양한 주차 관련 서비스를 제공합니다.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "앱 하나로 편리하게 주차 문제를 해결해보세요.",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildManagementCard(
                      icon: Image.asset(
                        'assets/icons/reservation_management.png',
                        width: 48,
                        height: 48,
                      ),
                      label: "예약 관리",
                      description: "예약 관리에서는 내 예약 관리, 내 차량 설정 기능을 제공합니다.",
                      onTap: () {
                        Get.to(() => const ReservationManagementScreen());
                      },
                      cardWidth: isWideScreen
                          ? (screenWidth - 64) / 2
                          : screenWidth - 32,
                    ),
                    _buildManagementCard(
                      icon: Image.asset(
                        'assets/icons/parking_zone_management.png',
                        width: 48,
                        height: 48,
                      ),
                      label: "주차장 관리",
                      description: "주차장 관리에서는 신고 기능과 현재 주차장 상태를 제공합니다.",
                      onTap: () {
                        Get.to(() => const ParkingZoneManagementScreen());
                      },
                      cardWidth: isWideScreen
                          ? (screenWidth - 64) / 2
                          : screenWidth - 32,
                    ),
                    _buildManagementCard(
                      icon: Image.asset(
                        'assets/icons/parking_zone_submit.png',
                        width: 48,
                        height: 48,
                      ),
                      label: "주차장 등록",
                      description: "새로운 주차장을 등록하고 관리하세요.",
                      onTap: () {
                        Get.to(() => const ParkingZoneSubmitScreen());
                      },
                      cardWidth: isWideScreen
                          ? (screenWidth - 64) / 2
                          : screenWidth - 32,
                    ),
                  ],
                ),
              )
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

  Widget _buildManagementCard({
    required Widget icon,
    required String label,
    required String description,
    required VoidCallback onTap,
    required double cardWidth,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: 160,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
