import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:frontend/screens/notification_screen.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final Function onNotificationTap;

  const TopBar({Key? key, required this.onNotificationTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool showLogo = !(ModalRoute.of(context)?.canPop ?? false);

    return AppBar(
      titleSpacing: 0,
      title: showLogo
          ? Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SvgPicture.asset(
                    'assets/icons/logo.svg',
                    width: 32,
                    height: 32,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SvgPicture.asset(
                    'assets/icons/logo_text.svg',
                    width: 50,
                    height: 25,
                  ),
                ),
              ],
            )
          : null,
      actions: [
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notification clicked!')),
            );
            Get.to(() => const NotificationScreen());
          },
          child: Container(
            padding: const EdgeInsets.only(right: 20),
            child: SvgPicture.asset(
              'assets/icons/notification.svg',
            ),
          ),
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
