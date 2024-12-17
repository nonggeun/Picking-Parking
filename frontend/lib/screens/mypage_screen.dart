import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/components/setting_screen/setting_item.dart';
import 'package:frontend/screens/preparation_screen.dart';
import 'package:frontend/screens/notification_setting_screen.dart';
import 'package:frontend/screens/member_withdraw_screen.dart';
import 'package:frontend/screens/update_member_screen.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final MainController controller = Get.put(MainController());

  void logout() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'login');
    setState(() {
      controller.userEmail.value = "";
      controller.accessToken.value = "";
      controller.userId.value = 0;
      controller.userName.value = "";
      controller.userRole.value = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double inputWidth = screenWidth < 600 ? screenWidth * 0.9 : 500;

    return Scaffold(
      appBar: TopBar(
        onNotificationTap: () {},
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: inputWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => controller.userName.value != ""
                          ? const UpdateMemberScreen()
                          : const LoginScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              child: const CircleAvatar(
                                radius: 25.0,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 30,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.userName.value != ""
                                        ? controller.userName.value
                                        : "로그인",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  if (controller.userName.value != "")
                                    const Text(
                                      "정보 수정",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.grey.shade300),
                const SizedBox(height: 10),
                Column(
                  children: [
                    SettingItem(
                      title: "알림 설정",
                      screen: NotificationSettingScreen(),
                    ),
                    SettingItem(
                      title: "고객센터",
                      screen: PreparationScreen(),
                    ),
                    SettingItem(
                      title: "포인트 내역",
                    ),
                    SettingItem(
                      title: "로그아웃",
                      onTap: logout,
                      fontColor: const Color(0xffe32222),
                    ),
                    SettingItem(
                      title: "회원 탈퇴",
                      screen: MemberWithdrawScreen(),
                      fontColor: const Color(0xffe32222),
                    ),
                  ],
                ),
              ],
            ),
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
}
