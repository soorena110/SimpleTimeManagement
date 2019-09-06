import 'package:sqflite/sqflite.dart';
import 'package:time_river/Database/_common/Row.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/Tick.dart';

import '../../Provider.dart';

typedef StringCallBack = String Function();

abstract class TickBaseTable {
  String getSqlTableName();

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

  insertOrUpdate(Map<String, dynamic> json) async {
    print('ESC[36m ===> ${getSqlTableName()}.insertOrUpdate');
    print(json);

    json['lastUpdate'] = getNow();

    return await databaseProvider.db.insert(getSqlTableName(), json,
        conflictAlgorithm: ConflictAlgorithm.replace);
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
