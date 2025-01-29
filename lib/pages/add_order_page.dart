import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:belleza_app/database/database_helper.dart';
import 'package:get/get.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key});

  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  List<Map<String, dynamic>> _products = [];
  final dbHelper = DatabaseHelper();

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      final productName = scanData.code;
      final product = await dbHelper.getProductByName(productName!);
      if (product != null) {
        setState(() {
          if (!_products.any((p) => p['id'] == product['id'])) {
            _products.add({
              'id': product['id'],
              'name': product['name'],
              'quantity': 1, // Inicializa la cantidad en 1
              'price': product['price'],
            });
            log('Product added: ${product['name']}');
            FlutterRingtonePlayer().play(
              fromAsset: 'assets/img/beep.mp3',
            );
          }
        });
      }
    });
  }

  void _incrementQuantity(int index) {
    setState(() {
      _products[index]['quantity']++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_products[index]['quantity'] > 1) {
        _products[index]['quantity']--;
      }
    });
  }

  void _registerOrder() async {
    final newOrder = {
      'products': _products,
      'date': DateTime.now().toString(),
    };
    await dbHelper.insertOrder(newOrder);

    // Update product stock
    for (var product in _products) {
      await dbHelper.updateProductStock(product['id'], product['quantity']);
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Orden'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text('Cantidad: ${product['quantity']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => _decrementQuantity(index),
                      ),
                      Text('${product['quantity']}'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => _incrementQuantity(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _registerOrder,
            child: Text('Registrar Orden'),
          ),
        ],
      ),
    );
  }
}
