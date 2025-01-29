import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'beauty_store.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT,  
            purchase_price REAL,
            sale_price REAL,
            weight TEXT,
            category_id INTEGER NOT NULL,
            supplier_id INTEGER NOT NULL,
            location_id INTEGER NOT NULL,
            foto TEXT,
            stock INTEGER,
            expirity_date TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT,
            foto TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE suppliers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            foto TEXT,
            name TEXT NOT NULL,
            contact_name TEXT,
            contact_email TEXT,
            contact_phone TEXT,
            address TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            order_date TEXT NOT NULL,
            totalOrden REAL NOT NULL
          )
        ''');
        db.execute('''
          CREATE TABLE locations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE order_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            order_id INTEGER NOT NULL,
            product_id INTEGER NOT NULL,
            quantity INTEGER NOT NULL,
            price REAL NOT NULL,
            FOREIGN KEY (order_id) REFERENCES orders (id),
            FOREIGN KEY (product_id) REFERENCES products (id)
          )
        ''');
        await _insertTestData(db);
      },
    );
  }

  Future<void> _insertTestData(Database db) async {
    // Insert categories
    await db.insert('categories', {'name': 'Category 1', 'description': 'Description 1', 'foto': 'foto1.png'});
    await db.insert('categories', {'name': 'Category 2', 'description': 'Description 2', 'foto': 'foto2.png'});
    await db.insert('categories', {'name': 'Category 3', 'description': 'Description 3', 'foto': 'foto3.png'});

    // Insert suppliers
    await db.insert('suppliers', {'name': 'Supplier 1', 'contact_name': 'Contact 1', 'contact_email': 'contact1@example.com', 'contact_phone': '1234567890', 'address': 'Address 1', 'foto': 'foto1.png'});
    await db.insert('suppliers', {'name': 'Supplier 2', 'contact_name': 'Contact 2', 'contact_email': 'contact2@example.com', 'contact_phone': '1234567891', 'address': 'Address 2', 'foto': 'foto2.png'});
    await db.insert('suppliers', {'name': 'Supplier 3', 'contact_name': 'Contact 3', 'contact_email': 'contact3@example.com', 'contact_phone': '1234567892', 'address': 'Address 3', 'foto': 'foto3.png'});

    // Insert locations
    await db.insert('locations', {'name': 'Location 1', 'description': 'Description 1'});
    await db.insert('locations', {'name': 'Location 2', 'description': 'Description 2'});
    await db.insert('locations', {'name': 'Location 3', 'description': 'Description 3'});

    // Insert products
    await db.insert('products', {'name': 'Product 1', 'description': 'Description 1', 'purchase_price': 8.0, 'sale_price': 10.0, 'weight': '1kg', 'category_id': 1, 'supplier_id': 1, 'location_id': 1, 'foto': 'foto1.png', 'stock': 100, 'expirity_date': '2023-12-31'});
    await db.insert('products', {'name': 'Product 2', 'description': 'Description 2', 'purchase_price': 16.0, 'sale_price': 20.0, 'weight': '2kg', 'category_id': 2, 'supplier_id': 2, 'location_id': 2, 'foto': 'foto2.png', 'stock': 200, 'expirity_date': '2023-12-31'});
    await db.insert('products', {'name': 'Product 3', 'description': 'Description 3', 'purchase_price': 22.0, 'sale_price': 30.0, 'weight': '3kg', 'category_id': 3, 'supplier_id': 3, 'location_id': 3, 'foto': 'foto3.png', 'stock': 300, 'expirity_date': '2023-12-31'});
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
  final db = await database;
  return await db.rawQuery('''
    SELECT p.*, 
           c.name as category_name, 
           s.name as supplier_name, 
           l.name as location_name
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    LEFT JOIN suppliers s ON p.supplier_id = s.id
    LEFT JOIN locations l ON p.location_id = l.id
  ''');
}

  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return await db.query('categories');
  }

  Future<List<Map<String, dynamic>>> getSuppliers() async {
    final db = await database;
    return await db.query('suppliers');
  }

  Future<List<Map<String, dynamic>>> getLocations() async {
    final db = await database;
    return await db.query('locations');
  }

  Future<void> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    await db.insert('products', product);
  }

  Future<void> insertCategory(Map<String, dynamic> category) async {
    final db = await database;
    await db.insert('categories', category);
  }

  Future<void> insertSupplier(Map<String, dynamic> supplier) async {
    final db = await database;
    await db.insert('suppliers', supplier);
  }

  Future<void> insertLocation(Map<String, dynamic> location) async {
    final db = await database;
    await db.insert('locations', location);
  }

  Future<void> insertOrder(Map<String, dynamic> order) async {
    final db = await database;
    double totalOrden = 0.0;
    for (var product in order['products']) {
      totalOrden += product['quantity'] * product['price'];
    }
    final orderId = await db.insert('orders', {
      'order_date': order['date'],
      'totalOrden': totalOrden,
    });
    for (var product in order['products']) {
      await db.insert('order_items', {
        'order_id': orderId,
        'product_id': product['id'],
        'quantity': product['quantity'],
        'price': product['price'],
      });
    }
  }

  Future<void> updateProduct(Map<String, dynamic> product) async {
    final db = await database;
    await db.update(
      'products',
      product,
      where: 'id = ?',
      whereArgs: [product['id']],
    );
  }

  Future<void> updateCategory(Map<String, dynamic> category) async {
    final db = await database;
    await db.update(
      'categories',
      category,
      where: 'id = ?',
      whereArgs: [category['id']],
    );
  }

  Future<void> updateSupplier(Map<String, dynamic> supplier) async {
    final db = await database;
    await db.update(
      'suppliers',
      supplier,
      where: 'id = ?',
      whereArgs: [supplier['id']],
    );
  }

  Future<void> updateLocation(Map<String, dynamic> location) async {
    final db = await database;
    await db.update(
      'locations',
      location,
      where: 'id = ?',
      whereArgs: [location['id']],
    );
  }

  Future<void> updateProductStock(int productId, int quantity) async {
    final db = await database;
    await db.rawUpdate('''
      UPDATE products
      SET stock = stock - ?
      WHERE id = ?
    ''', [quantity, productId]);
  }

  Future<void> deleteProduct(int id) async {
    final db = await database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteCategory(int id) async {
    final db = await database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteSupplier(int id) async {
    final db = await database;
    await db.delete('suppliers', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteLocation(int id) async {
    final db = await database;
    await db.delete('locations', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getProductsByCategory(
      int categoryId) async {
    final db = await database;
    return await db.query(
      'products',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
  }

  Future<List<Map<String, dynamic>>> getProductsBySupplier(
      int supplierId) async {
    final db = await database;
    return await db.query(
      'products',
      where: 'supplier_id = ?',
      whereArgs: [supplierId],
    );
  }

  Future<List<Map<String, dynamic>>> getProductsByLocation(
      int locationId) async {
    final db = await database;
    return await db.query(
      'products',
      where: 'location_id = ?',
      whereArgs: [locationId],
    );
  }

  Future<Map<String, dynamic>?> getProductByName(String name) async {
    final db = await database;
    final result = await db.query(
      'products',
      where: 'name = ?',
      whereArgs: [name],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getOrdersWithItems() async {
    final db = await database;
    final orders = await db.query('orders');
    List<Map<String, dynamic>> ordersWithItems = [];
    for (var order in orders) {
      Map<String, dynamic> orderCopy = Map<String, dynamic>.from(order);
      final orderItems = await db.rawQuery('''
        SELECT oi.*, p.name as product_name
        FROM order_items oi
        JOIN products p ON oi.product_id = p.id
        WHERE oi.order_id = ?
      ''', [order['id']]);
      orderCopy['items'] = orderItems;
      ordersWithItems.add(orderCopy);
    }
    return ordersWithItems;
  }
}
