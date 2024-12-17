import 'package:flutter/material.dart';
import 'package:frontend/components/common/button.dart';
import 'package:frontend/components/common/input.dart';
import 'package:frontend/components/common/input_label.dart';
import 'package:frontend/components/common/validator_text.dart';
import 'package:frontend/screens/mypage_screen.dart';
import 'package:get/get.dart';

class UpdateMemberScreen extends StatefulWidget {
  const UpdateMemberScreen({super.key});

  @override
  State<UpdateMemberScreen> createState() => _UpdateMemberScreenState();
}

class _UpdateMemberScreenState extends State<UpdateMemberScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? passwordError;
  String? confirmPasswordError;
  String? telError;

  // 폼 제출 함수 (API 제거된 버전)
  void submitForm() {
    setState(() {
      passwordError = null;
      confirmPasswordError = null;
      telError = null;
    });

    bool isValid = true;

    // 비밀번호 유효성 검사
    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      setState(() {
        passwordError = "비밀번호는 6자 이상이어야 합니다.";
      });
      isValid = false;
    }

    // 비밀번호 확인 검사
    if (confirmPasswordController.text != passwordController.text) {
      setState(() {
        confirmPasswordError = "비밀번호가 일치하지 않습니다.";
      });
      isValid = false;
    }

    // 전화번호 유효성 검사
    if (phoneController.text.isEmpty) {
      setState(() {
        telError = "전화번호를 입력하세요.";
      });
      isValid = false;
    }

    // 유효한 경우 MyPageScreen으로 이동
    if (isValid) {
      Get.off(() => const MyPageScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 150),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Image.asset(
                  'assets/icons/logo.png',
                  width: 350,
                ),
              ),
              const SizedBox(height: 50),
              const InputLabel(name: "비밀번호"),
              Input(
                controller: passwordController,
                inputType: TextInputType.visiblePassword,
                obscure: true,
              ),
              if (passwordError != null) ValidatorText(text: passwordError!),
              const InputLabel(name: "비밀번호 확인"),
              Input(
                controller: confirmPasswordController,
                inputType: TextInputType.visiblePassword,
                obscure: true,
              ),
              if (confirmPasswordError != null)
                ValidatorText(text: confirmPasswordError!),
              const InputLabel(name: "휴대전화 번호"),
              Input(
                controller: phoneController,
                inputType: TextInputType.phone,
              ),
              if (telError != null) ValidatorText(text: telError!),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: '수정',
                    onPressed: submitForm,
                    horizontal: 95,
                    vertical: 13,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
