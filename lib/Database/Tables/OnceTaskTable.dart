import 'package:time_river/Database/Tables/TaskBaseTable.dart';
import 'package:time_river/Models/OnceTask.dart';

import '../Provider.dart';

class _OnceTaskTable extends TaskBaseTable {

  @override
  String getSqlTableName() {
    return 'OnceTask';
  }

  initTable() {
    databaseProvider.addTable(
        getSqlTableName(), TaskBaseTable.getCommonRowsInfo());
  }

  Future<Iterable<OnceTask>> queryTasksBetweenDates(
      String start, String end) async {
    print('ESC[36m ===> OnceTaskTable.queryTodayTasks');

    try {
      final result = await databaseProvider.db.query(getSqlTableName(),
          where: 'start IS NULL OR end <= "$end" OR start > "$start"');
      return result.map((r) => OnceTask.fromJson(r));
    } catch (e) {
      print(e);
      return null;
    }
  }
}

final onceTaskTable = _OnceTaskTable();
