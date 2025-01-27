import 'dart:convert';
import 'dart:io';

import 'package:belleza_app/database/database_helper.dart';
import 'package:belleza_app/pages/add_product_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  ProductListPageState createState() => ProductListPageState();
}

class ProductListPageState extends State<ProductListPage> {
  List<Map<String, dynamic>> _products = [];
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    final products = await dbHelper.getProducts();
    setState(() {
      _products = products;
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Wrap(
        spacing: 8, // Espaciado horizontal entre elementos
        runSpacing: 8, // Espaciado vertical entre filas
        children: _products.map((product) {
          final stock = product['stock'] ?? 0;
          final expiryDate = DateTime.tryParse(product['expiryDate'] ?? '');
          final isLowStock = stock < 10;
          final isNearExpiry = expiryDate != null &&
              expiryDate.difference(DateTime.now()).inDays <= 30;
          final weight = product['weight'] ?? '';
          final location = product['location'] ?? '';
          final price = product['price'] ?? 0.0;
          final fotoBase64 = product['foto'] ?? '';

          Uint8List? imageBytes;
          if (fotoBase64.isNotEmpty) {
            try {
              imageBytes = base64Decode(fotoBase64);
            } catch (e) {
              imageBytes = null; // Si ocurre un error, asigna null
            }
          }
          return Container(
            width: MediaQuery.of(context).size.width * 0.45, // Ajusta el ancho
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen con iconos
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                        child: imageBytes != null
                        ? Image.memory(
                          imageBytes,
                          height: 120,
                          width: double.infinity,
                        )
                        
                        
                        :Image.asset(
                          'assets/img/perfume.webp',
                          fit: BoxFit.cover,
                          height: 120,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isLowStock)
                          const Icon(Icons.warning_rounded, color: Colors.red),
                        if (isNearExpiry)
                          const Icon(Icons.calendar_today,
                              color: Colors.orange),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Nombre del producto
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    product['name'] ?? 'Producto',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    product['description'] ?? 'Descripción',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                // Fecha de vencimiento y QR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              expiryDate != null
                                  ? 'Vence:\n${expiryDate.toLocal()}'.split(' ')[0]
                                  : 'Sin fecha',
                              style: const TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              stock != null ? 'Stock: $stock' : 'Sin stock',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              weight.isNotEmpty
                                  ? 'Tamaño: $weight'
                                  : 'Sin tamaño',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              location.isNotEmpty
                                  ? 'Ubicación: $location'
                                  : 'Sin ubicación',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Precio: $price',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _generateAndShowPdf(context, product['name']);
                        },
                        child: BarcodeWidget(
                          barcode: Barcode.qrCode(),
                          data: product['name'] ?? '',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () async {

        Get.to(AddProductPage());
        // await dbHelper.insertProduct({
        //   'name': 'Producto ${_products.length + 1}',
        //   'description': 'Aceite esencial de coco',
        //   'price': 10.0,
        //   'weight': '100 ml',
        //   'category_id': 1,
        //   'supplier_id': 1,
        //   'stock': 30,
        //   'expiryDate':
        //       DateTime.now().add(const Duration(days: 50)).toIso8601String(),
        //   'location': 'Estante A',
        //   'foto': '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',
        // });
        // _loadProducts();
      },
      child: const Icon(Icons.add),
    ),
  );
}


  Future<void> _generateAndShowPdf(
      BuildContext context, String productName) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat:
            PdfPageFormat(80 * PdfPageFormat.mm, 100 * PdfPageFormat.mm),
        build: (pw.Context context) {
          return pw.GridView(
            crossAxisCount: 4,
            childAspectRatio: 1,
            children: List.generate(12, (index) {
              return pw.Container(
                alignment: pw.Alignment.center,
                padding: const pw.EdgeInsets.all(4),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.BarcodeWidget(
                      barcode: pw.Barcode.qrCode(),
                      data: productName,
                      width: 40,
                      height: 40,
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      productName,
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );

    final directory = await getTemporaryDirectory();

    final filePath = '${directory.path}/$productName.pdf';

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Abre el archivo PDF con un visor externo
    await OpenFilex.open(filePath);
  }
}
