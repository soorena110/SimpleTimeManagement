import 'package:time_river/Database/Tables/Tasks/OnceTaskTable.dart';
import 'package:time_river/Database/Tables/Ticks/OnceTaskTick.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Models/Tick.dart';

class OnceTaskService {
  static Future<Iterable<Task>> getOnceTasksWithTheirTicks(
      {String fromDateTime, String toDateTime}) async {
    List<Task> tasks = (await onceTaskTable.query(
            fromDate: fromDateTime,
            toDate: toDateTime,
            lastUpdateOrderAsc: true))
        .toList();

    return await _addOnceTicksToTasks(tasks);
  }
}

Future<List<Task>> _addOnceTicksToTasks(List<Task> tasks,
    {List<TickType> tickType}) async {
  final ticksDict = <int, Tick>{};
  final ticks = await onceTaskTickTable.queryForTaskIdAndTypeAndDay(
      taskIds: tasks.map((r) => r.id), types: tickType);
  ticks.forEach((tick) => ticksDict[tick.taskId] = tick);

  tasks.forEach((task) {
    task.type = TaskType.once;
    task.tick = ticksDict[task.id];
  });

  return tasks;
}
