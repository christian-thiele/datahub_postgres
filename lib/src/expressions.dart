import 'package:datahub/datahub.dart';
import 'package:datahub_postgres/datahub_postgres.dart';

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

class CustomOperatorExpression implements Expression {
  final String operatorSql;
  final Expression left;
  final Expression right;

  CustomOperatorExpression(this.left, this.operatorSql, this.right);
}
