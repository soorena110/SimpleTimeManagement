import 'package:time_river/Database/Tables/Tasks/MonthTaskTable.dart';
import 'package:time_river/Database/Tables/Tasks/OnceTaskTable.dart';
import 'package:time_river/Database/Tables/Tasks/WeekTaskTable.dart';
import 'package:time_river/Database/Tables/Ticks/MonthTaskTick.dart';
import 'package:time_river/Database/Tables/Ticks/OnceTaskTick.dart';
import 'package:time_river/Database/Tables/Ticks/TickBaseTable.dart';
import 'package:time_river/Database/Tables/Ticks/WeekTaskTick.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Models/Tick.dart';

class TaskService {
  static saveTick(Tick tick) async {
    final tickTable = _getRelatedTickRepositoryOfType(tick.taskType);
    tick.id = await tickTable.insertOrUpdate(tick.toJson());
  }

  static Future<Iterable<Task>> getOnceTasksWhere(
      {List<TickType> tickTypes, String fromDate, String toDate}) async {
    List<Task> tasks = (await onceTaskTable.query(
        fromDate: fromDate, toDate: toDate, lastUpdateOrderAsc: true))
        .toList();

    return await _addOnceTicksToTasks(tasks);
  }

  static Future<Iterable<Task>> getAllTasksOfType(TaskType type,
      {List<TickType> tickType}) {
    switch (type) {
      case TaskType.once:
        return getOnceTasksWhere(tickTypes: tickType);
      case TaskType.week:
        return _getAllWeekTasksWithTheirTicks(
            tickType: tickType, day: getNowDate());
      case TaskType.month:
        return _getAllMonthTasksWithTheirTicks(
            tickType: tickType, day: getNowDate());
      default:
        throw 'Exhuastive check';
    }
  }

  static Future<Iterable<Task>> _getAllWeekTasksWithTheirTicks(
      {List<TickType> tickType,
      String day,
      String fromDay,
      String toDay}) async {
    final tasks = (await weekTaskTable.query()).toList();

    final ticksDict = <int, Tick>{};
    final ticks = await weekTaskTickTable.queryForTaskIdAndTypeAndDay(
        taskIds: tasks.map((r) => r.id),
        types: tickType,
        day: day,
        fromDay: fromDay,
        toDay: toDay);
    ticks.forEach((tick) => ticksDict[tick.taskId] = tick);

    tasks.forEach((task) {
      task.type = TaskType.week;
      task.tick = ticksDict[task.id];
    });

    return tasks;
  }

  static Future<Iterable<Task>> _getAllMonthTasksWithTheirTicks(
      {List<TickType> tickType,
      String day,
      String fromDay,
      String toDay}) async {
    final tasks = (await monthTaskTable.query()).toList();

    final ticksDict = <int, Tick>{};
    final ticks = await monthTaskTickTable.queryForTaskIdAndTypeAndDay(
        taskIds: tasks.map((r) => r.id),
        types: tickType,
        day: day,
        fromDay: fromDay,
        toDay: toDay);
    ticks.forEach((tick) => ticksDict[tick.taskId] = tick);

    tasks.forEach((task) {
      task.type = TaskType.month;
      task.tick = ticksDict[task.id];
    });

    return tasks;
  }
}

Future<List<Task>> _addOnceTicksToTasks(List<Task> tasks,
    {List<TickType> tickType}) async {
  final ticksDict = <int, Tick>{};
  final ticks = await onceTaskTickTable.queryForTaskIdAndType(
      taskIds: tasks.map((r) => r.id), types: tickType);
  ticks.forEach((tick) => ticksDict[tick.taskId] = tick);

  tasks.forEach((task) {
    task.type = TaskType.once;
    task.tick = ticksDict[task.id];
  });

  return tasks;
}

TickBaseTable _getRelatedTickRepositoryOfType(TaskType type) {
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
