import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation_bar.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/controller.dart';
import 'package:get/get.dart';

class PreparationScreen extends StatelessWidget {
  const PreparationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: TopBar(onNotificationTap: () {}),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
              child: Image.asset(
                "assets/images/barricade.png",
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              "현재 준비중인 페이지입니다.",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "이용에 불편을 드려 죄송합니다.",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const Text(
              "빠른 시일 내에 준비하여 찾아뵙겠습니다.",
              style: TextStyle(
                fontSize: 20,
              ),
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
}
