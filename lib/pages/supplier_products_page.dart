import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:belleza_app/database/database_helper.dart';

class SupplierProductsPage extends StatefulWidget {
  final int supplierId;
  final String supplierName;

  const SupplierProductsPage({super.key, required this.supplierId, required this.supplierName});

  @override
  _SupplierProductsPageState createState() => _SupplierProductsPageState();
}

class _SupplierProductsPageState extends State<SupplierProductsPage> {
  List<Map<String, dynamic>> _products = [];
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    final products = await dbHelper.getProductsBySupplier(widget.supplierId);
    setState(() {
      _products = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos de ${widget.supplierName}'),
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          final fotoBase64 = product['foto'] ?? '';

          Uint8List? imageBytes;
          if (fotoBase64.isNotEmpty) {
            try {
              imageBytes = base64Decode(fotoBase64);
            } catch (e) {
              imageBytes = null; // Si ocurre un error, asigna null
            }
          }

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Imagen
                  if (imageBytes != null)
                    Image.memory(imageBytes, height: 50, width: 50, fit: BoxFit.cover)
                  else
                    Image.asset('assets/img/no-photo.jpg', height: 50, width: 50, fit: BoxFit.cover),
                  const SizedBox(width: 16.0), // Espaciado entre la imagen y el texto
                  // Texto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'] ?? 'Sin datos',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          product['description'] ?? 'Sin datos',
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
    );
  }
}