import 'Row.dart';

class Table {
  final String name;
  final List<Row> rows;
  final bool isIfNotExist;

  Table(this.name, this.rows, {this.isIfNotExist = true});

  @override
  String toString() {
    return 'CREATE TABLE '
        '${isIfNotExist ? 'IF NOT EXISTS ' : ''}'
        '$name ' +
        '(${rows.map((r) => r.toString()).join(',\n')})';
  }
}