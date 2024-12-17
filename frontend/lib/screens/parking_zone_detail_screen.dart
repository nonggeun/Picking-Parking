import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/components/common/bottom_navigation_bar.dart';
import 'package:frontend/controller.dart';

class ParkingZoneDetailScreen extends StatelessWidget {
  const ParkingZoneDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.find<MainController>();

    return Scaffold(
      appBar: TopBar(onNotificationTap: () {}),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "주차장 상세 정보",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("주차장 이름", "서울 역삼 멀티캠퍼스 주차장"),
                    const SizedBox(height: 8),
                    _buildDetailRow("주차장 위치", "서울특별시 강남구 역삼동"),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                        "예약 시간", "3월 11일 (수) 10:00 ~ 3월 13일 (목) 21:00"),
                    const SizedBox(height: 8),
                    _buildDetailRow("예약 차량", "12가 1234"),
                    const SizedBox(height: 8),
                    _buildDetailRow("시간당 요금", "900 P/분"),
                    const SizedBox(height: 8),
                    _buildDetailRow("현재 요금", "4500 P"),
                  ],
                ),
              ),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
