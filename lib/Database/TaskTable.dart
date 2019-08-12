import 'package:sqflite/sql.dart';

import 'Provider.dart';
import 'Row.dart';

class TaskTable {
  static final _sqlTableName = 'Task';
  static Provider _provider;

  static addTable(Provider provider) {
    _provider = provider;
    provider.addTable(_sqlTableName, [
      Row('id', RowType.integer,
          isAutoIncrement: true, isPrimaryKey: true),
      Row('title', RowType.text),
      Row('startTime', RowType.text, isNullable: true),
      Row('endTime', RowType.text, isNullable: true),
      Row('description', RowType.text),
    ]);
  }

  static addOrEdit(Map<String, dynamic> task) {
    _provider.open();
    print(task);
    _provider.db.insert(_sqlTableName, task, conflictAlgorithm: ConflictAlgorithm.replace);
    _provider.close();
  }

  static queryTodayTasks() {
    final now = DateTime.now();
    final lastMidnight = new DateTime(now.year, now.month, now.day);

    try {
      _provider.open();

      return _provider.db.query(_sqlTableName,
          where: 'endTime < ?', whereArgs: [lastMidnight]);
    } catch (e) {
      print(e);
    } finally {
      _provider.close();
    }
  }
}
