enum RowType { integer, text, real }

const RowSqlType = <RowType, String>{
  RowType.text: 'TEXT',
  RowType.integer: 'INTEGER',
  RowType.real: 'REAL'
};

class Row {
  final String name;
  final RowType type;
  final bool isPrimaryKey;
  final bool isAutoIncrement;
  final bool isNullable;
  final bool isUnique;
  final dynamic defaultValue;

  Row(this.name, this.type,
      {this.isAutoIncrement = false,
      this.isPrimaryKey = false,
      this.isNullable = true,
      this.defaultValue,
      this.isUnique});

  @override
  String toString() {
    return '$name ${RowSqlType[type]}' +
        (isPrimaryKey ? ' PRIMARY KEY' : '') +
        (isAutoIncrement ? ' AUTOINCREMENT' : '') +
        (isUnique ? 'UNIQUE' : '') +
        (isNullable ? '' : ' NOT NULL') +
        (defaultValue != null ? ' DEFAULT ' + defaultValue : '');
  }
}
