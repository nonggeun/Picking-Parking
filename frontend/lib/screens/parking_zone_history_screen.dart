import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation_bar.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:get/get.dart';
import 'package:frontend/controller.dart';

class ParkingZoneHistoryScreen extends StatefulWidget {
  const ParkingZoneHistoryScreen({Key? key}) : super(key: key);

  @override
  _ParkingZoneHistoryScreenState createState() =>
      _ParkingZoneHistoryScreenState();
}

class _ParkingZoneHistoryScreenState extends State<ParkingZoneHistoryScreen> {
  final MainController controller = Get.find<MainController>();
  bool showParkingHistory = true;

  final List<Map<String, dynamic>> parkingHistoryData = [
    {
      "date": "2024.07.15",
      "transactions": [
        {
          "location": "서울 홍대 주차장",
          "points": "+2000 P",
        },
      ]
    },
    {
      "date": "2024.07.10",
      "transactions": [
        {
          "location": "서울 신촌 주차장",
          "points": "+1500 P",
        },
      ]
    },
    {
      "date": "2024.06.28",
      "transactions": [
        {
          "location": "서울 용산 주차장",
          "points": "+3000 P",
        },
      ]
    }
  ];

  final List<Map<String, dynamic>> reportHistoryData = [
    {
      "date": "2024.07.20",
      "reports": [
        {
          "carNumber": "서울 12가 1234",
          "location": "서울 강남 주차장",
        },
      ]
    },
    {
      "date": "2024.07.18",
      "reports": [
        {
          "carNumber": "서울 34나 5678",
          "location": "서울 종로 주차장",
        },
      ]
    },
    {
      "date": "2024.07.16",
      "reports": [
        {
          "carNumber": "서울 56다 9101",
          "location": "서울 신촌 주차장",
        },
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(onNotificationTap: () {}),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtons(
                  isSelected: [showParkingHistory, !showParkingHistory],
                  onPressed: (index) {
                    setState(() {
                      showParkingHistory = index == 0;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text("주차 이력"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text("신고 이력"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: showParkingHistory
                  ? parkingHistoryData.length
                  : reportHistoryData.length,
              itemBuilder: (context, index) {
                final dateSection = showParkingHistory
                    ? parkingHistoryData[index]
                    : reportHistoryData[index];
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
                    if (showParkingHistory)
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
                                    color: Theme.of(context).primaryColor,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    transaction["location"],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                transaction["points"],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList()
                    else
                      ...dateSection["reports"].map<Widget>((report) {
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
                                    Icons.report,
                                    color: Theme.of(context).primaryColor,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        report["carNumber"],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        report["location"],
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        onTap: (int index) {
          controller.changePage(index);
        },
      ),
    );
  }
}
