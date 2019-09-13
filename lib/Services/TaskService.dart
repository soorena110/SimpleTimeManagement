import 'package:time_river/Database/Tables/TaskTable.dart';
import 'package:time_river/Database/Tables/TickTable.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Models/Tick.dart';

import 'common.dart';

class TaskService {
  static void Function() onChanged;

  static deleteTask(Task task) async {
    await taskTable.delete(task.id);
    await tickTable.deleteForTaskId(task.id);

    if (TaskService.onChanged != null) TaskService.onChanged();
  }

  static saveTask(Task task) async {
    taskTable.insertOrUpdate(task.toJson());

    if (TaskService.onChanged != null) TaskService.onChanged();
  }

  static saveTick(Tick tick) async {
    tick.id = await taskTable.insertOrUpdate(tick.toJson());

    if (TaskService.onChanged != null) TaskService.onChanged();
  }

  static Future<Iterable<Task>> getAllTasksUpdatedAfter(String lastUpdate) =>
      taskTable.getAllTasksUpdatedAfter(lastUpdate);

  static Future<Iterable<Tick>> getAllTicksUpdatedAfter(String lastUpdate) =>
      tickTable.getAllTicksUpdatedAfter(lastUpdate);

  static Future<Iterable<Task>> getTodayTasks() {
    final today = getNowDate();
    return getTaskWhere(
        fromDateTime: '$today 00:00', toDateTime: '$today 24:00');
  }

  static Future<Iterable<Task>> getTaskWhere(
      {String fromDateTime, String toDateTime}) async {
    List<Task> tasks = (await taskTable.query(
        fromDate: fromDateTime,
        toDate: toDateTime,
        orderLastUpdateOrderAsc: true))
        .toList();

    final ticks = await tickTable.queryForTaskIdAndTypeAndDay(
        taskIds: tasks.map((r) => r.id));

    final onceTasks = tasks.where((t) => t.type == TaskType.once);
    final onceTicks =
    ticks.where((t) => onceTasks.map((t) => t.id).contains(t.id));
    final onceTaskWithTick = await _addOnceTicksToTasks(onceTasks, onceTicks);

    final monthTask = tasks.where((t) => t.type == TaskType.month);
    final monthTicks =
    ticks.where((t) => monthTask.map((t) => t.id).contains(t.id));
    final monthTaskWithTick = await _joinTasksToTheirVirtualMonthTicks(
        monthTask, monthTicks,
        fromDateTime: fromDateTime, toDateTime: toDateTime);

    final weekTask = tasks.where((t) => t.type == TaskType.week);
    final weekTicks =
    ticks.where((t) => weekTask.map((t) => t.id).contains(t.id));
    final weekTaskWithTick = await _joinTasksToTheirVirtualWeekTicks(
        weekTask, weekTicks,
        fromDateTime: fromDateTime, toDateTime: toDateTime);

    return [...onceTaskWithTick, ...monthTaskWithTick, ...weekTaskWithTick];
  }

  static Future<Iterable<Task>> getAllTasksOfType(TaskType type) =>
      taskTable.query(type: type);
}

Future<List<Task>> _addOnceTicksToTasks(Iterable<Task> tasks,
    Iterable<Tick> ticks) async {
  final ticksDict = <int, Tick>{};
  ticks.forEach((tick) => ticksDict[tick.taskId] = tick);

  tasks.forEach((task) {
    task.type = TaskType.once;
    task.tick = ticksDict[task.id];
  });

  return tasks.toList();
}

Future<List<Task>> _joinTasksToTheirVirtualMonthTicks(Iterable<Task> tasks,
    Iterable<Tick> ticks,
    {String fromDateTime, String toDateTime}) async {
  final ticksDict = groupTicks(ticks);

  final ret = <Task>[];
  tasks.forEach((task) {
    task.type = TaskType.month;

    final tickList = ticksDict[task.id];

    for (int i = -1; i <= 1; i++) {
      final newTask = getTickOfMonthIfExists(i, task, tickList,
          fromDateTime: fromDateTime, toDateTime: toDateTime);
      if (newTask != null) ret.add(newTask);
    }
  });

  return ret;
}

getTickOfMonthIfExists(int addingMonth, Task task, List<Tick> tickList,
    {String fromDateTime, String toDateTime}) {
  final jalaliDayParts =
  getJalaliOf(DateTime.now().add(Duration(days: addingMonth * 30)))
      .split('/');

  final monthday = task.infos['monthday'];
  final theMonth = '${jalaliDayParts[0]}/${jalaliDayParts[1]}';
  final theDay = '$theMonth/$monthday';

  if (compareDate(theDay, toDateTime) == 1) return null;
  if (compareDate(theDay, fromDateTime) == -1) return null;

  final newTask = cloneTask(task);
  final ticksOfTheMonth =
  tickList?.where((r) => r.infos['month'] == theMonth)?.toList();

  newTask.tick = (ticksOfTheMonth?.length ?? 0) > 0
      ? ticksOfTheMonth[0]
      : Tick(
      taskId: task.id,
      infos: {'month': theMonth},
      taskType: TaskType.month);

  return newTask;
}

Future<List<Task>> _joinTasksToTheirVirtualWeekTicks(Iterable<Task> tasks,
    Iterable<Tick> ticks,
    {String fromDateTime, String toDateTime}) async {
  final ticksDict = groupTicks(ticks);

  final ret = <Task>[];
  tasks.forEach((task) {
    task.type = TaskType.week;

    final tickList = ticksDict[task.id];

    for (int i = -6; i <= 6; i++) {
      final newTask = getTickOfWeekDayIfExists(i, task, tickList,
          fromDateTime: fromDateTime, toDateTime: toDateTime);
      if (newTask != null) ret.add(newTask);
    }
  });

  return ret;
}

getTickOfWeekDayIfExists(int addingDay, Task task, List<Tick> tickList,
    {String fromDateTime, String toDateTime}) {
  final theDay = DateTime.now().add(Duration(days: addingDay));
  final weekDayNumber = (theDay.weekday + 1) % 7;
  final weekDayBit = 1 << weekDayNumber;
  final weekDays = task.infos['weekdays'];
  if (weekDays & weekDayBit == 0) return null;

  final jalaliDay = getJalaliOf(theDay);
  if (compareDate(jalaliDay, toDateTime) == 1) return null;
  if (compareDate(jalaliDay, fromDateTime) == -1) return null;

  final ticksOfPrevDays =
  tickList?.where((r) => r.infos['day'] == jalaliDay)?.toList();

  final newTask = cloneTask(task);
  newTask.tick = (ticksOfPrevDays?.length ?? 0) > 0
      ? ticksOfPrevDays[0]
      : Tick(taskId: task.id, infos: {'day': jalaliDay}, taskType: task.type);

  return newTask;
}
