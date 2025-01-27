import 'package:belleza_app/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BeautyStoreApp());
}

class BeautyStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Control de Almacenes - Belleza',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: HomePage(),
    );
  }
}