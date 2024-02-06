import 'package:datahub/persistence.dart';
import 'package:datahub_postgres/src/sql_context.dart';

import '../postgresql_data_types.dart';
import 'param_sql.dart';

class AddFieldBuilder {
  final SqlContext context;
  final String schemaName;
  final String tableName;
  final PostgresqlDataType type;
  final DataField field;
  final dynamic initialValue;

  AddFieldBuilder(
    this.context,
    this.schemaName,
    this.tableName,
    this.field,
    this.type,
    this.initialValue,
  ) {
    if (!field.nullable && initialValue == null) {
      throw PersistenceException(
          'Cannot add non-nullable field without initial value!');
    }
  }

  List<ParamSql> buildSql() {
    final commands = <ParamSql>[];
    final tableRef =
        '${SqlContext.escapeName(schemaName)}.${SqlContext.escapeName(tableName)}';
    final colName = SqlContext.escapeName(field.name);

    final c1 = ParamSql(
        'ALTER TABLE $tableRef ADD COLUMN $colName ${type.getTypeSql(field)}');

    if (field is PrimaryKey) {
      c1.addSql(' PRIMARY KEY');
    }

    commands.add(c1);

    if (initialValue != null) {
      final c2 = ParamSql('UPDATE $tableRef SET $colName = ');
      c2.add(context.expressionSql(initialValue));
      commands.add(c2);
    }

    if (field is! PrimaryKey && !field.nullable) {
      final c3 =
          ParamSql('ALTER TABLE $tableRef ALTER COLUMN $colName SET NOT NULL');
      commands.add(c3);
    }

    return commands;
  }
}
