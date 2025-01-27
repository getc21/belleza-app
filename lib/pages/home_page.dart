import 'package:belleza_app/pages/category_list_page.dart';
import 'package:belleza_app/pages/order_list_page.dart';
import 'package:belleza_app/pages/product_list_page.dart';
import 'package:belleza_app/pages/supplier_list_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    ProductListPage(),
    CategoryListPage(),
    SupplierListPage(),
    OrderListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control de Almacenes'),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.pink,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: GNav(
            backgroundColor: Colors.pink,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.pink.shade700,
            gap: 8,
            padding: EdgeInsets.all(16),
            tabs: [
              GButton(
                icon: Icons.inventory,
                text: 'Productos',
              ),
              GButton(
                icon: Icons.category,
                text: 'Categorías',
              ),
              GButton(
                icon: Icons.local_shipping,
                text: 'Proveedores',
              ),
              GButton(
                icon: Icons.receipt_long,
                text: 'Órdenes',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}

class LocationListPage {
}