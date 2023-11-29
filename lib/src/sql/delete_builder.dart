import 'package:datahub/persistence.dart';
import 'package:datahub_postgres/src/sql_context.dart';

import 'param_sql.dart';
import 'select_from.dart';
import 'sql_builder.dart';

class DeleteBuilder implements SqlBuilder {
  final SqlContext context;
  final SelectFrom from;
  Filter _filter = Filter.empty;

  DeleteBuilder(this.context, this.from);

  void where(Filter filter) {
    _filter = filter.reduce();
  }

  @override
  ParamSql buildSql() {
    final sql = ParamSql('DELETE FROM ');
    sql.add(from.buildSql());

    if (!_filter.isEmpty) {
      sql.addSql(' WHERE ');
      sql.add(context.filterSql(_filter));
    }

    return sql;
  }
}
