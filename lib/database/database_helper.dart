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
    return await db.query('products');
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
}