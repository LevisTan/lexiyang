import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

final String tableName = "city_weather";
final String columnId = "_id";
final String columnCityName = "city_name";

//数据库表中，城市天气表含有两个字段，id（自增长）和城市名字
class City {
  int id;
  String cityName;

  City();

  Map<String,dynamic> toMap() {
    var map = <String,dynamic> {
      columnCityName : cityName,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  City.fromMap(Map<String,dynamic> map) {
    id = map[columnId];
    cityName = map[columnCityName];
  }
}

class WeatherDBProvider {

  WeatherDBProvider._internal();

  static final WeatherDBProvider db = WeatherDBProvider._internal();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    print("---------------------------------get database------------------------------");
    return _database;
  }

  initDB() async {
    print("---------------------------------initDB start------------------------------");
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "lxy3.db");
    //如果数据库名字相同，或已经存在，后面创建表的语句不会执行
    return await openDatabase(path, version: 1, onOpen: (db) { },
      onCreate: (Database db, int version) async {
        print("---------------------------------create table start------------------------------");
        await db.execute('''
        create table $tableName ( 
          $columnId integer primary key autoincrement, 
          $columnCityName text not null)
        ''');
        print("---------------------------------create table end------------------------------");
      });
  }

  Future<City> insert(City city) async {
    final db = await database;
    city.id = await db.insert(tableName, city.toMap());
    return city;
  }

  Future<List<City>> getAllCities() async {
    print("---------------------------------get city data start------------------------------");
    final db = await database;
    var res = await db.query("city_weather");
    List<City> list =
    res.isNotEmpty ? res.map((c) => City.fromMap(c)).toList() : [];
    return list;
  }

  //按主码删除
  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  //按城市名字删除
  Future<int> deleteByCityName(String cityName) async {
    final db = await database;
    return await db.delete(tableName, where: '$columnCityName = ?', whereArgs: [cityName]);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}

