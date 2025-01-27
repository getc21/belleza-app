import 'dart:convert';

import 'package:belleza_app/database/database_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryListPage extends StatefulWidget {
  CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  List<Map<String, dynamic>> _categories = [];

  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    final categories = await dbHelper.getCategories();
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final fotoBase64 = category['foto'];
          Uint8List? imageBytes;
          if (fotoBase64.isNotEmpty) {
            try {
              imageBytes = base64Decode(fotoBase64);
            } catch (e) {
              imageBytes = null; // Si ocurre un error, asigna null
            }
          }
          return Card(
            color: Colors.pink[100], // Color de fondo del Card
            margin: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 12.0), // Márgenes del Card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0), // Bordes redondeados
            ),
            elevation: 4, // Sombra para el Card
            child: Padding(
              padding: const EdgeInsets.all(12.0), // Espaciado interno del Card
              child: Row(
                children: [
                  // Imagen con bordes redondeados
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        12.0), // Bordes redondeados de la imagen
                    child: imageBytes != null
                        ? Image.memory(
                            imageBytes,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/img/perfume.webp',
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(
                      width: 16.0), // Espaciado entre la imagen y el texto
                  // Texto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category['name'] ?? 'Sin datos',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          category['description'] ?? 'Sin datos',
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await dbHelper.insertCategory({
            'name': 'Aceites',
            'description': 'Aceites esenciales y aceites artificiales',
            'foto':
                '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',
          });
          _loadCategories();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
