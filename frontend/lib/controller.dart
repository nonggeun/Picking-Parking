import 'package:get/get.dart';

class MainController extends GetxController {
  var fcmToken = "".obs;
  var accessToken = "".obs;
  var currentIndex = 0.obs;
  var pageStack = <int>[0].obs;
  var userEmail = "".obs;
  var userId = 0.obs;
  var userName = "".obs;
  var userRole = "".obs;

  void changePage(int index) {
    if (index < 0 || index >= 5) return;
    currentIndex.value = index;
    switch (index) {
      case 0:
        if (Get.currentRoute != '/management') {
          Get.offAllNamed('/management');
          break;
        }
      case 1:
        if (Get.currentRoute != '/reservation') {
          Get.offAllNamed('/reservation');
          break;
        }
      case 2:
        if (Get.currentRoute != 'home') {
          Get.offAllNamed('/home');
          break;
        }
      case 3:
        if (Get.currentRoute != '/charging') {
          Get.offAllNamed('/charging');
          break;
        }
      case 4:
        if (Get.currentRoute != '/myPage') {
          Get.offAllNamed('/myPage');
          break;
        }
    }
  }
}
