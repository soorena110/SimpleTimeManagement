import 'package:time_river/Database/_common/Row.dart';

import 'TickBaseTable.dart';

abstract class LoopingTaskTick extends TickBaseTable {
  static List<Row> getCommonRowsInfo() {
    return [
      ...TickBaseTable.getCommonRowsInfo()
    ];
  }
}
