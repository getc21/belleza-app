import 'dart:convert';

import 'package:belleza_app/database/database_helper.dart';
import 'package:belleza_app/pages/add_category_page.dart';
import 'package:belleza_app/pages/category_products_page.dart';
import 'package:belleza_app/pages/edit_category_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  void _deleteCategory(int id) async {
    await dbHelper.deleteCategory(id);
    _loadCategories(); // Recargar la lista de categorías después de eliminar
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
          return GestureDetector(
            onTap: () {
              Get.to(CategoryProductsPage(
                categoryId: category['id'],
                categoryName: category['name'],
              ));
            },
            child: Card(
              color: Colors.pink[100], // Color de fondo del Card
              margin: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 12.0), // Márgenes del Card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0), // Bordes redondeados
              ),
              elevation: 4, // Sombra para el Card
              child: Padding(
                padding: const EdgeInsets.only(left: 12), // Espaciado interno del Card
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
                              width: 120,
                              fit: BoxFit.fill,
                            )
                          : Image.asset(
                              'assets/img/perfume.webp',
                              height: 80,
                              width: 80,
                              fit: BoxFit.fill,
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
                    Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue, // Color de fondo
                                borderRadius: BorderRadius.only(
                                    topRight:
                                        Radius.circular(16)), // Bordes redondeados
                              ), // Espaciado interno
                              child: IconButton(
                                onPressed: () {
                                  Get.to(EditCategoryPage(category: category));
                                },
                                icon: const Icon(Icons.edit),
                                color: Colors.white, // Color del ícono
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                    bottomRight:
                                        Radius.circular(16)),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  _deleteCategory(category['id']);
                                },
                                icon: const Icon(Icons.delete),
                                color: Colors.white, // Color del ícono
                              ),
                            ),
                          ],
                        ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () async {
          Get.to(AddCategoryPage());
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
