import 'package:sqflite/sql.dart';
import 'package:time_river/Models/OnceTask.dart';
import 'package:time_river/Database/_common/Row.dart';
import 'package:time_river/Models/OnceTaskTick.dart';
import '../Provider.dart';

class OnceTaskTickTable {
  static final _sqlTableName = 'Task';
  static Provider _provider;

  static init(Provider provider) {
    _provider = provider;

    const uniquesFields = const ['onceTaskId'];
    var rows = [
      Row('id', RowType.integer, isPrimaryKey: true),
      Row('onceTaskId', RowType.integer),
      Row('onceTaskTickStatus', RowType.integer),
      Row('description', RowType.text, isNullable: true),
    ];

    provider.addTable(_sqlTableName, rows, uniquesFields: uniquesFields);
  }

  static insertOrUpdate(Map<String, dynamic> task) {
    _provider.db.insert(_sqlTableName, task,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<OnceTask>> queryByTaskId(
      List<int> ids, List<OnceTaskTickStatus> statuses) async {
    try {
      var result = await _provider.db.query(_sqlTableName,
          where: 'onceTaskId IN (${ids.join(',')})'
              ' AND onceTaskTickStatus IN (${statuses.join(',')})');
      return result.map((r) => OnceTask.from(r)).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
