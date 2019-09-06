import 'package:sqflite/sqflite.dart';
import 'package:time_river/Database/_common/Row.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/Task.dart';

import '../../Provider.dart';

typedef StringCallBack = String Function();

abstract class TaskBaseTable {
  String getSqlTableName();

  void initTable();

  Future<Iterable<Task>> queryAllTasks() async {
    print('ESC[36m ===> ${getSqlTableName()}.queryAllTasks');

    try {
      return (await databaseProvider.db
          .query(getSqlTableName(), orderBy: 'lastUpdate DESC'))
          .map((r) => Task.fromJson(r));
    } catch (e) {
      print(e);
      return null;
    }
  }

  delete(int id) async {
    print('ESC[33m ===> ${getSqlTableName()}.delete $id');
    await databaseProvider.db.delete(getSqlTableName(), where: 'id = $id');
  }

  insertOrUpdate(Map<String, dynamic> task) async {
    print('ESC[33m ===> ${getSqlTableName()}.insertOrUpdate');
    print(task);

    task['lastUpdate'] = getNow();

    await databaseProvider.db.insert(getSqlTableName(), task,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  getDateCondition({String fromDate, String toDate}) {
    String condition = '';
    if (fromDate != null)
      condition += '(end IS NULL OR end >= "$fromDate")';
    if (toDate != null)
      condition += (condition != '' ? ' AND ' : '') +
          '(start IS NULL OR start <= "$toDate")';

    return condition;
  }

  static getCommonRowsInfo() {
    return [
      Row('id', RowType.integer,
          isPrimaryKey: true, isAutoIncrement: true, isUnique: true),
      Row('name', RowType.text),
      Row('start', RowType.text, isNullable: true, isIndexed: true),
      Row('end', RowType.text, isNullable: true, isIndexed: true),
      Row('estimate', RowType.real, isNullable: true),
      Row('description', RowType.text, isNullable: true),
      Row('lastUpdate', RowType.text, isIndexed: true),
    ];
  }
}
