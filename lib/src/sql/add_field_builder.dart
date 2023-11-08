import 'package:datahub/persistence.dart';
import 'package:datahub_postgres/src/sql_context.dart';

import '../postgresql_data_types.dart';
import 'param_sql.dart';
import 'sql_builder.dart';

class AddFieldBuilder implements SqlBuilder {
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

  @override
  ParamSql buildSql() {
    final tableRef =
        '${SqlContext.escapeName(schemaName)}.${SqlContext.escapeName(tableName)}';
    final colName = SqlContext.escapeName(field.name);

    final sql = ParamSql(
        'ALTER TABLE $tableRef ADD COLUMN $colName ${type.getTypeSql(field)}');

    if (field is PrimaryKey) {
      sql.addSql(' PRIMARY KEY');
    }

    if (initialValue != null) {
      sql.addSql('; UPDATE $tableRef SET $colName = ');
      sql.add(context.expressionSql(initialValue));
    }

    if (field is! PrimaryKey && !field.nullable) {
      sql.addSql('; ALTER TABLE $tableRef ALTER COLUMN $colName SET NOT NULL');
    }

    return sql;
  }
}
