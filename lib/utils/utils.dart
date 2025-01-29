import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class Utils {
  // static Color? colorFondoClaro = Colors.grey[100];
  // static Color? primaryColor = const Color.fromRGBO(15, 16, 53, 1);
  // static Color? secondaryColor = const Color.fromRGBO(243, 184, 5, 1);
  // static Color? thirtColor = const Color.fromRGBO(76, 185, 213, 1);
  // static Color? fourColor = const Color.fromRGBO(54, 84, 134, 1);
  static get espacio05 => const Gap(05.0);
  static get espacio10 => const Gap(10.0);
  static get espacio15 => const Gap(15.0);
  static get espacio20 => const Gap(20.0);
  static get espacio25 => const Gap(25.0);
  static get espacio30 => const Gap(30.0);
  static get espacio35 => const Gap(35.0);
  static get espacio40 => const Gap(40.0);
  static get espacio45 => const Gap(45.0);
  static get espacio50 => const Gap(50.0);
  static get espacio55 => const Gap(55.0);
  static get espacio60 => const Gap(60.0);
  static loadingCustom([double? size]) => Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, 
          children: [
            SpinKitSpinningLines(
              color: Colors.pink,
              size: size ?? 120.0,
            ),
          ],
        ),
      );
}