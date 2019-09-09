import 'package:time_river/Models/Task.dart';

import '../../Provider.dart';
import 'TickBaseTable.dart';

class _OnceTaskTickTable extends TickBaseTable {
  @override
  String getSqlTableName() => 'OnceTaskTick';

  @override
  TaskType getTaskType() => TaskType.once;

  @override
  initTable() {
    databaseProvider.addTable(
        getSqlTableName(), TickBaseTable.getCommonRowsInfo());
  }
}

final onceTaskTickTable = _OnceTaskTickTable();
