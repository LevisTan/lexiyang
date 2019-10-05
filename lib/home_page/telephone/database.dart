import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

//联系人的本地化存储
final String tableName = "contact"; //表名
final String columnId = "_id";
final String columnName = "name";
final String columnPhone = "phone";

class ContactDB {
  int id; //数据库主码，自增长
  String phone; //手机号码
  String name;  //名字

  Map<String,dynamic> toMap() {
    var map = <String,dynamic> {
      columnPhone : phone,
      columnName : name,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  ContactDB();

  ContactDB.fromMap(Map<String,dynamic> map) {
    id = map[columnId];
    phone = map[columnPhone];
    name = map[columnName];
  }
}

//数据库helper类，提供数据库通用操作
class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "contact.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
          create table $tableName ( 
            $columnId integer primary key autoincrement, 
            $columnName text not null,
            $columnPhone text not null)
          ''');
      });
  }

  Future<ContactDB> insert(ContactDB contact) async {
    final db = await database;
    contact.id = await db.insert(tableName, contact.toMap());
    return contact;
  }

  Future<ContactDB> getUser(int id) async {
    final db = await database;
    List<Map> maps = await db.query(tableName,
        columns: [columnId, columnName],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return ContactDB.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ContactDB>> getAllUser() async {
    final db = await database;
    var res = await db.query("contact");
    List<ContactDB> list =
    res.isNotEmpty ? res.map((c) => ContactDB.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(ContactDB contact) async {
    final db = await database;
    return await db.update(tableName, contact.toMap(),
        where: '$columnId = ?', whereArgs: [contact.id]);
  }

  removeAll() async {
    final db = await database;
    db.delete(tableName);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}

