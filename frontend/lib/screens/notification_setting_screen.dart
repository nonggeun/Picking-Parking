import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation_bar.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/components/common/switch_button.dart';
import 'package:get/get.dart';
import 'package:frontend/controller.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool reportAlert = false;
  bool resultAlert = true;
  bool safetyNewsAlert = true;
  bool transmissionAlert = true;

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: TopBar(onNotificationTap: () {}),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              '알림 설정',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            _buildNotificationSwitch(
              context,
              title: "신고 결과 알림",
              value: reportAlert,
              onChanged: (bool value) {
                setState(() {
                  reportAlert = value;
                });
              },
            ),
            const SizedBox(height: 20),
            _buildNotificationSwitch(
              context,
              title: "신고 경과 알림",
              value: resultAlert,
              onChanged: (bool value) {
                setState(() {
                  resultAlert = value;
                });
              },
            ),
            const SizedBox(height: 20),
            _buildNotificationSwitch(
              context,
              title: "안전 뉴스 알림",
              value: safetyNewsAlert,
              onChanged: (bool value) {
                setState(() {
                  safetyNewsAlert = value;
                });
              },
            ),
            const SizedBox(height: 20),
            _buildNotificationSwitch(
              context,
              title: "전송 결과 알림",
              value: transmissionAlert,
              onChanged: (bool value) {
                setState(() {
                  transmissionAlert = value;
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        onTap: (int index) async {
          controller.changePage(index);
        },
      ),
    );
  }

  Widget _buildNotificationSwitch(BuildContext context,
      {required String title,
      required bool value,
      required Function(bool) onChanged}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        const SwitchButton(),
      ],
    );
  }
}
