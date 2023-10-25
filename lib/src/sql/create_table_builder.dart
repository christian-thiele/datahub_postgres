//TODO collations, constraints, ...
//maybe even inheritance
import 'package:datahub/persistence.dart';

import '../postgresql_database_adapter.dart';
import 'param_sql.dart';
import 'sql_builder.dart';

class CreateTableBuilder implements SqlBuilder {
  final PostgreSQLDatabaseAdapter adapter;
  final bool ifNotExists;
  final String schemaName;
  final String tableName;
  final List<DataField> fields = [];

  CreateTableBuilder(this.adapter, this.schemaName, this.tableName,
      {this.ifNotExists = false});

  factory CreateTableBuilder.fromLayout(
      PostgreSQLDatabaseAdapter adapter, DataSchema schema, DataBean bean) {
    return CreateTableBuilder(adapter, schema.name, bean.layoutName,
        ifNotExists: true)
      ..fields.addAll(bean.fields);
  }

  @override
  ParamSql buildSql() {
    final sql = ParamSql('CREATE TABLE ');

    if (ifNotExists) {
      sql.addSql('IF NOT EXISTS ');
    }

    sql.addSql(
        '${SqlBuilder.escapeName(schemaName)}.${SqlBuilder.escapeName(tableName)} (');

    sql.add(fields.map(_createFieldSql).joinSql(','));

    sql.addSql(')');

    return sql;
  }

  ParamSql _createFieldSql(DataField field) {
    final type = adapter.findType(field);
    final sql = ParamSql(SqlBuilder.escapeName(field.name));
    sql.addSql(' ');
    sql.add(type.getTypeSql(field));
    if (field is PrimaryKey) {
      sql.addSql(' PRIMARY KEY');
    } else if (!field.nullable) {
      sql.addSql(' NOT NULL');
    }
    return sql;
  }
}
