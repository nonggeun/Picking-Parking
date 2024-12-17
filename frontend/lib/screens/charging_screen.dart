import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation_bar.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/components/common/custom_modal.dart';
import 'complete_screen.dart';
import 'package:frontend/controller.dart';

class ChargingScreen extends StatelessWidget {
  const ChargingScreen({Key? key}) : super(key: key);

  static const List<Map<String, String>> chargingOptions = [
    {"amount": "1,000P"},
    {"amount": "5,000P"},
    {"amount": "10,000P"},
    {"amount": "30,000P"},
    {"amount": "50,000P"},
    {"amount": "100,000P"},
  ];

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.find<MainController>();
    final String dummyPoint = "100,000P";

    return Scaffold(
      appBar: TopBar(onNotificationTap: () {}),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "내 포인트",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    dummyPoint,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C99F3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionHeaderWithIcon(
              SvgPicture.asset('assets/icons/icon_point.svg',
                  width: 24, height: 24),
              "충전하기",
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 0.7,
                ),
                itemCount: chargingOptions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _showChargingModal(context),
                    child:
                        _buildChargingCard(chargingOptions[index]["amount"]!),
                  );
                },
              ),
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

  void _showChargingModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomModal(
          title: "충전 확인",
          content: "충전하시겠습니까?",
          onConfirm: () {
            Navigator.of(context).pop();
            Get.to(
              () => CompleteScreen(),
              arguments: {'type': 'charging'},
            );
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
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

  Widget _buildChargingCard(String amount) {
    return Card(
      color: const Color(0xFFF6F6F6),
      elevation: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                "P",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
