import 'package:datahub/datahub.dart';
import 'package:datahub_postgres/src/sql_context.dart';

class PostgresqlQueryResult extends QueryResult {
  final SqlContext registry;

  PostgresqlQueryResult(this.registry, super.layoutName, super.data);

  @override
  T getFieldValue<T>(DataField<DataType<T>> field) {
    final type = registry.findType(field);
    return type.toDaoValue(data[field.name]);
  }
}
