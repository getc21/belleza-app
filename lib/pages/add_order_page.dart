import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:belleza_app/database/database_helper.dart';
import 'package:get/get.dart';
import 'package:flutter_beep/flutter_beep.dart';

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
          _products.add(product);
        });
        FlutterBeep.beep();
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