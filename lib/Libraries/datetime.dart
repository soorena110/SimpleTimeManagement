import 'package:shamsi_date/shamsi_date.dart';

String getNowDate() {
  final j = Jalali.now();
  final m = j.month.toString().padLeft(2, '0');
  final d = j.day.toString().padLeft(2, '0');
  return '${j.year}/$m/$d';
}

String getNow() {
  final now = DateTime.now();
  return '${getNowDate()} ${now.hour}:${now.minute}';
}

int compareDateTime(String d1, String d2) {
  if (d1 == d2) return 0;
  if (d1 == null) return 1;
  if (d2 == null) return -1;

  final dateDiffMili = getDateDiff(d1, d2).inMilliseconds;
  if (dateDiffMili != 0) return dateDiffMili > 0 ? 1 : -1;

  final timeDiffMili =
      getTimeDiff(d1.split(' ')[1], d2.split(' ')[1]).inMilliseconds;
  if (timeDiffMili != 0) return timeDiffMili > 0 ? 1 : -1;

  return 0;
}

Duration getDateDiff(String d1, String d2) {
  var date1 = convertStringToJalali(d1.split(' ')[0]).toDateTime();
  var date2 = convertStringToJalali(d2.split(' ')[0]).toDateTime();
  return date1.difference(date2);
}

Duration getTimeDiff(String t1, String t2) {
  var t1Parts = t1.split(':').map((p) => int.parse(p)).toList();
  var t2Parts = t2.split(':').map((p) => int.parse(p)).toList();
  var d1 = DateTime(0, 0, 0, t1Parts[0], t1Parts[1]);
  var d2 = DateTime(0, 0, 0, t2Parts[0], t2Parts[1]);

  return d1.difference(d2);
}

Jalali convertStringToJalali(String str) {
  var strParts = str.split('/').map((p) => int.parse(p)).toList();
  return Jalali(strParts[0], strParts[1], strParts[2]);
}

String getDiffrenceText(String dt1, String dt2) {
  final dayDiff = getDateDiff(dt1, dt2).inDays;
  if (dayDiff != 0)
    return dayDiff.abs().toString() + ' روز ' + (dayDiff > 0 ? 'بعد' : 'پیش');

  final t1 = dt1.split(' ')[1];
  final t2 = dt2.split(' ')[1];
  final timeDiff = getTimeDiff(t1, t2);

  if (timeDiff.inHours != 0)
    return timeDiff.inHours.abs().toString() +
        ' ساعت ' +
        (timeDiff.inHours > 0 ? 'بعد' : 'پیش');
  if (timeDiff.inMinutes != 0)
    return timeDiff.inMinutes.abs().toString() +
        ' دقیقه ' +
        (timeDiff.inMinutes > 0 ? 'بعد' : 'پیش');
}
