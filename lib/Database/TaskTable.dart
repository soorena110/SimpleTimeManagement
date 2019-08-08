import 'Provider.dart';

class TaskTable {
  static createTable(Provider provider) {
    provider.createTable('Task', [
      Row('id', RowType.integer,
          isAutoIncrement: true,
          isNotNull: true,
          isPrimaryKey: true),
      Row('title', RowType.text, isNotNull: true),
      Row('start', RowType.text, isNotNull: true),
    ]);
  }
}
