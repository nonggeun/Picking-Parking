import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/components/common/bottom_navigation_bar.dart';
import 'package:frontend/controller.dart';

class ReservationDetailScreen extends StatelessWidget {
  const ReservationDetailScreen({Key? key}) : super(key: key);

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
                "예약 상세 정보",
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
                    _buildDetailRow("현재 주차중인 장소", "서울 역삼 멀티캠퍼스 주차장"),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                        "예약 시간", "3월 11일 (수) 10:00 ~ 3월 13일 (목) 21:00"),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                        "접수된 예약", "3월 11일 (수) 10:00 ~ 3월 13일 (목) 10:00"),
                    const SizedBox(height: 8),
                    _buildDetailRow("시간당 요금", "900 P/분"),
                    const SizedBox(height: 8),
                    _buildDetailRow("현재 요금", "2700 P"),
                    const SizedBox(height: 8),
                    _buildDetailRow("차량 번호", "24차 1231"),
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
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
