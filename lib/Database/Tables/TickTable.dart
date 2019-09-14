import 'package:time_river/Database/_common/Row.dart';
import 'package:time_river/Models/Tick.dart';

import '../Provider.dart';
import 'TableBase.dart';

class _TickTable extends TableBase {
  @override
  get tableName => 'Ticks';

  @override
  get columnsInfo =>
      [
        Row('id', RowType.integer,
            isNullable: false,
            isPrimaryKey: true,
            isAutoIncrement: true,
            isUnique: true),
        Row('taskId', RowType.integer, isNullable: false, isIndexed: true),
        Row('type', RowType.integer, isNullable: false, isIndexed: true),
        Row('description', RowType.text, isNullable: true),
        Row('taskType', RowType.integer, isNullable: false, isIndexed: true),

        // week ↓
        Row('day', RowType.text, isIndexed: true, isNullable: true),

        // month ↓
        Row('month', RowType.text, isIndexed: true, isNullable: true),

        Row('postponeEnd', RowType.text, isNullable: true, isIndexed: true),
        Row('lastUpdate', RowType.text, isIndexed: true, isNullable: false),
      ];

  Future<Iterable<Tick>> getAllTicksUpdatedAfter(String lastUpdate) async =>
      (await queryAllRowsUpdatedAfter(lastUpdate)).map((r) => Tick.fromJson(r));

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

    await databaseProvider.open();
    final query = await databaseProvider.db
        .query(tableName, where: condition != '' ? condition : null);

    return query.map((json) => Tick.fromJson(json));
  }

  Future<int> deleteForTaskId(int taskId) async {
    print('ESC[33m ===> $tableName.deleteForTaskId taskId=$taskId');

    databaseProvider.open();
    return await databaseProvider.db
        .delete(tableName, where: 'taskId = $taskId');
  }
}

final tickTable = _TickTable();
