import 'package:time_river/Database/Tables/TaskBaseTable.dart';
import 'package:time_river/Database/_common/Row.dart';

typedef StringCallBack = String Function();

abstract class LoopingTaskBaseTable {
  static getCommonRowsInfo() {
    return [
      ...TaskBaseTable.getCommonRowsInfo(),
      Row('startHour', RowType.text),
      Row('endHour', RowType.text)
    ];
  }
}
