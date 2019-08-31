import 'package:sqflite/sql.dart';
import 'package:time_river/Database/Tables/TaskBaseTable.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/OnceTask.dart';

import '../Provider.dart';

class OnceTaskTable {
  static final _sqlTableName = 'OnceTask';
  static Provider _provider;

  static init(Provider provider) {
    _provider = provider;
    provider.addTable(_sqlTableName, TaskBaseTable.getCommonRowsInfo());
  }

  static insertOrUpdate(Map<String, dynamic> task) {
    print('ESC[33m ===> OnceTaskTable.insertOrUpdate');
    print(task);

    task['lastUpdate'] = getNow();

    _provider.db.insert(_sqlTableName, task,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Iterable<OnceTask>> queryAllTasks() async {
    print('ESC[36m ===> OnceTaskTable.queryAllTasks');

    try {
      final result = await _provider.db.query(_sqlTableName);
      return result.map((r) => OnceTask.fromJson(r));
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Iterable<OnceTask>> queryTasksBetweenDates(String start,
      String end) async {
    print('ESC[36m ===> OnceTaskTable.queryTodayTasks');

    try {
      final result = await _provider.db.query(_sqlTableName,
          where: 'start IS NULL OR end <= "$end" OR start > "$start"');
      return result.map((r) => OnceTask.fromJson(r));
    } catch (e) {
      print(e);
      return null;
    }
  }
}
