import '../../Provider.dart';
import 'LoopingTaskTick.dart';

class _MonthTaskTickTable extends LoopingTaskTick {
  @override
  String getSqlTableName() {
    return 'MonthTaskTick';
  }

  @override
  initTable() {
    databaseProvider.addTable(
        getSqlTableName(), LoopingTaskTick.getCommonRowsInfo());
  }
}

final monthTaskTickTable = _MonthTaskTickTable();
