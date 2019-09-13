import 'package:time_river/Database/Tables/TableBase.dart';
import 'package:time_river/Database/_common/Row.dart';
import 'package:time_river/Models/Task.dart';

import '../Provider.dart';

class _TaskTable extends TableBase {
  @override
  get tableName => "Tasks";

  @override
  get columnsInfo =>
      [
        Row('id', RowType.integer,
            isPrimaryKey: true,
            isAutoIncrement: true,
            isUnique: true,
            isNullable: true),
        Row('name', RowType.text),
        Row('start', RowType.text, isNullable: true, isIndexed: true),
        Row('end', RowType.text, isNullable: true, isIndexed: true),
        Row('estimate', RowType.real, isNullable: true),
        Row('description', RowType.text, isNullable: true),

        // week ↓
        Row('weekdays', RowType.integer, isNullable: true, isIndexed: true),

        // month ↓
        Row('monthday', RowType.integer, isNullable: true, isIndexed: true),

        // week or month↓
        Row('startHour', RowType.text, isNullable: true),
        Row('endHour', RowType.text, isNullable: true),

        Row('type', RowType.integer, isNullable: false, isIndexed: true),
        Row('lastUpdate', RowType.text, isNullable: false, isIndexed: true),
      ];

  Future<Iterable<Task>> getAllTasksUpdatedAfter(String lastUpdate) async =>
      (await queryAllRowsUpdatedAfter(lastUpdate)).map((r) => Task.fromJson(r));

  Future<Iterable<Task>> query({String fromDate,
    String toDate,
    TaskType type,
    bool orderLastUpdateOrderAsc = false}) async {
    print('ESC[36m ===> $tableName.queryAllTasks');

    databaseProvider.open();
    return (await databaseProvider.db.query(tableName,
        where: getDateCondition(
            fromDate: fromDate, toDate: toDate, type: type),
        orderBy: 'lastUpdate ${orderLastUpdateOrderAsc ? '' : 'DESC'}'))
        .map((r) => Task.fromJson(r));
  }

  getDateCondition({String fromDate, String toDate, TaskType type}) {
    String condition = '';
    if (fromDate != null) condition += '(end IS NULL OR end >= "$fromDate")';

    if (toDate != null)
      condition += (condition != '' ? ' AND ' : '') +
          '(start IS NULL OR start <= "$toDate")';

    if (type != null)
      condition += (condition != '' ? ' AND ' : '') +
          'type = ${TaskType.values.indexOf(type)}';

    if (condition == '') return null;
    return condition;
  }
}

final taskTable = _TaskTable();
