import 'package:datahub_postgres/src/sql_context.dart';

import 'param_sql.dart';
import 'sql_builder.dart';

class RemoveFieldBuilder implements SqlBuilder {
  final String schemaName;
  final String tableName;
  final String fieldName;

  RemoveFieldBuilder(this.schemaName, this.tableName, this.fieldName);

  @override
  ParamSql buildSql() {
    final tableRef =
        '${SqlContext.escapeName(schemaName)}.${SqlContext.escapeName(tableName)}';
    final colName = SqlContext.escapeName(fieldName);

    return ParamSql('ALTER TABLE $tableRef DROP COLUMN $colName');
  }
}
