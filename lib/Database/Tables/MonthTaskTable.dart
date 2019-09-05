import 'package:time_river/Database/Provider.dart';
import 'package:time_river/Database/_common/Row.dart';

import 'LoopingTaskBaseTable.dart';
import 'TaskBaseTable.dart';

class _MonthTaskTable extends TaskBaseTable {

  @override
  String getSqlTableName() {
    return 'MonthTask';
  }

  initTable() {
    databaseProvider.addTable(getSqlTableName(), [
      ...LoopingTaskBaseTable.getCommonRowsInfo(),
      Row('dayOfMonth', RowType.integer, isNullable: false, isIndexed: true),
    ]);
  }

}

final monthTaskTable = _MonthTaskTable();