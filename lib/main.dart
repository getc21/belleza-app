import 'package:belleza_app/controllers/indexpage_controller.dart';
import 'package:belleza_app/controllers/loading_controller.dart';
import 'package:belleza_app/pages/home_page.dart';
import 'package:belleza_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(IndexPageController());
  Get.put(LoadingController());
  runApp(BeautyStoreApp());
}

class BeautyStoreApp extends StatefulWidget {
  const BeautyStoreApp({super.key});

  @override
  State<BeautyStoreApp> createState() => _BeautyStoreAppState();
}

class _BeautyStoreAppState extends State<BeautyStoreApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Control de Almacenes - Belleza',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Utils.colorBotones, // Color del cursor
          selectionColor: Utils.colorBotones.withOpacity(0.5), // Color del texto seleccionado
          selectionHandleColor: Utils.colorBotones, // Color del handle de selección
        ),
      ),
      home: HomePage(),
      locale: Locale('es', 'ES'), // Establecer el idioma predeterminado
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // Inglés
        const Locale('es', ''), // Español
      ],
    );
  }
}