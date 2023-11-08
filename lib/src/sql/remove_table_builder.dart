import 'package:datahub_postgres/src/sql_context.dart';

import 'param_sql.dart';
import 'sql_builder.dart';

class RemoveTableBuilder implements SqlBuilder {
  final String schemaName;
  final String tableName;

  RemoveTableBuilder(this.schemaName, this.tableName);

  @override
  ParamSql buildSql() {
    final tableRef =
        '${SqlContext.escapeName(schemaName)}.${SqlContext.escapeName(tableName)}';
    return ParamSql('DROP TABLE $tableRef');
  }
}
