import 'package:sqflite/sqflite.dart';
import 'package:time_river/Database/_common/Row.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Models/Tick.dart';

import '../../Provider.dart';

String tableName = 'Ticks';
final columnsInfo = [
  Row('id', RowType.integer,
      isPrimaryKey: true, isAutoIncrement: true, isUnique: true),
  Row('taskId', RowType.integer, isNullable: false, isIndexed: true),
  Row('type', RowType.integer, isNullable: false, isIndexed: true),
  Row('description', RowType.text, isNullable: true),

  // week ↓
  Row('day', RowType.text, isIndexed: true, isNullable: false),

  // month ↓
  Row('month', RowType.text, isIndexed: true, isNullable: false),

  Row('taskType', RowType.integer, isNullable: false, isIndexed: true),
  Row('lastUpdate', RowType.text, isIndexed: true, isNullable: false),
];

class _TickBaseTable {
  Future<Iterable<Task>> getAllTicksUpdatedAfter(String lastUpdate) async {
    try {
      return (await databaseProvider.db.query(
        tableName,
        where: 'lastUpdate > "$lastUpdate"',
      ))
          .map((r) => Task.fromJson(r));
    } catch (e) {
      if (e.toString() == 'DatabaseException(error database_closed)')
        databaseProvider.open();
      return [];
    }
  }

  getConditionForIdsAndTypes(
      {Iterable<int> taskIds, Iterable<TickType> types}) {
    String condition = '';
    if (taskIds != null) condition = 'taskId IN (${taskIds.join(',')})';
    if (types != null) {
      if (condition != '') condition += ' AND ';
      condition +=
      'type in (${types.map((t) => TickType.values.indexOf(t)).join(',')})';
    }

    return condition;
  }

  Future<Iterable<Tick>> queryForTaskIdAndTypeAndDay(
      {Iterable<int> taskIds, Iterable<TickType> types}) async {
    String condition =
    getConditionForIdsAndTypes(taskIds: taskIds, types: types);

    final query = await databaseProvider.db
        .query(tableName, where: condition != '' ? condition : null);

    return query.map((json) => Tick.fromJson(json));
  }


  insertOrUpdate(Map<String, dynamic> json) async {
    print('ESC[36m ===> $tableName.insertOrUpdate');
    print(json);

    json['lastUpdate'] = getNow();

    return await databaseProvider.db
        .insert(tableName, json, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteForTaskId(int taskId) async {
    print('ESC[33m ===> $tableName.deleteForTaskId taskId=$taskId');
    return await databaseProvider.db
        .delete(tableName, where: 'taskId = $taskId');
  }

  initTable() {
    databaseProvider.addTable(tableName, columnsInfo);
  }
}

final tickTable = _TickBaseTable();
