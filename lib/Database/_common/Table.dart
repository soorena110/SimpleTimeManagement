import 'package:time_river/Database/_common/Row.dart';

class Table {
  final String name;
  final List<Row> rows;
  final bool isIfNotExist;
  final List<String> uniquesFields;

  Table(this.name, this.rows,
      {this.isIfNotExist = true, this.uniquesFields = const <String>[]});

  _getTableToString() {
    return 'CREATE TABLE '
        '${isIfNotExist ? 'IF NOT EXISTS ' : ''}'
        '$name '
        '(${rows.map((r) => r.toString()).join(',\n')});';
  }

  _getTableUniqueIndexesToString() {
    return uniquesFields
        .map((field) =>
            'CREATE UNIQUE INDEX ${this.name}_$field ON contacts ($field)')
        .join(';');
  }

  @override
  String toString() {
    return this._getTableToString() + this._getTableUniqueIndexesToString();
  }
}
