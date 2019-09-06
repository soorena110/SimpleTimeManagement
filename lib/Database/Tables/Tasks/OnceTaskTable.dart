import 'package:time_river/Models/Task.dart';

import '../../Provider.dart';
import 'TaskBaseTable.dart';

class _OnceTaskTable extends TaskBaseTable {
  @override
  String getSqlTableName() {
    return 'OnceTask';
  }

  initTable() {
    databaseProvider.addTable(
        getSqlTableName(), TaskBaseTable.getCommonRowsInfo());
  }

  Future<Iterable<Task>> queryTaskWhere(
      {String fromDate, String toDate}) async {
    print('ESC[36m ===> OnceTaskTable.queryTaskWhere');

    try {
      return (await databaseProvider.db.query(getSqlTableName(),
          where: getDateCondition(fromDate: fromDate, toDate: toDate)))
          .map((r) => Task.fromJson(r));
    } catch (e) {
      print(e);
      return null;
    }
  }
}

final onceTaskTable = _OnceTaskTable();
