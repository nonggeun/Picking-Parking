import 'package:flutter/material.dart';
import 'package:frontend/components/common/top_bar.dart';

class ParkingZoneSettingScreen extends StatelessWidget {
  const ParkingZoneSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(onNotificationTap: () {}),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "내 주차장 정보",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 24),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "주차장 상세",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 25),
                        child: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                            } else if (value == 'delete') {}
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('수정'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('삭제'),
                            ),
                          ],
                          icon: const Icon(Icons.more_vert),
                          offset: const Offset(0, 40),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow("주차장 이름", "서울 역삼 멀티캠퍼스 주차장"),
                  const SizedBox(height: 8),
                  _buildDetailRow("주차장 위치", "서울특별시 강남구 역삼동"),
                  const SizedBox(height: 8),
                  _buildDetailRow("시간당 요금", "900 P/분"),
                ],
              ),
            ),
          ],
        ),
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
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
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
