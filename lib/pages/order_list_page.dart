import 'package:flutter/material.dart';
import 'package:belleza_app/pages/add_order_page.dart';
import 'package:get/get.dart';

class OrderListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Órdenes'),
      ),
      body: Center(
        child: Text('Listado de Órdenes'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          Get.to(AddOrderPage());
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}