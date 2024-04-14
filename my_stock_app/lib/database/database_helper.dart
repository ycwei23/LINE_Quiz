import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'stock_database.db');
    print("Database path: $path");  // 日誌輸出數據庫路徑

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        print("Creating new table stocks");  // 確認是否進入 onCreate 方法
        await _createDb(db, version);
      },
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE stocks (
        stockCode TEXT PRIMARY KEY,
        stockName TEXT,
        volume REAL,
        amount REAL,
        openPrice REAL,
        highPrice REAL,
        lowPrice REAL,
        closePrice REAL,
        change REAL,
        transactionCount REAL
      )
    ''');
  }

  Future<void> clearDatabase() async {
    final db = await instance.db;
    await db.delete('stocks');
  }

  Future<void> insertStockData(List<Map<String, dynamic>> stockData) async {
    final db = await instance.db;
    final batch = db.batch();
    for (var data in stockData) {
      batch.insert('stocks', data);
    }
    await batch.commit();
  }
}