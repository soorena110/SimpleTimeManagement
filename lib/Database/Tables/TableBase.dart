import 'package:sqflite/sqflite.dart';
import 'package:time_river/Database/_common/Row.dart';
import 'package:time_river/Libraries/datetime.dart';

import '../Provider.dart';

abstract class TableBase {
  String get tableName;

  List<Row> get columnsInfo;

  initTable() {
    databaseProvider.addTable(tableName, columnsInfo);
  }

  Future<Iterable<Map<String, dynamic>>> queryAllRowsUpdatedAfter(
      String lastUpdate) async {
    await databaseProvider.open();
    return await databaseProvider.db
        .query(tableName, where: 'lastUpdate > "$lastUpdate"');
  }

  insertOrUpdate(Map<String, dynamic> json) async {
    print('ESC[36m ===> $tableName.insertOrUpdate');
    print(json);

    json['lastUpdate'] = getNow();

    await databaseProvider.open();
    return await databaseProvider.db
        .insert(tableName, json, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> delete(int id) async {
    print('ESC[33m ===> $tableName.delete $id');

    databaseProvider.open();
    return await databaseProvider.db.delete(tableName, where: 'id = $id');
  }
}
