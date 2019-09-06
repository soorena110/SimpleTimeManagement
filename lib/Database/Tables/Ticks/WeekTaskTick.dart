import '../../Provider.dart';
import 'LoopingTaskTick.dart';

class _WeekTaskTickTable extends LoopingTaskTick {
  @override
  String getSqlTableName() {
    return 'WeekTaskTick';
  }

  @override
  initTable() {
    databaseProvider.addTable(
        getSqlTableName(), LoopingTaskTick.getCommonRowsInfo());
  }
}

final weekTaskTickTable = _WeekTaskTickTable();
