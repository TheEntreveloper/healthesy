import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbUtil {
  Database? _database;
  String dbName;
  List<String> ddl = [
    "CREATE TABLE app (id INTEGER PRIMARY KEY AUTOINCREMENT, appname TEXT, data TEXT, purchased INTEGER)",
    "CREATE TABLE user (id INTEGER , username TEXT, password TEXT, utype INTEGER, email TEXT, regdate INTEGER)",
    "CREATE TABLE mednote (id INTEGER PRIMARY KEY AUTOINCREMENT, rectype TEXT, "
        "field1 TEXT, field2 TEXT, field3 TEXT, field4 TEXT, field5 TEXT, field6 TEXT, lastupdate INTEGER, created INTEGER)",
    "CREATE TABLE upsdowns (id INTEGER PRIMARY KEY AUTOINCREMENT, status INTEGER, qnote TEXT, currdate INTEGER)",
    "CREATE TABLE hinfo (id INTEGER PRIMARY KEY AUTOINCREMENT, ht INTEGER, "
        "wt INTEGER, gender TEXT, ager TEXT, rf1 TEXT, rf2 TEXT, lastupdate INTEGER, created INTEGER)",
    "CREATE TABLE messages (id INTEGER PRIMARY KEY AUTOINCREMENT, mtype INTEGER, "
        "senderid INTEGER, title TEXT, body TEXT, created INTEGER)",
    "CREATE TABLE dbldata (id INTEGER PRIMARY KEY AUTOINCREMENT, vtype TEXT, value REAL, qnote TEXT, currdate INTEGER)",
    "CREATE TABLE medpract (id INTEGER PRIMARY KEY AUTOINCREMENT, hp TEXT, pn TEXT, ptype INTEGER, email TEXT, tel TEXT, regdate INTEGER)", // hp: health practitioner, pn: practice number
                                                                                                        // ptype: type (1:doctor,2:dietician,3:physio)
  ];

  DbUtil(this.dbName);

  Future<Database> createDb() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (kIsWeb || Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      //var db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    }
    return openDatabase(
        join(await getDatabasesPath(), dbName),
        onCreate: (db, version) async {
          int n = ddl.length;
          for (int i=0;i<n;i++) {
            await db.execute(ddl[i]);
          }
          // await db.execute(ddl[0]);
          // await db.execute(ddl[1]);
          // await db.execute(ddl[2]);
          // await db.execute(ddl[3]);

          // the following wouldn't work:
          // ddl.map(
          //         (sql) async => await db.execute(sql)
          // );
        },
        version: 1,
    );
  }

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await createDb();
    return _database;
  }

  Future<int> insert(String table, Map<String, Object> map) async {
    final db = await database;
    return await db!.insert(table, map, conflictAlgorithm: ConflictAlgorithm.replace,);
  }

  Future<void> insertBulk(String table, List<Map<String, Object>> mapList) async {
    final db = await database;
    return await db!.transaction((txn) async {
      int n = mapList.length;
      for (int i=0;i<n;i++) {
        await txn.insert(table, mapList[i], conflictAlgorithm: ConflictAlgorithm.replace,);
      }
    });
  }

  Future<List<Map<String, dynamic>>> selectAll(String table) async {
    final db = await database;
    return await db!.query(table);
  }

  Future<List<Map<String, dynamic>>> select(String table, {String? conds, List<Object?>? condVals, String? orderBy,}) async {
    final db = await database;
    if (conds != null && conds.isNotEmpty) {
      return await db!.query(table, where: conds, whereArgs: condVals);
    }
    return await db!.query(table);
  }

  Future<int> update(String table, Map<String, Object> map, String? conds, List<Object?>? condVals) async {
    final db = await database;
    return await db!.update(table, map, where: conds, whereArgs: condVals);
  }

  Future<int> delete(String table, String? conds, List<Object?>? condVals) async {
    final db = await database;
    return await db!.delete(table, where: conds, whereArgs: condVals);
  }
}
