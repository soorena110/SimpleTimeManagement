import 'package:time_river/Libraries/datetime.dart';

class TaskBase {
  int id;
  String name;
  String start;
  String end;
  double estimate;
  String description;
  String lastUpdate;

  TaskBase(this.id, this.name, this.start, this.end, this.description,
      this.estimate, this.lastUpdate);

  TaskBase.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        start = json['start'],
        end = json['end'],
        estimate = json['estimate'] is String
            ? double.parse(json['estimate'])
            : json['estimate'],
        lastUpdate = json['lastUpdate'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'start': start,
        'end': end,
        'estimate': estimate,
        'lastUpdate': getNow()
      };

  String getEstimateString() {
    final hm = this.estimate;
    if (hm == null) return '';
    final h = hm.floor();
    final m = ((hm - h) * 60).round();

    var ret = '';
    if (h != 0) ret = '${h}h';
    if (m != 0) ret += (ret != '' ? ' & ' : '') + '${m}m';
    return ret;
  }

  @override
  String toString() {
    return '${id ?? name}';
  }
}
