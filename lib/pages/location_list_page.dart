import 'package:belleza_app/database/database_helper.dart';
import 'package:flutter/material.dart';

class LocationListPage extends StatefulWidget {
  const LocationListPage({super.key});

  @override
  State<LocationListPage> createState() => _LocationListPageState();
}

class _LocationListPageState extends State<LocationListPage> {

  List<Map<String, dynamic>> _locations = [];

  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  void _loadLocations() async {
    final locations = await dbHelper.getLocations();
    setState(() {
      _locations = locations;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _locations.length,
        itemBuilder: (context, index) {
          final location = _locations[index];
          return Card(
            color: Colors.pink[100], // Color de fondo del Card
            margin: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 12.0), // Márgenes del Card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0), // Bordes redondeados
            ),
            elevation: 4, // Sombra para el Card
            child: Padding(
              padding: const EdgeInsets.all(12.0), // Espaciado interno del Card
              child: Column(
                children: [
                  Text(
                    location['name'] ?? 'Sin datos',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    location['description'] ?? 'Sin datos',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await dbHelper.insertLocation({
            'name': 'Bloque A',
            'description': 'Estante verde- entrada derecha',
            });
          _loadLocations();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}