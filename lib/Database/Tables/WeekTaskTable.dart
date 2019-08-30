import 'package:sqflite/sql.dart';
import 'package:time_river/Database/_common/Row.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/WeekTask.dart';

import '../Provider.dart';
import 'TaskBaseTable.dart';

class WeekTaskTable {
  static final _sqlTableName = 'WeekTask';
  static Provider _provider;

  static init(Provider provider) {
    _provider = provider;

    provider.addTable(_sqlTableName, [
      ...TaskBaseTable.getCommonRowsInfo(),
      Row('weekday', RowType.integer, isNullable: false, isIndexed: true),
      Row('hour', RowType.text)
    ]);
  }

  static insertOrUpdate(Map<String, dynamic> task) {
    print('ESC[33m ===> WeekTaskTable.insertOrUpdate');
    print(task);

    task['lastUpdate'] = getNow();

    _provider.db.insert(_sqlTableName, task,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Iterable<WeekTask>> queryAllTasks() async {
    print('ESC[36m ===> WeekTaskTable.queryAllTasks');

    try {
      final result = await _provider.db.query(_sqlTableName);
      return result.map((r) => WeekTask.fromJson(r));
    } catch (e) {
      print(e);
      return null;
    }
  }
}
