import 'package:time_river/Database/_common/Row.dart';

import '../../Provider.dart';
import 'LoopingTaskTick.dart';

class _WeekTaskTickTable extends LoopingTaskTick {
  @override
  String getSqlTableName() {
    return 'WeekTaskTick';
  }

  @override
  initTable() {
    databaseProvider.addTable(getSqlTableName(), [
      ...LoopingTaskTick.getCommonRowsInfo(),
      Row('day', RowType.text, isIndexed: true, isNullable: false)
    ]);
  }
}

final weekTaskTickTable = _WeekTaskTickTable();
