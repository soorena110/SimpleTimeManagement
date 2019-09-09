import 'package:time_river/Database/_common/Row.dart';
import 'package:time_river/Models/Task.dart';

import '../../Provider.dart';
import 'LoopingTaskTick.dart';

class _MonthTaskTickTable extends LoopingTaskTick {
  @override
  String getSqlTableName() => 'MonthTaskTick';

  @override
  TaskType getTaskType() => TaskType.month;

  @override
  initTable() {
    databaseProvider.addTable(getSqlTableName(), [
      ...LoopingTaskTick.getCommonRowsInfo(),
      Row('month', RowType.text, isIndexed: true, isNullable: false)
    ]);
  }
}

final monthTaskTickTable = _MonthTaskTickTable();
