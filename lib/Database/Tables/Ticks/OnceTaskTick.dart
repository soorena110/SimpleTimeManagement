import 'package:time_river/Models/Task.dart';
import 'package:time_river/Models/Tick.dart';

import '../../Provider.dart';
import 'TickBaseTable.dart';

class _OnceTaskTickTable extends TickBaseTable {
  @override
  String getSqlTableName() {
    return 'OnceTaskTick';
  }

  @override
  initTable() {
    databaseProvider.addTable(
        getSqlTableName(), TickBaseTable.getCommonRowsInfo());
  }

  Future<Iterable<Tick>> queryForTaskIdAndType(
      {Iterable<int> taskIds, Iterable<TickType> types}) async {
    final condition =
        super.getConditionForIdsAndTypes(taskIds: taskIds, types: types);
    final query = await databaseProvider.db
        .query(getSqlTableName(), where: condition != '' ? condition : null);

    return query.map((json) => Tick.fromJson(json, TaskType.once));
  }
}

final onceTaskTickTable = _OnceTaskTickTable();
