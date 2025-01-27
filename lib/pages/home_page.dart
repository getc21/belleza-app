import 'package:belleza_app/pages/category_list_page.dart';
import 'package:belleza_app/pages/location_list_page.dart';
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
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    ProductListPage(),
    CategoryListPage(),
    SupplierListPage(),
    LocationListPage(),
    OrderListPage()
    
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control de Almacenes'),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.pink,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: GNav(
                backgroundColor: Colors.pink,
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.pink.shade700,
                gap: 4,
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
                    icon: Icons.location_on,
                    text: 'Ubicaciones',
                  ),
                  GButton(
                    icon: Icons.receipt_long,
                    text: 'Órdenes',
                  ),
                  
                ],
                selectedIndex: _selectedIndex,
                onTabChange: _onItemTapped,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
