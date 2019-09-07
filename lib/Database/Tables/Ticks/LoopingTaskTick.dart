import 'package:time_river/Database/_common/Row.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Models/Tick.dart';

import '../../Provider.dart';
import 'TickBaseTable.dart';

abstract class LoopingTaskTick extends TickBaseTable {
  Future<Iterable<Tick>> queryForTaskIdAndTypeAndDay(
      {Iterable<int> taskIds,
        Iterable<TickType> types}) async {
    String condition =
        super.getConditionForIdsAndTypes(taskIds: taskIds, types: types);

    final query = await databaseProvider.db
        .query(getSqlTableName(), where: condition != '' ? condition : null);

    return query.map((json) => Tick.fromJson(json, TaskType.once));
  }

  static List<Row> getCommonRowsInfo() {
    return [
      ...TickBaseTable.getCommonRowsInfo()
    ];
  }
}
