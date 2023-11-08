import 'package:datahub/datahub.dart';
import 'package:datahub_postgres/datahub_postgres.dart';
import 'package:datahub_postgres/src/sql_context.dart';

class SqlExpression extends ParamSql implements Expression, Filter {
  SqlExpression(super.sql);

  @override
  bool get isEmpty => false;

  @override
  Filter reduce() => this;
}

class FunctionExpression implements Expression, Filter {
  final String name;
  List<Expression> arguments;

  FunctionExpression(this.name, this.arguments);

  @override
  bool get isEmpty => false;

  @override
  Filter reduce() => this;
}