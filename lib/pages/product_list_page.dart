import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:belleza_app/database/database_helper.dart';
import 'package:belleza_app/pages/add_product_page.dart';
import 'package:belleza_app/pages/edit_product_page.dart';
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
  List<Map<String, dynamic>> _filteredProducts = [];
  List<Map<String, dynamic>> _allProducts = [];
  final dbHelper = DatabaseHelper();
  bool _isExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    final products = await dbHelper.getProducts();
    log(products.toString());
    setState(() {
      _products = products;
      _allProducts = products;
      _filteredProducts = products;
    });
  }

  void _deleteProduct(int id) async {
    await dbHelper.deleteProduct(id);
    _loadProducts();
  }

  void _filterProducts(String searchText) {
    setState(() {
      if (searchText.isNotEmpty) {
        _filteredProducts = _allProducts.where((product) {
          final name = product['name'].toLowerCase();
          final description = product['description'].toLowerCase();
          final category = product['category_name']?.toLowerCase() ?? '';
          final supplier = product['supplier_name']?.toLowerCase() ?? '';
          final searchLower = searchText.toLowerCase();
          return name.contains(searchLower) ||
              description.contains(searchLower) ||
              category.contains(searchLower) ||
              supplier.contains(searchLower);
        }).toList();
      } else {
        _filteredProducts = _allProducts;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              spacing: 8, // Espaciado horizontal entre elementos
              runSpacing: 8, // Espaciado vertical entre filas
              children: _filteredProducts.map((product) {
                final stock = product['stock'] ?? 0;
                final expiryDate =
                    DateTime.tryParse(product['expirity_date'] ?? '');
                final isLowStock = stock < 10;
                final isNearExpiry = expiryDate != null &&
                    expiryDate.difference(DateTime.now()).inDays <= 30;
                final weight = product['weight'] ?? '';
                final locationName =
                    product['location_name'] ?? 'Sin ubicación';
                final purchasePrice = product['purchase_price'] ?? 0.0;
                final salePrice = product['sale_price'] ?? 0.0;
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
                    color: Colors.pink[50],
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
                                      height: 132,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      'assets/img/perfume.webp',
                                      fit: BoxFit.fill,
                                      height: 130,
                                      width: double.infinity,
                                    ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue, // Color de fondo
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(
                                          5)), // Bordes redondeados
                                ), // Espaciado interno
                                child: IconButton(
                                  onPressed: () {
                                    Get.to(EditProductPage(product: product));
                                  },
                                  icon: const Icon(Icons.edit),
                                  color: Colors.white, // Color del ícono
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    _deleteProduct(product['id']);
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Colors.white, // Color del ícono
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
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
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: GestureDetector(
                              onTap: () {
                                _generateAndShowPdf(context, product['name']);
                              },
                              child: BarcodeWidget(
                                backgroundColor: Colors.white,
                                barcode: Barcode.qrCode(),
                                data: product['name'] ?? '',
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ),
                        ],
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
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                      expiryDate != null
                                          ? 'Fecha de caducidad: ${expiryDate.toLocal().toString().split(' ')[0]}'
                                          : 'Sin fecha',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: isNearExpiry
                                              ? Colors.orange
                                              : Colors.black)),
                                  Text(
                                    stock != null
                                        ? 'Stock: $stock'
                                        : 'Sin stock',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: isLowStock
                                            ? Colors.red
                                            : Colors.black),
                                  ),
                                  Text(
                                    weight.isNotEmpty
                                        ? 'Tamaño: $weight'
                                        : 'Sin tamaño',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Ubicación: $locationName',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Precio de compra: $purchasePrice',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Precio de venta: $salePrice',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
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
          Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: _isExpanded ? 400 : 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.pink.shade400,
                    width: 4,
                  ),
                ),
                child: Row(
                  children: [
                    AnimatedAlign(
                      duration: Duration(milliseconds: 300),
                      alignment:
                          _isExpanded ? Alignment.centerLeft : Alignment.center,
                      child: IconButton(
                        icon: Icon(
                          _isExpanded ? Icons.close : Icons.search,
                          color: Colors.pink.shade400,
                          size: 35,
                        ),
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: AnimatedAlign(
                        duration: Duration(milliseconds: 300),
                        alignment: _isExpanded
                            ? Alignment.center
                            : Alignment.centerRight,
                        child: _isExpanded
                            ? TextField(
                                controller: _searchController,
                                onChanged: _filterProducts,
                                decoration: InputDecoration(
                                  hintText: 'Buscar un producto...',
                                  border: InputBorder.none,
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink[400],
        onPressed: () async {
          Get.to(AddProductPage());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
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