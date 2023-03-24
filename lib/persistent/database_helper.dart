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
  static const columnTimeStamp = 'timestamp';

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
            $columnTimeStamp TEXT NOT NULL,
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
    return await _db.query(table, orderBy: "$columnTimeStamp DESC");
  }

  Future<bool> isImeiExists(String imei) async {
    var sql = "SELECT COUNT(*) FROM $table WHERE imei = '$imei' ";
    var result = await _db.rawQuery(sql);
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future updateDateTime(
      String timestamp, String date, String time, String imei) async {
    var res = await _db.rawQuery(
        ''' UPDATE $table SET $columnTimeStamp = ? , $columnDate = ? , $columnTime = ? WHERE $columnImei = ? ''',
        [timestamp, date, time, imei]);
    return res;
  }

  Future updateDateTimeWithDeviceDetails(String deviceDetails, String timestamp,
      String date, String time, String imei) async {
    var res = await _db.rawQuery(
        ''' UPDATE $table SET $columnTimeStamp = ? , $columnDate = ? , $columnTime = ? , $columnDeviceDetails = ? WHERE $columnImei = ? ''',
        [timestamp, date, time, deviceDetails, imei]);
    return res;
  }

  Future<List<Map<String, dynamic>>> getImeiData(String imei) async {
    return await _db.query(table,
        where: "$columnImei = ? ", whereArgs: [imei], limit: 1);
  }
}
