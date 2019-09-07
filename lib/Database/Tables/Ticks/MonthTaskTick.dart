import 'package:time_river/Database/_common/Row.dart';

import '../../Provider.dart';
import 'LoopingTaskTick.dart';

class _MonthTaskTickTable extends LoopingTaskTick {
  @override
  String getSqlTableName() {
    return 'MonthTaskTick';
  }

  @override
  initTable() {
    databaseProvider.addTable(getSqlTableName(), [
      ...LoopingTaskTick.getCommonRowsInfo(),
      Row('month', RowType.text, isIndexed: true, isNullable: false)
    ]);
  }
}

final monthTaskTickTable = _MonthTaskTickTable();
