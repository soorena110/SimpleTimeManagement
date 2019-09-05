import 'package:sqflite/sql.dart';
import 'package:time_river/Database/_common/Row.dart';
import 'package:time_river/Libraries/datetime.dart';

import '../Provider.dart';
import 'TaskBaseTable.dart';

class _WeekTaskTable extends TaskBaseTable {
  @override
  String getSqlTableName() {
    return 'WeekTask';
  }

  initTable() {
    databaseProvider.addTable(getSqlTableName(), [
      ...TaskBaseTable.getCommonRowsInfo(),
      Row('weekday', RowType.integer, isNullable: false, isIndexed: true),
      Row('hour', RowType.text)
    ]);
  }

  insertOrUpdate(Map<String, dynamic> task) {
    print('ESC[33m ===> WeekTaskTable.insertOrUpdate');
    print(task);

    task['lastUpdate'] = getNow();

    databaseProvider.db.insert(getSqlTableName(), task,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

final weekTaskTable = _WeekTaskTable();