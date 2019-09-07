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

  static Future<Iterable<Task>> getTaskWhere(
      {String fromDate, String toDate}) async {
    final onceTasks =
    await getOnceTasksWithTheirTicks(fromDate: fromDate, toDate: toDate);

    final monthTask = await _getAllMonthTasksWithTheirVirtualTicks(
        fromDate: fromDate, toDate: toDate);

    final weekTask = await _getAllWeekTasksWithTheirVirtualTicks(
        fromDate: fromDate, toDate: toDate);

    return [...onceTasks, ...monthTask, ...weekTask];
  }

  static Future<Iterable<Task>> _getAllMonthTasksWithTheirVirtualTicks(
      {String fromDate, String toDate}) async {
    final tasks = (await monthTaskTable.query(
        fromDate: fromDate, toDate: toDate, lastUpdateOrderAsc: true))
        .toList();

    return await _joinTasksToTheirVirtualMonthTicks(tasks);
  }

  static Future<Iterable<Task>> _getAllWeekTasksWithTheirVirtualTicks(
      {String fromDate, String toDate}) async {
    final tasks = (await weekTaskTable.query(
        fromDate: fromDate, toDate: toDate, lastUpdateOrderAsc: true))
        .toList();

    return await _joinTasksToTheirVirtualWeekTicks(tasks);
  }

  static Future<Iterable<Task>> getAllTasksOfType(TaskType type) {
    switch (type) {
      case TaskType.once:
        return getOnceTasksWithTheirTicks();
      case TaskType.week:
        return _getAllWeekTasksWithTheirTicks();
      case TaskType.month:
        return _getAllMonthTasksWithTheirTicks();
      default:
        throw 'Exhuastive check';
    }
  }

  static Future<Iterable<Task>> getOnceTasksWithTheirTicks(
      {String fromDate, String toDate}) async {
    List<Task> tasks = (await onceTaskTable.query(
        fromDate: fromDate, toDate: toDate, lastUpdateOrderAsc: true))
        .toList();

    return await _addOnceTicksToTasks(tasks);
  }

  static Future<Iterable<Task>> _getAllWeekTasksWithTheirTicks() async {
    final tasks = (await weekTaskTable.query()).toList();

    final ticksDict = <int, Tick>{};
    final ticks = await weekTaskTickTable.queryForTaskIdAndTypeAndDay(
        taskIds: tasks.map((r) => r.id));
    ticks.forEach((tick) => ticksDict[tick.taskId] = tick);

    tasks.forEach((task) {
      task.type = TaskType.week;
      task.tick = ticksDict[task.id];
    });

    return tasks;
  }

  static Future<Iterable<Task>> _getAllMonthTasksWithTheirTicks() async {
    final tasks = (await monthTaskTable.query()).toList();

    final ticksDict = <int, Tick>{};
    final ticks = await monthTaskTickTable.queryForTaskIdAndTypeAndDay(
        taskIds: tasks.map((r) => r.id));
    ticks.forEach((tick) => ticksDict[tick.taskId] = tick);

    tasks.forEach((task) {
      task.type = TaskType.month;
      task.tick = ticksDict[task.id];
    });

    return tasks;
  }
}

Future<List<Task>> _joinTasksToTheirVirtualMonthTicks(List<Task> tasks,
    {List<TickType> tickType}) async {
  final taskIds = tasks.map((r) => r.id);
  final ticks = await monthTaskTickTable.queryForTaskIdAndTypeAndDay(
      taskIds: taskIds, types: tickType);

  final ticksDict = _groupTicks(ticks);

  final todayParts = getNowDate().split('/');
  final todayMonthDay = int.parse(todayParts[2]);
  final currentMonth = '${todayParts[0]}/${todayParts[1]}';

  final oneMonthAgoParts =
  getJalaliOf(DateTime.now().add(Duration(days: -30))).split('/');
  final prevMonth = '${oneMonthAgoParts[0]}/${oneMonthAgoParts[1]}';

  final ret = <Task>[];
  tasks.forEach((task) {
    task.type = TaskType.month;

    final ticks = ticksDict[task.id];
    final taskDay = task.infos['dayOfMonth'];

    if (taskDay <= todayMonthDay) {
      final newTask = _cloneTask(task);
      final ticksOfPrevMonth =
      ticks?.where((r) => r.infos['month'] == currentMonth)?.toList();
      newTask.tick = (ticksOfPrevMonth?.length ?? 0) > 0
          ? ticksOfPrevMonth[0]
          : Tick(
          taskId: task.id,
          infos: {'month': currentMonth},
          taskType: TaskType.month);
      ret.add(newTask);
    }

    if (task.start == null ||
        compareDateTime(task.start,
            '$prevMonth/$taskDay ${task.infos['startHour'] ?? '24:00'}') >
            0) {
      final ticksOfPrevMonth =
      ticks?.where((r) => r.infos['month'] == prevMonth)?.toList();
      task.tick = (ticksOfPrevMonth?.length ?? 0) > 0
          ? ticksOfPrevMonth[0]
          : Tick(
          taskId: task.id,
          infos: {'month': prevMonth},
          taskType: TaskType.month);
      ret.add(task);
    }
  });

  return ret;
}

Future<List<Task>> _joinTasksToTheirVirtualWeekTicks(List<Task> tasks,
    {List<TickType> tickType}) async {
  final ticks = await weekTaskTickTable.queryForTaskIdAndTypeAndDay(
      taskIds: tasks.map((r) => r.id), types: tickType);

  final ticksDict = _groupTicks(ticks);

  final ret = <Task>[];
  tasks.forEach((task) {
    task.type = TaskType.week;

    final ticks = ticksDict[task.id];
    final weekDays = task.infos['weekdays'];

    for (int i = 0; i < 7; i++) {
      final theDay = DateTime.now().add(Duration(days: -i));
      final weekDayNumber = (theDay.weekday + 1) % 7;
      final weekDayBit = 1 << weekDayNumber;
      if (weekDays & weekDayBit == 0) return;

      final jalaliDay = getJalaliOf(theDay);
      final ticksOfPrevMonth =
      ticks?.where((r) => r.infos['day'] == jalaliDay)?.toList();

      final newTask = _cloneTask(task);
      newTask.tick = (ticksOfPrevMonth?.length ?? 0) > 0
          ? ticksOfPrevMonth[0]
          : Tick(
          taskId: task.id, infos: {'day': jalaliDay}, taskType: task.type);
      ret.add(newTask);
    }
  });

  return ret;
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

Map<int, List<Tick>> _groupTicks(Iterable<Tick> ticks) {
  final ticksDict = <int, List<Tick>>{};
  ticks.forEach((tick) {
    if (ticksDict[tick.taskId] == null)
      ticksDict[tick.taskId] = [tick];
    else
      ticksDict[tick.taskId].add(tick);
  });
  return ticksDict;
}

Task _cloneTask(Task task) {
  return Task.fromJson(task.toJson())
    ..type = task.type;
}
