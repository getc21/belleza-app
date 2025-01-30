import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class Utils {
  static const Color defaultColor = Color(0xFF616161);
  static const Color colorBotones = Color(0xFFEC407A);
  static const Color colorFondo = Color(0xFFF8BBD0);
  static const Color colorFondoCards = Color(0xFFFCE4EC);
  static const Color colorGnav = Color(0xFFF06292);
  static const Color yes = Color(0xFF66BB6A);
  static const Color no = Color(0xFFEF5350);
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitSpinningLines(
              color: const Color(0xFFE91E63),
              size: size ?? 120.0,
            ),
          ],
        ),
      );
  static RichText textLlaveValor(String llave, String valor,
      {Color color = defaultColor}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$llave: ", // Agrego ":" para mayor claridad
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: color, // Usa el color recibido
            ),
          ),
          TextSpan(
            text: valor,
            style: TextStyle(
              fontSize: 12,
              color: color, // Usa el color recibido
            ),
          ),
        ],
      ),
    );
  }

  static RichText textTitle(String llave) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: llave,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Utils.defaultColor,
            ),
          ),
        ],
      ),
    );
  }

  static RichText textDescription(String llave) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: llave,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Utils.defaultColor,
            ),
          ),
        ],
      ),
    );
  }

  static ElevatedButton elevatedButton(
          String txtBoton, Color colorBorde, VoidCallback voidCallback,
          [double tamanioLetra = 14.0]) =>
      ElevatedButton(
        style: estiloBotonRedondeado(colorBorde),
        onPressed: voidCallback,
        child: setText(txtBoton, tamanioLetra, true),
      );
  static ElevatedButton elevatedButtonWithIcon(String txtboton,
          Color colorBorde, VoidCallback voidCallback, IconData iconData,
          [double tamanioLetra = 14.0]) =>
      ElevatedButton.icon(
        style: estiloBotonRedondeado(colorBorde),
        onPressed: voidCallback,
        icon: Icon(iconData, color: Colors.white, size: 25),
        label: setText(txtboton, tamanioLetra, true),
      );

  static ButtonStyle estiloBotonRedondeado(
    Color color,
  ) =>
      ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: color,
        disabledForegroundColor: color,
        shadowColor: Utils.defaultColor,
        elevation: 5,
        //minimumSize: Size(30.0, 30.0),
        animationDuration: const Duration(milliseconds: 1),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        //side: BorderSide(color: color, width: 2.0)
      );
  static Text setText(String txt, double tamanio, fontWeight, [bool? center]) {
    double tamanioTexto = 12;
    return Text(txt,
        textAlign: TextAlign.center,
        style: Get.textTheme.bodyMedium!.copyWith(
          fontSize: tamanioTexto,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ));
  }

  static RichText bigTextLlaveValor(
      String llave, String valor, {Color color = defaultColor}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: llave,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w800, color: color),
          ),
          TextSpan(
            text: valor,
            style: TextStyle(fontSize: 18, color: color),
          ),
        ],
      ),
    );
  }

}
