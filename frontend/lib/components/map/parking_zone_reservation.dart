import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ParkingZoneReservation extends StatelessWidget {
  const ParkingZoneReservation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/pin_map.svg',
            height: 40,
            width: 40,
          ),
        ),
      ],
    );
  }
}
