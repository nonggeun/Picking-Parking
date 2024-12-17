import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/management_screen.dart';
import 'package:frontend/screens/reservation_screen.dart';
import 'package:frontend/screens/charging_screen.dart';
import 'package:frontend/screens/mypage_screen.dart';
import 'package:frontend/screens/splash_screen.dart';
import 'controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/config/.env');

  await checkPermissions();

  runApp(const App());
}

Future<void> checkPermissions() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  if (await Permission.location.isDenied) {
    await Permission.location.request();
  }

  if (await Permission.camera.isDenied) {
    await Permission.camera.request();
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF4C99F3),
        primaryColorLight: const Color(0xFFE3F7F7),
        cardColor: const Color(0xFFF2F3F5),
      ),
      initialRoute: '/splash',
      initialBinding: BindingsBuilder(() {
        Get.put(MainController());
      }),
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/management', page: () => ManagementScreen()),
        GetPage(name: '/reservation', page: () => ReservationScreen()),
        GetPage(name: '/myPage', page: () => MyPageScreen()),
        GetPage(name: '/charging', page: () => ChargingScreen()),
      ],
    );
  }
}
