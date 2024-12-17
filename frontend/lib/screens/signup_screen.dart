import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/components/common/button.dart';
import 'package:frontend/components/common/input.dart';
import 'package:frontend/components/common/input_label.dart';
import 'package:frontend/components/common/validator_text.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final MainController controller = Get.put(MainController());
  final formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? idError;
  String? passwordError;
  String? confirmPasswordError;
  String? phoneError;

  Future<void> submitForm() async {
    setState(() {
      idError = null;
      passwordError = null;
      confirmPasswordError = null;
      phoneError = null;
    });

    bool isValid = true;

    if (idController.text.isEmpty) {
      setState(() {
        idError = "아이디를 입력하세요.";
      });
      isValid = false;
    }

    if (passwordController.text.length < 6) {
      setState(() {
        passwordError = "비밀번호는 6자 이상이어야 합니다.";
      });
      isValid = false;
    }

    if (confirmPasswordController.text != passwordController.text) {
      setState(() {
        confirmPasswordError = "비밀번호가 일치하지 않습니다.";
      });
      isValid = false;
    }

    if (phoneController.text.isEmpty) {
      setState(() {
        phoneError = "휴대폰 번호를 입력하세요.";
      });
      isValid = false;
    }

    if (isValid) {
      final apiService = ApiService();
      Map<String, dynamic> formData = {
        'user_id': idController.text,
        'user_pw': passwordController.text,
        'user_phone': phoneController.text,
      };

      try {
        final res = await apiService.signUp(formData);
        if (res == 200) {
          Get.snackbar(
            '성공',
            '회원가입이 완료되었습니다.',
            snackPosition: SnackPosition.BOTTOM,
          );
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Get.to(() => const LoginScreen());
          });
        } else {
          Get.snackbar(
            '오류',
            res['message'] ?? '회원가입에 실패했습니다.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        Get.snackbar(
          '오류',
          '회원가입 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double inputWidth = screenWidth < 600 ? screenWidth * 0.9 : 500;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: inputWidth),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: SvgPicture.asset(
                        'assets/icons/logo.svg',
                        width: inputWidth * 0.6,
                        height: inputWidth * 0.6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const InputLabel(name: "아이디"),
                    Input(
                      controller: idController,
                      inputType: TextInputType.text,
                    ),
                    if (idError != null) ValidatorText(text: idError!),
                    const SizedBox(height: 20),
                    const InputLabel(name: "비밀번호"),
                    Input(
                      controller: passwordController,
                      inputType: TextInputType.visiblePassword,
                      obscure: true,
                    ),
                    if (passwordError != null)
                      ValidatorText(text: passwordError!),
                    const SizedBox(height: 20),
                    const InputLabel(name: "비밀번호 확인"),
                    Input(
                      controller: confirmPasswordController,
                      inputType: TextInputType.visiblePassword,
                      obscure: true,
                    ),
                    if (confirmPasswordError != null)
                      ValidatorText(text: confirmPasswordError!),
                    const SizedBox(height: 20),
                    const InputLabel(name: "휴대폰 번호"),
                    Input(
                      controller: phoneController,
                      inputType: TextInputType.phone,
                    ),
                    if (phoneError != null) ValidatorText(text: phoneError!),
                    const SizedBox(height: 30),
                    Center(
                      child: Button(
                        text: "회원가입",
                        onPressed: submitForm,
                        width: inputWidth,
                        horizontal: 5,
                        vertical: 15,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () => Get.to(() => const LoginScreen()),
                        child: const Text("로그인 화면으로 돌아가기"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
