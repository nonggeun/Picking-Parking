import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation_bar.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:get/get.dart';
import 'package:frontend/controller.dart';

class ReservationHistoryScreen extends StatelessWidget {
  const ReservationHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.find<MainController>();

    final List<Map<String, dynamic>> dummyData = [
      {
        "date": "2024.06.11",
        "transactions": [
          {
            "location": "서울 강남 주차장",
            "points": "-1000 P",
          },
        ]
      },
      {
        "date": "2024.06.09",
        "transactions": [
          {
            "location": "서울 종로 주차장",
            "points": "-500 P",
          },
        ]
      },
      {
        "date": "2024.01.28",
        "transactions": [
          {
            "location": "서울 서초 주차장",
            "points": "-1500 P",
          },
        ]
      }
    ];

    return Scaffold(
      appBar: TopBar(onNotificationTap: () {}),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dummyData.length,
        itemBuilder: (context, index) {
          final dateSection = dummyData[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  dateSection["date"],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...dateSection["transactions"].map<Widget>((transaction) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.local_parking,
                            color: Colors.blue,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            transaction["location"],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      // Points
                      Text(
                        transaction["points"],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigation(
        onTap: (int index) {
          controller.changePage(index);
        },
      ),
    );
  }
}
