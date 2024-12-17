import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation_bar.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:get/get.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/components/common/button.dart';
import 'package:frontend/services/api_service.dart';

class MemberWithdrawScreen extends StatefulWidget {
  const MemberWithdrawScreen({super.key});

  @override
  State<MemberWithdrawScreen> createState() => _MemberWithdrawScreenState();
}

class _MemberWithdrawScreenState extends State<MemberWithdrawScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

    void withdraw() async {
      final apiService = ApiService();
      Map<String, dynamic> formData = {"memberId": controller.userId.value};
      try {
        final res = await apiService.withdraw(formData);
        if (res == 200) {
          controller.changePage(0);
        } else {
          Get.snackbar('오류', '${res["message"]}',
              snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        Get.snackbar('오류', '회원탈퇴 중 오류가 발생했습니다. 잠시 후 다시 이용해주세요.',
            snackPosition: SnackPosition.BOTTOM);
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: TopBar(onNotificationTap: () {}),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              '회원 탈퇴',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 100),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.delete_forever,
                    size: 200,
                    color: Color(0xffe32222),
                  ),
                  const SizedBox(height: 20),
                  const Text.rich(
                    TextSpan(
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      text: '정말로 ',
                      children: [
                        TextSpan(
                          text: '탈퇴',
                          style: TextStyle(color: Colors.red),
                        ),
                        TextSpan(
                          text: '하시겠습니까?',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text.rich(
                    TextSpan(
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w200),
                      text: '회원님과 관련된 ',
                      children: [
                        TextSpan(
                          text: '모든 데이터는 삭제',
                          style: TextStyle(
                              color: Color(0xffe32222),
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '되며,\n이 작업은 취소할 수 없습니다.',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value ?? false;
                          });
                        },
                      ),
                      const Flexible(
                        child: Text(
                          '위의 내용을 모두 확인하였으며, 탈퇴에 동의합니다.',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Button(
                        text: '취소',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        horizontal: 5,
                        vertical: 10,
                        fontSize: 16,
                        radius: 10,
                        backgroundColor: Colors.grey[200],
                        contentColor: Colors.black,
                      ),
                      Button(
                        text: '확인',
                        onPressed: isChecked
                            ? () {
                                withdraw();
                              }
                            : null,
                        horizontal: 5,
                        vertical: 10,
                        fontSize: 16,
                        radius: 10,
                        backgroundColor: const Color(0xffe32222),
                        contentColor: Colors.white,
                      ),
                    ],
                  ),
                ],
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
