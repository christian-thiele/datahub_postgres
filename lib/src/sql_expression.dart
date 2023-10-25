import 'package:datahub/datahub.dart';
import 'package:datahub_postgres/datahub_postgres.dart';

class SqlExpression extends ParamSql implements Expression, Filter {
  SqlExpression(super.sql);

  factory SqlExpression.function(String name, List<Expression> params) {
    final sql = SqlExpression(name);
    sql.add(
        params.map((e) => SqlBuilder.expressionSql(e)).joinSql(', ')..wrap());
    return sql;
  }

  @override
  bool get isEmpty => false;

  @override
  Filter reduce() => this;
}
