import 'package:sqflite/sql.dart';
import 'package:time_river/Models/Task.dart';

import 'Provider.dart';
import 'Row.dart';

class TaskTable {
  static final _sqlTableName = 'Task';
  static Provider _provider;

  static addTable(Provider provider) {
    _provider = provider;
    provider.addTable(_sqlTableName, [
      Row('id', RowType.integer, isAutoIncrement: true, isPrimaryKey: true),
      Row('name', RowType.text),
      Row('start', RowType.text, isNullable: true),
      Row('end', RowType.text, isNullable: true),
      Row('description', RowType.text, isNullable: true),
    ]);
  }

  static addOrEdit(Map<String, dynamic> task) {
    _provider.db.insert(_sqlTableName, task,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Task>> queryTodayTasks() async {
    final now = DateTime.now();
    final lastMidnight = new DateTime(now.year, now.month, now.day);

    try {
      var result = await _provider.db.query(_sqlTableName);
//          where: 'endTime < ?', whereArgs: [lastMidnight]);
      return result.map((r) => Task.from(r)).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
