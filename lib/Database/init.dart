import 'package:time_river/Database/Provider.dart';

import 'Tables/Tasks/MonthTaskTable.dart';
import 'Tables/Tasks/OnceTaskTable.dart';
import 'Tables/Tasks/WeekTaskTable.dart';
import 'Tables/Ticks/MonthTaskTick.dart';
import 'Tables/Ticks/OnceTaskTick.dart';
import 'Tables/Ticks/WeekTaskTick.dart';

databaseClose() async {
  await databaseProvider.close();
}

databaseOpen() async {
  onceTaskTable.initTable();
  onceTaskTickTable.initTable();

  weekTaskTable.initTable();
  weekTaskTickTable.initTable();

  monthTaskTable.initTable();
  monthTaskTickTable.initTable();

  await databaseProvider.open();
}
