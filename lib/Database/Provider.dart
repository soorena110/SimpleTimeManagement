import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:time_river/Database/_common/Row.dart';
import 'package:time_river/Database/_common/Table.dart';

const dbName = 'timeManagement.db';

class Provider {
  Database db;
  final int _version = 1;
  final List<String> _registeredInitSqls = [];

  open() async {
    String path = join(await getDatabasesPath(), dbName);
    db = await openDatabase(path, version: _version, onCreate: _onCreate);
  }

  close() async {
    await db.close();
  }

  _onCreate(Database db, int version) async {
    for (var i = 0; i < _registeredInitSqls.length; i++) {
      var sql = _registeredInitSqls[i];
      print('====>>> ' + sql);
      await db.execute(sql);
    }
  }

  registerInitSql(String sql) {
    _registeredInitSqls.add(sql);
  }

  addTable(String name, List<Row> rows,
      {List<String> uniquesFields = const [], bool ifNotExists}) {
    var sql = Table(name, rows, uniquesFields: uniquesFields).toString();
    registerInitSql(sql);
  }
}
