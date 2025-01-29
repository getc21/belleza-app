import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:belleza_app/pages/add_order_page.dart';
import 'package:belleza_app/database/database_helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final orders = await dbHelper.getOrdersWithItems();
    log(orders.toString());
    setState(() {
      _orders = orders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _orders.isEmpty
          ? Center(child: Text('No hay órdenes disponibles'))
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                final orderDate = DateFormat('yyyy-MM-dd')
                    .format(DateTime.parse(order['order_date']));
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Orden: ${order['id']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text('Fecha: $orderDate'),
                        Text('Total: \$${order['totalOrden']}'),
                        SizedBox(height: 10),
                        Text(
                          'Productos de la orden:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        ...order['items'].map<Widget>((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Text(
                              '${item['quantity']} Unid. ${item['product_name']} - \Bs${item['price']}',
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
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
