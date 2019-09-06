import '../../Provider.dart';
import 'TaskBaseTable.dart';

class _OnceTaskTable extends TaskBaseTable {
  @override
  String getSqlTableName() {
    return 'OnceTask';
  }

  initTable() {
    databaseProvider.addTable(
        getSqlTableName(), TaskBaseTable.getCommonRowsInfo());
  }
}

final onceTaskTable = _OnceTaskTable();
