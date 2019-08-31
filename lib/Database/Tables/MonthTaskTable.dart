import 'package:time_river/Database/_common/Row.dart';

import '../Provider.dart';
import 'TaskBaseTable.dart';

class WeekTaskTable {
  static final _sqlTableName = 'WeekTask';
  static Provider _provider;

  static init(Provider provider) {
    _provider = provider;

    provider.addTable(_sqlTableName, [
      ...TaskBaseTable.getCommonRowsInfo(),
      Row('dayOfMonth', RowType.integer, isNullable: false, isIndexed: true),
      Row('hour', RowType.text)
    ]);
  }
}
