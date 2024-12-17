import 'package:flutter/material.dart';
import 'package:frontend/components/common/button.dart';
import 'package:get/get.dart';

class CompleteScreen extends StatefulWidget {
  @override
  _CompleteScreenState createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;
  late String message;
  late String detailMessage;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    final args = Get.arguments ?? {};
    if (args['type'] == 'reservation') {
      message = "예약 완료!";
      detailMessage = "버튼을 누르시면 예약 화면으로 돌아갑니다.";
    } else if (args['type'] == 'parking') {
      message = "주차 구역 등록 완료!";
      detailMessage = "버튼을 누르시면 주차 화면으로 돌아갑니다.";
    } else {
      message = "결제 완료!";
      detailMessage = "버튼을 누르시면 충전 화면으로 돌아갑니다.";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("완료")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: AnimatedBuilder(
                    animation: _checkAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: CheckPainter(_checkAnimation.value),
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              detailMessage,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Button(
              text: "홈으로 돌아가기",
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              horizontal: 16,
              vertical: 8,
              fontSize: 16,
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class CheckPainter extends CustomPainter {
  final double progress;

  CheckPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.1, size.height * 0.5);
    path.lineTo(size.width * 0.4, size.height * 0.8);
    path.lineTo(size.width * 0.9, size.height * 0.2);

    final pathMetrics = path.computeMetrics();
    for (var metric in pathMetrics) {
      final extractPath = metric.extractPath(0.0, metric.length * progress);
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(CheckPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
