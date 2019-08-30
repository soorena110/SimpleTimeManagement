import 'package:time_river/Database/_common/Row.dart';

class TaskBaseTable {
  static getCommonRowsInfo() {
    return [
      Row('id', RowType.integer,
          isPrimaryKey: true, isAutoIncrement: true, isUnique: true),
      Row('name', RowType.text),
      Row('start', RowType.text, isNullable: true, isIndexed: true),
      Row('end', RowType.text, isNullable: true, isIndexed: true),
      Row('estimate', RowType.real, isNullable: true),
      Row('description', RowType.text, isNullable: true),
      Row('lastUpdate', RowType.text, isIndexed: true),
    ];
  }
}
