import 'package:time_river/Database/Provider.dart';

import 'Tables/TaskTable.dart';
import 'Tables/TickTable.dart';

databaseClose() async {
  await databaseProvider.close();
}

databaseOpen() async {
  taskTable.initTable();
  tickTable.initTable();

  await databaseProvider.open();
}
