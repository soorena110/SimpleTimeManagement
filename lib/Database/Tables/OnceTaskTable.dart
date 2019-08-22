import 'package:sqflite/sql.dart';
import 'package:time_river/Models/OnceTask.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:time_river/Database/_common/Row.dart';
import '../Provider.dart';

class OnceTaskTable {
  static final _sqlTableName = 'OnceTask';
  static Provider _provider;

  static init(Provider provider) {
    _provider = provider;
    provider.addTable(_sqlTableName, [
      Row('id', RowType.integer,
          isPrimaryKey: true, isAutoIncrement: true, isUnique: true),
      Row('name', RowType.text),
      Row('start', RowType.text, isNullable: true),
      Row('end', RowType.text, isNullable: true),
      Row('estimate', RowType.real, isNullable: true),
      Row('description', RowType.text, isNullable: true),

      Row('tick', RowType.text,
          defaultValue: StringToOnceTaskTick[OnceTaskTick.todo]),
      Row('tickDescription', RowType.text, isNullable: true),

      Row('lastUpdate', RowType.text),
    ]);
  }

  static insertOrUpdate(Map<String, dynamic> task) {
    print('ESC[33m ===> OnceTaskTable.insertOrUpdate');
    print(task);

    _provider.db.insert(_sqlTableName, task,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Iterable<OnceTask>> queryTodayTasks() async {
    print('ESC[36m ===> OnceTaskTable.queryTodayTasks');

    final now = DateTime.now();
    final d = Gregorian(now.year, now.month, now.day).toJalali();
    final start = '$d 00:00';
    final end = '$d 24:00';

    try {
      final result = await _provider.db.query(_sqlTableName,
          where: '(start IS NULL OR start >= "$start") '
              'AND (end IS NULL OR end <= "$end")');
      return result.map((r) => OnceTask.from(r));
    } catch (e) {
      print(e);
      return null;
    }
  }
}
