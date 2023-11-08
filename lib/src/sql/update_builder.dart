import 'package:datahub/persistence.dart';
import '../sql_context.dart';

import 'param_sql.dart';
import 'select_from.dart';
import 'sql_builder.dart';

class UpdateBuilder implements SqlBuilder {
  final SqlContext context;

  final SelectFrom from;
  final Map<DataField, dynamic> _values = {};
  Filter _filter = Filter.empty;

  UpdateBuilder(this.context, this.from);

  void values(Map<DataField, dynamic> entryValues) {
    _values.addAll(entryValues);
  }

  void where(Filter filter) {
    _filter = filter;
  }

  @override
  ParamSql buildSql() {
    final sql = ParamSql('UPDATE ');
    final values = _values.entries.map((e) {
      final fieldName = SqlContext.escapeName(e.key.name);
      final type = context.findType(e.key);
      final value = type.toPostgresValue(e.key, e.value);
      final sql = ParamSql('$fieldName = ');
      sql.add(value);
      return sql;
    }).toList();

    sql.add(from.buildSql());
    sql.addSql(' SET ');
    sql.add(values.joinSql(', '));

    if (!_filter.isEmpty) {
      sql.addSql(' WHERE ');
      sql.add(context.filterSql(_filter));
    }

    return sql;
  }
}
