import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/controller.dart';

class BottomNavigation extends StatelessWidget {
  final Function(int) onTap;

  const BottomNavigation({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.find();

    return BottomNavigationBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      currentIndex: controller.currentIndex.value,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black54,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/icons/icon_management.svg'),
          label: "관리",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/icons/icon_reservation.svg'),
          label: "예약",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/icons/icon_home.svg'),
          label: "홈",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/icons/icon_recharging.svg'),
          label: "충전",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/icons/icon_mypage.svg'),
          label: "마이페이지",
        ),
      ],
    );
  }
}
