import 'package:boost/boost.dart';
import 'package:datahub/persistence.dart';
import 'package:datahub_postgres/src/sql_context.dart';
import 'package:postgres/postgres.dart' as postgres;

import 'postgresql_database_adapter.dart';
import 'postgresql_query_result.dart';

import 'sql/sql.dart';

class PostgreSQLDatabaseContext implements DatabaseContext {
  static const _metaKeyColumn = 'key';
  static const _metaValueColumn = 'value';
  final PostgreSQLDatabaseAdapter _adapter;
  final postgres.PostgreSQLExecutionContext _context;

  PostgreSQLDatabaseContext(this._adapter, this._context);

  Future<String?> getMetaValue(String key) async {
    final result = await _context.query(
        'SELECT "value" FROM ${_adapter.schema.name}.$metaTable WHERE "key" = @key',
        substitutionValues: {'key': key});

    if (result.isNotEmpty) {
      return result.firstOrNull?.firstOrNull as String?;
    } else {
      return null;
    }
  }

  Future<void> setMetaValue(String key, String value) async {
    final currentValue = await getMetaValue(key);
    if (currentValue == null) {
      await _context.execute(
          'INSERT INTO ${_adapter.schema.name}.$metaTable ("$_metaKeyColumn", "$_metaValueColumn") VALUES (@key, @value)',
          substitutionValues: {'key': key, 'value': value});
    } else {
      await _context.execute(
          'UPDATE ONLY ${_adapter.schema.name}.$metaTable SET "$_metaValueColumn" = @value WHERE "$_metaKeyColumn" = @key',
          substitutionValues: {'key': key, 'value': value});
    }
  }

  Future<int> execute(ParamSql sql) async {
    final result = await _context.query(
      sql.toString(),
      substitutionValues: sql.getSubstitutionValues(),
    );
    return result.affectedRowCount;
  }

  Future<List<List<QueryResult>>> querySql(ParamSql sql) async {
    final result = await _context.query(
      sql.toString(),
      substitutionValues: sql.getSubstitutionValues(),
    );

    QueryResult? mapResult(MapEntry<String, Map<String, dynamic>> e) {
      final values = e.value.map((key, value) => MapEntry(key, value));
      if (values.values.whereNotNull.isEmpty) {
        return null;
      }

      return PostgresqlQueryResult(
        _adapter,
        e.key,
        values,
      );
    }

    List<QueryResult> mapRow(postgres.PostgreSQLResultRow row) {
      final map = <String, Map<String, dynamic>>{};
      for (var i = 0; i < row.columnDescriptions.length; i++) {
        final col = row.columnDescriptions[i];
        final data = map[col.tableName] ??= {};
        data[col.columnName] = row[i];
      }
      return map.entries.map(mapResult).whereNotNull.toList();
    }

    return result.map(mapRow).toList();
  }

  @override
  Future<List<TResult>> query<TResult>(
    QuerySource<TResult> bean, {
    Filter filter = Filter.empty,
    List<QuerySelect> distinct = const <QuerySelect>[],
    Sort sort = Sort.empty,
    int offset = 0,
    int limit = -1,
    bool forUpdate = false,
  }) async {
    final from = SelectFrom.fromQuerySource(_adapter, _adapter.schema.name, bean);
    final builder = SelectBuilder(_adapter, from)
      ..select([const WildcardSelect()])
      ..distinct(distinct)
      ..where(filter)
      ..orderBy(sort)
      ..offset(offset)
      ..limit(limit)
      ..forUpdate(forUpdate);

    final result = await querySql(builder.buildSql());
    return result.map((r) => bean.map(r)).whereNotNull.toList();
  }

  @override
  Future<TDao?> queryId<TDao, TPrimaryKey>(
    PrimaryKeyDataBean<TDao, TPrimaryKey> bean,
    TPrimaryKey id, {
    bool forUpdate = false,
  }) async {
    final from = SelectFromTable(_adapter.schema.name, bean.layoutName);
    final builder = SelectBuilder(_adapter, from)
      ..where(Filter.equals(bean.primaryKey, id))
      ..forUpdate(forUpdate);
    final result = await querySql(builder.buildSql());

    return result.map((r) => bean.map(r)).firstOrNull;
  }

