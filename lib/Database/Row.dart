enum RowType { integer, text }

const RowSqlType = <RowType, String>{
  RowType.text: 'TEXT',
  RowType.integer: 'INTEGER'
};

class Row {
  final String name;
  final RowType type;
  final bool isPrimaryKey;
  final bool isAutoIncrement;
  final bool isNullable;
  final dynamic defaultValue;

  Row(this.name, this.type,
      {this.isAutoIncrement = false,
      this.isPrimaryKey = false,
      this.isNullable = true,
      this.defaultValue});

  @override
  String toString() {
    return '$name ${RowSqlType[type]}' +
        (isPrimaryKey ? ' PRIMARY KEY' : '') +
        (isAutoIncrement ? ' AUTOINCREMENT' : '') +
        (isNullable ? '' : ' NOT NULL') +
        (defaultValue != null ? ' DEFAULT ' + defaultValue : '');
  }
}
