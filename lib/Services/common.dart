import 'package:time_river/Database/Tables/Tasks/MonthTaskTable.dart';
import 'package:time_river/Database/Tables/Tasks/OnceTaskTable.dart';
import 'package:time_river/Database/Tables/Tasks/TaskBaseTable.dart';
import 'package:time_river/Database/Tables/Tasks/WeekTaskTable.dart';
import 'package:time_river/Database/Tables/Ticks/MonthTaskTick.dart';
import 'package:time_river/Database/Tables/Ticks/OnceTaskTick.dart';
import 'package:time_river/Database/Tables/Ticks/TickBaseTable.dart';
import 'package:time_river/Database/Tables/Ticks/WeekTaskTick.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Models/Tick.dart';

Map<int, List<Tick>> groupTicks(Iterable<Tick> ticks) {
  final ticksDict = <int, List<Tick>>{};
  ticks.forEach((tick) {
    if (ticksDict[tick.taskId] == null)
      ticksDict[tick.taskId] = [tick];
    else
      ticksDict[tick.taskId].add(tick);
  });
  return ticksDict;
}

Task cloneTask(Task task) {
  return Task.fromJson(task.toJson())..type = task.type;
}

TickBaseTable getRelatedTickRepositoryOfType(TaskType type) {
  switch (type) {
    case TaskType.once:
      return onceTaskTickTable;
    case TaskType.week:
      return weekTaskTickTable;
    case TaskType.month:
      return monthTaskTickTable;
  }
  return null;
}

TaskBaseTable getRelatedRepositoryOfType(TaskType type) {
  switch (type) {
    case TaskType.once:
      return onceTaskTable;
    case TaskType.week:
      return weekTaskTable;
    case TaskType.month:
      return monthTaskTable;
  }
  return null;
}
