import 'package:time_river/Database/Provider.dart';
import 'package:time_river/Database/_common/Row.dart';

import 'TaskBaseTable.dart';

class _MonthTaskTable extends TaskBaseTable {

  @override
  String getSqlTableName() {
    return 'MonthTask';
  }

  initTable() {
    databaseProvider.addTable(getSqlTableName(), [
      ...TaskBaseTable.getCommonRowsInfo(),
      Row('dayOfMonth', RowType.integer, isNullable: false, isIndexed: true),
      Row('hour', RowType.text)
    ]);
  }

}

final monthTaskTable = _MonthTaskTable();