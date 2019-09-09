import 'package:sqflite/sqflite.dart';
import 'package:time_river/Database/_common/Row.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Models/Tick.dart';

import '../../Provider.dart';

typedef StringCallBack = String Function();

abstract class TickBaseTable {
  String getSqlTableName();

  TaskType getTaskType();

  void initTable();

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
        .query(getSqlTableName(), where: condition != '' ? condition : null);

    return query.map((json) => Tick.fromJson(json, getTaskType()));
  }

  insertOrUpdate(Map<String, dynamic> json) async {
    print('ESC[36m ===> ${getSqlTableName()}.insertOrUpdate');
    print(json);

    json['lastUpdate'] = getNow();

    return await databaseProvider.db.insert(getSqlTableName(), json,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteForTaskId(int taskId) async {
    print('ESC[33m ===> ${getSqlTableName()}.deleteForTaskId taskId=$taskId');
    return await databaseProvider.db
        .delete(getSqlTableName(), where: 'taskId = $taskId');
  }

  static List<Row> getCommonRowsInfo() {
    return [
      Row('id', RowType.integer,
          isPrimaryKey: true, isAutoIncrement: true, isUnique: true),
      Row('taskId', RowType.integer, isNullable: false, isIndexed: true),
      Row('type', RowType.integer, isNullable: false, isIndexed: true),
      Row('description', RowType.text, isNullable: true),
      Row('lastUpdate', RowType.text, isIndexed: true, isNullable: false),
    ];
  }
}
