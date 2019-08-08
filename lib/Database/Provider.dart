import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const dbName = 'timeManagement.db';

class Provider {
  Database _db;
  final int _version = 1;
  final List<String> _registeredInitSqls = [];

  open() async {
    String path = join(await getDatabasesPath(), dbName);
    _db = await openDatabase(path, version: _version, onCreate: _onCreate);

  }

  close()async => await _db.close();

  _onCreate(Database db, int version) async {
    for (var i = 0; i < _registeredInitSqls.length; i++) {
      var sql = _registeredInitSqls[i];
      await db.execute(sql);
    }
  }

  registerInitSql(String sql) {
    _registeredInitSqls.add(sql);
  }

  createTable(String name, List<Row> rows) {
    var sql = Table(name, rows).toString();
    registerInitSql(sql);
  }
}

class Table {
  final String name;
  final List<Row> rows;

  Table(this.name, this.rows);

  @override
  String toString() {
    return 'CREATE TABLE $name (${rows.map((r) => r.toString).join(',\n')})';
  }
}

class Row {
  final String name;
  final RowType type;
  final bool isPrimaryKey;
  final bool isAutoIncrement;
  final bool isNotNull;

  Row(this.name, this.type,
      {this.isAutoIncrement, this.isNotNull, this.isPrimaryKey});

  @override
  String toString() {
    return '$name ${type.toString().toUpperCase()}' +
        (isPrimaryKey ? ' PRIMARY KEY' : '') +
        (isAutoIncrement ? ' AUTOINCREMENT' : '') +
        (isNotNull ? ' NOT NULL' : '');
  }
}

enum RowType { integer, text }
