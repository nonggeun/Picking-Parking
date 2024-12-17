import 'package:flutter/material.dart';
import 'package:frontend/components/common/top_bar.dart';

class CarSettingScreen extends StatelessWidget {
  const CarSettingScreen({Key? key}) : super(key: key);

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
                  "내 차량 정보",
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
                        "차량 상세",
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
                  _buildDetailRow("차량 번호", "12가 1234"),
                  const SizedBox(height: 8),
                  _buildDetailRow("차종", "현대 아반떼"),
                  const SizedBox(height: 8),
                  _buildDetailRow("차량 색상", "흰색"),
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
                fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
