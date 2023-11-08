import 'package:boost/boost.dart';
import 'package:datahub/datahub.dart';

import '../sql_context.dart';
import 'param_sql.dart';
import 'sql_builder.dart';

class InsertBuilder implements SqlBuilder {
  final SqlContext context;
  final String schemaName;
  final String tableName;
  final Map<DataField, dynamic> _values = {};
  String? _returning;

  InsertBuilder(this.context, this.schemaName, this.tableName);

  void values(Map<DataField, dynamic> entryValues) {
    _values.addAll(entryValues);
  }

  void returning(String? expr) {
    _returning = expr;
  }

  @override
  ParamSql buildSql() {
    final sql = ParamSql('');
    final values = _values.entries.map((e) {
      final fieldName = SqlContext.escapeName(e.key.name);
      final type = context.findType(e.key);
      final value = type.toPostgresValue(e.key, e.value);
      return Tuple(fieldName, value);
    }).toList();

    sql.addSql('INSERT INTO $schemaName.$tableName (');
    sql.addSql(values.map((e) => e.a).join(', '));
    sql.addSql(') VALUES (');
    sql.add(values.map((e) => e.b).joinSql(', '));
    sql.addSql(')');

    if (_returning != null) {
      sql.addSql(' RETURNING $_returning');
    }

    return sql;
  }
}
