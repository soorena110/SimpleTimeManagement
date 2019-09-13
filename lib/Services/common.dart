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
