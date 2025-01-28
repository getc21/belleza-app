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
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT,  
            price REAL,
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
            order_id INTEGER NOT NULL,
            product_id INTEGER NOT NULL,
            quantity INTEGER NOT NULL,
            price REAL NOT NULL,
            FOREIGN KEY (order_id) REFERENCES orders (id),
            FOREIGN KEY (product_id) REFERENCES products (id)
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
      },
    );
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT p.*, l.name as location_name
      FROM products p
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
    final orderId = await db.insert('orders', {'date': order['date']});
    for (var product in order['products']) {
      await db.insert('order_items', {
        'order_id': orderId,
        'product_id': product['id'],
        'quantity': product['quantity'],
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

  Future<List<Map<String, dynamic>>> getProductsByCategory(int categoryId) async {
    final db = await database;
    return await db.query(
      'products',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
  }

  Future<List<Map<String, dynamic>>> getProductsBySupplier(int supplierId) async {
    final db = await database;
    return await db.query(
      'products',
      where: 'supplier_id = ?',
      whereArgs: [supplierId],
    );
  }

  Future<List<Map<String, dynamic>>> getProductsByLocation(int locationId) async {
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
}