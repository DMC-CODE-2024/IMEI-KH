import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "eirs_device_history.db";
  static const _databaseVersion = 1;
  static const table = 'history_table';
  static const columnId = '_id';
  static const columnImei = 'imei';
  static const columnDeviceDetails = 'device_details';
  static const columnIsValid = 'is_valid';
  static const columnDate = 'date';
  static const columnTime = 'time';

  late Database _db;

  // this opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnImei TEXT NOT NULL,
            $columnDeviceDetails TEXT NOT NULL,
            $columnIsValid INTEGER NOT NULL,
            $columnDate TEXT NOT NULL,
            $columnTime TEXT NOT NULL
          )
          ''');
  }

  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    return await _db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> getDeviceHistory() async {
    return await _db.query(table);
  }

  Future<bool> isImeiExists(String imei) async {
    var result = await _db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $table WHERE imei= $imei )',
    );
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }
}