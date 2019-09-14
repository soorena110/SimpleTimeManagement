import 'package:time_river/Database/_common/Row.dart';

class Table {
  final String name;
  final List<Row> rows;
  final bool isIfNotExist;

  Table(this.name, this.rows, {this.isIfNotExist = true});

  _getTableToString() {
    return 'CREATE TABLE '
        '${isIfNotExist ? 'IF NOT EXISTS ' : ''}'
        '$name '
        '(${rows.map((r) => r.toString()).join(',\n')});';
  }

  _getTableUniqueIndexesToString() {
    return rows
        .where((r) => r.isIndexed)
        .map((r) =>
    "CREATE ${r.isUnique ? 'UNIQUE INDEX' : 'INDEX'} '${name}_${r
        .name}' ON '$name' ('${r.name})'")
        .join(';');
  }

  @override
  String toString() {
    return this._getTableToString() + this._getTableUniqueIndexesToString();
  }
}
