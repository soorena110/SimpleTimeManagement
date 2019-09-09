import 'package:time_river/Database/_common/Row.dart';
import 'package:time_river/Models/Task.dart';

import '../../Provider.dart';
import 'LoopingTaskTick.dart';

class _WeekTaskTickTable extends LoopingTaskTick {
  @override
  String getSqlTableName() => 'WeekTaskTick';

  @override
  TaskType getTaskType() => TaskType.week;

  @override
  initTable() {
    databaseProvider.addTable(getSqlTableName(), [
      ...LoopingTaskTick.getCommonRowsInfo(),
      Row('day', RowType.text, isIndexed: true, isNullable: false)
    ]);
  }
}

final weekTaskTickTable = _WeekTaskTickTable();
