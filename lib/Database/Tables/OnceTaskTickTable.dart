import 'package:sqflite/sql.dart';
import 'package:time_river/Database/_common/Row.dart';
import 'package:time_river/Models/OnceTaskTick.dart';
import '../Provider.dart';

class OnceTaskTickTable {
  static final _sqlTableName = 'OnceTaskTick';
  static Provider _provider;

  static init(Provider provider) {
    _provider = provider;

    const uniquesFields = const ['onceTaskId'];
    var rows = [
      Row('id', RowType.integer,
          isPrimaryKey: true, isAutoIncrement: true, isUnique: true),
      Row('onceTaskId', RowType.integer),
      Row('status', RowType.text),
      Row('description', RowType.text, isNullable: true),
      Row('lastUpdate', RowType.text),
    ];

    provider.addTable(_sqlTableName, rows, uniquesFields: uniquesFields);
  }

  static insertOrUpdate(Map<String, dynamic> task) {
    _provider.db.insert(_sqlTableName, task,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<OnceTaskTick>> query(
      List<int> ids, List<OnceTaskTickStatus> statuses) async {
    var statusesNames = statuses.map((s) => statusesNamesMap[s]);

    try {
      var result = await _provider.db.query(_sqlTableName,
          where: 'onceTaskId IN (${ids.join(',')})'
              ' AND onceTaskTickStatus IN (${statusesNames.join(',')})');
      return result.map((r) => OnceTaskTick.from(r)).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
