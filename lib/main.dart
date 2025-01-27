import 'package:belleza_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BeautyStoreApp());
}

class BeautyStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Control de Almacenes - Belleza',
      theme: ThemeData(primarySwatch: Colors.pink),
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