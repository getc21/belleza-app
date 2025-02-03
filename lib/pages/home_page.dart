import 'package:belleza_app/controllers/indexpage_controller.dart';
import 'package:belleza_app/controllers/loading_controller.dart';
import 'package:belleza_app/pages/category_list_page.dart';
import 'package:belleza_app/pages/financial_report_page.dart';
import 'package:belleza_app/pages/location_list_page.dart';
import 'package:belleza_app/pages/order_list_page.dart';
import 'package:belleza_app/pages/product_list_page.dart';
import 'package:belleza_app/pages/report_page.dart';
import 'package:belleza_app/pages/sales_history_page.dart';
import 'package:belleza_app/pages/supplier_list_page.dart';
import 'package:belleza_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:loading_overlay/loading_overlay.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ipc = Get.find<IndexPageController>();
  final loadingC = Get.find<LoadingController>();
  final List<Widget> widgetOptions = [];
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      ProductListPage(),
      CategoryListPage(),
      SupplierListPage(),
      LocationListPage(),
      OrderListPage()
    ];
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Utils.colorFondoCards,
                title: Text('¿Desea salir de la aplicación?'),
                content: Text('Presione Confirmar para salir'),
                actions: [
                  Utils.elevatedButton('Cancelar', Utils.no, () {
                    Navigator.pop(context, false);
                  }),
                  Utils.elevatedButton('Confirmar', Utils.yes, () {
                    Navigator.pop(context, true);
                  }),
                ],
              ),
            ) ??
            false;

        if (shouldPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Utils.colorGnav,
          title: Text('Control de Almacenes'),
          centerTitle: true,
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.bar_chart),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Utils.colorGnav,
                ),
                child: Text(
                  'Estadísticas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.insert_chart),
                title: Text('Reporte de Rotación de Productos'),
                onTap: () {
                  Navigator.pop(context); // Cierra el drawer
                  Get.to(ReportPage());
                },
              ),
              ListTile(
                leading: Icon(Icons.monetization_on),
                title: Text('Reporte de ventas'),
                onTap: () {
                  Navigator.pop(context); // Cierra el drawer
                  Get.to(SalesHistoryPage());
                },
              ),
              ListTile(
                leading: Icon(Icons.monetization_on),
                title: Text('Reporte financiero'),
                onTap: () {
                  Navigator.pop(context); // Cierra el drawer
                  Get.to(FinancialReportPage());
                },
              ),
            ],
          ),
        ),
        body: widgetOptions.elementAt(ipc.getIndexPage),
        bottomNavigationBar: SafeArea(
          child: Container(
            color: Utils.colorGnav,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: GNav(
                backgroundColor: Utils.colorGnav,
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.pink.shade400,
                gap: 4,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
                selectedIndex: ipc.getIndexPage,
                onTabChange: (index) {
                  ipc.setIndexPage(index);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
