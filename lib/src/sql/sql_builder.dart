import 'param_sql.dart';

abstract interface class SqlBuilder {
  /// Returns the sql string together with it's substitution values
  ParamSql buildSql();
}