  @override
  Future<bool> idExists<TPrimaryKey>(
    PrimaryKeyDataBean<dynamic, TPrimaryKey> bean,
    TPrimaryKey id,
  ) async {
    final from = SelectFromTable(_adapter.schema.name, bean.layoutName);
    final builder = SelectBuilder(_adapter, from)
      ..select([bean.primaryKey])
      ..where(Filter.equals(bean.primaryKey, id));
    final result = await querySql(builder.buildSql());

    return result.isNotEmpty;
  }

  @override
  Future<dynamic> insert<TDao extends BaseDao>(TDao entry) async {
    final bean = entry.bean;

    final primaryKey = bean is PrimaryKeyDataBean ? bean.primaryKey : null;

    final returning =
        primaryKey != null ? SqlContext.escapeName(primaryKey.name) : null;

    final withPrimary =
        !(primaryKey?.type == IntDataType && primaryKey?.autoIncrement == true);

    final data = bean.unmap(entry, includePrimaryKey: withPrimary);
    final builder =
        InsertBuilder(_adapter, _adapter.schema.name, entry.bean.layoutName)
          ..values(data)
          ..returning(returning);
    final result = await querySql(builder.buildSql());

    return result.firstOrNull?.firstOrNull?.data.values.firstOrNull;
  }

  @override
  Future<void> update<TDao extends PrimaryKeyDao>(TDao object) async {
    final bean = object.bean;
    final data = bean.unmap(object);

    final from = SelectFromTable(_adapter.schema.name, bean.layoutName);
    final builder = UpdateBuilder(_adapter, from)
      ..values(data)
      ..where(_pkFilter(bean, object.getPrimaryKey()));
    await execute(builder.buildSql());
  }

  @override
  Future<void> updateId<TPrimaryKey>(
    PrimaryKeyDataBean<dynamic, TPrimaryKey> bean,
    TPrimaryKey id,
    Map<DataField, dynamic> values,
  ) async {
    final from = SelectFromTable(_adapter.schema.name, bean.layoutName);
    final builder = UpdateBuilder(_adapter, from)
      ..values(values)
      ..where(_pkFilter(bean, id));
    await execute(builder.buildSql());
  }

  @override
  Future<int> updateWhere(
    QuerySource source,
    Map<DataField, dynamic> values,
    Filter filter,
  ) async {
    final from = SelectFrom.fromQuerySource(_adapter, _adapter.schema.name, source);
    final builder = UpdateBuilder(_adapter, from)
      ..values(values)
      ..where(filter);
    return await execute(builder.buildSql());
  }

  @override
  Future<void> delete<TDao extends PrimaryKeyDao>(TDao object) async {
    final bean = object.bean;
    final from = SelectFromTable(_adapter.schema.name, bean.layoutName);
    final builder = DeleteBuilder(_adapter, from)
      ..where(_pkFilter(bean, object.getPrimaryKey()));
    await execute(builder.buildSql());
  }

  @override
  Future<void> deleteId<TPrimaryKey>(
    PrimaryKeyDataBean<dynamic, TPrimaryKey> bean,
    dynamic id,
  ) async {
    final from = SelectFromTable(_adapter.schema.name, bean.layoutName);
    final builder = DeleteBuilder(_adapter, from)..where(_pkFilter(bean, id));
    await execute(builder.buildSql());
  }

  @override
  Future<int> deleteWhere(DataBean bean, Filter filter) async {
    final from = SelectFromTable(_adapter.schema.name, bean.layoutName);
    final builder = DeleteBuilder(_adapter, from)..where(filter);
    return await execute(builder.buildSql());
  }

  @override
  Future<List<Map<String, dynamic>>> select(
    QuerySource source,
    List<QuerySelect> select, {
    Filter filter = Filter.empty,
    List<QuerySelect> distinct = const <QuerySelect>[],
    Sort sort = Sort.empty,
    List<Expression> group = const <Expression>[],
    int offset = 0,
    int limit = -1,
    bool forUpdate = false,
  }) async {
    final from = SelectFrom.fromQuerySource(_adapter, _adapter.schema.name, source);
    final builder = SelectBuilder(_adapter, from)
      ..where(filter)
      ..orderBy(sort)
      ..offset(offset)
      ..limit(limit)
      ..select(select)
      ..groupBy(group)
      ..forUpdate(forUpdate);
    final results = await querySql(builder.buildSql());
    return results.map((e) => QueryResult.merge(e)).toList();
  }

  Filter _pkFilter<TPrimaryKey>(
    PrimaryKeyDataBean<dynamic, TPrimaryKey> layout,
    TPrimaryKey id,
  ) {
    return Filter.equals(layout.primaryKey, id);
  }
}
