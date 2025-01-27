import 'dart:io';

import 'package:belleza_app/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
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
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Número de columnas
          crossAxisSpacing: 8, // Espaciado horizontal
          mainAxisSpacing: 8, // Espaciado vertical
          childAspectRatio: 0.75, // Proporción ancho/alto
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          final stock = product['stock'] ?? 0;
          final expiryDate = DateTime.tryParse(product['expiryDate'] ?? '');
          final isLowStock = stock < 10;
          final isNearExpiry = expiryDate != null &&
              expiryDate.difference(DateTime.now()).inDays <= 30;

          return Container(
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
                        child: Image.asset(
                          'assets/img/perfume.webp',
                          fit: BoxFit.cover, // Ajusta la imagen al ancho
                          height: 150, // Máximo alto
                          width:
                              double.infinity, // Ajusta el ancho al contenedor
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isLowStock)
                          const Icon(Icons.warning, color: Colors.red),
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
                      // Fecha de vencimiento
                      Expanded(
                        child: Text(
                          expiryDate != null
                              ? 'Vence:\n${expiryDate.toLocal()}'.split(' ')[0]
                              : 'Sin fecha',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      // QR del producto
                      BarcodeWidget(
                        barcode: Barcode.qrCode(),
                        data: product['name'] ?? '',
                        width: 40,
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await dbHelper.insertProduct({
            'name': 'Producto ${_products.length + 1}',
            'stock': 5,
            'expiryDate':
                DateTime.now().add(const Duration(days: 25)).toIso8601String(),
            'location': 'Estante A',
          });
          _loadProducts();
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
                      data: '$productName - $index',
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
