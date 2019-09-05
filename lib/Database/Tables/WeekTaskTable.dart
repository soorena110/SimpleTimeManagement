import 'package:time_river/Database/_common/Row.dart';

import '../Provider.dart';
import 'LoopingTaskBaseTable.dart';
import 'TaskBaseTable.dart';

final weekDayNames = [
  'شنبه', 'یکشنبه', 'دوشنبه', 'سه‌شنبه', 'چهارشنبه', 'پنجشنبه', 'جمعه'
];

class _WeekTaskTable extends TaskBaseTable {
  @override
  String getSqlTableName() {
    return 'WeekTask';
  }

  initTable() {
    databaseProvider.addTable(getSqlTableName(), [
      ...LoopingTaskBaseTable.getCommonRowsInfo(),
      Row('weekdays', RowType.integer, isNullable: false, isIndexed: true),
    ]);
  }
}

final weekTaskTable = _WeekTaskTable();