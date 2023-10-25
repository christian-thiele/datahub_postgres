import 'package:datahub/datahub.dart';
import 'package:datahub_postgres/datahub_postgres.dart';
import 'package:test/test.dart';

class TableDataBean extends DataBean<void> {
  @override
  List<DataField> get fields => [];

  @override
  String get layoutName => 'table';

  @override
  Map<DataField, dynamic> unmap(dao, {bool includePrimaryKey = false}) => {};

  @override
  void mapValues(Map<String, dynamic> data) {}
}

enum TestEnum { something, test }

void main() {
  final fieldX = DataField<StringDataType>(layoutName: 'fake', name: 'fieldX');
  final schemaTable = SelectFromTable('schema', 'table');
  group('TableSelectSource', () {
    test(
      'Select',
      _test(
        SelectBuilder(schemaTable),
        'SELECT * FROM "schema"."table"',
      ),
    );

    test(
      'Select filter eq string',
      _test(
        SelectBuilder(schemaTable)..where(Filter.equals(fieldX, 'valueX')),
        'SELECT * FROM "schema"."table" WHERE "fake"."fieldX" = @1',
        ['valueX'],
      ),
    );

    test(
      'Select filter eq enum',
      _test(
          SelectBuilder(schemaTable)
            ..where(Filter.equals(fieldX, TestEnum.something)),
          'SELECT * FROM "schema"."table" WHERE "fake"."fieldX" = @1',
          ['something']),
    );

    test(
      'Select filter eq string caseInsensitive',
      _test(
        SelectBuilder(schemaTable)
          ..where(CompareFilter(
              fieldX, CompareType.equals, ValueExpression('valueX'),
              caseSensitive: false)),
        'SELECT * FROM "schema"."table" WHERE LOWER("fake"."fieldX") = LOWER(@1)',
        ['valueX'],
      ),
    );

    test(
      'Select filter eq string contains',
      _test(
          SelectBuilder(schemaTable)
            ..where(CompareFilter(
                fieldX, CompareType.contains, ValueExpression('valueX'))),
          'SELECT * FROM "schema"."table" WHERE "fake"."fieldX" LIKE \'%\' || @1 || \'%\'',
          ['valueX']),
    );

    test(
      'Select filter eq string contains caseInsensitive',
      _test(
          SelectBuilder(schemaTable)
            ..where(CompareFilter(
                fieldX, CompareType.contains, ValueExpression('valueX'),
                caseSensitive: false)),
          'SELECT * FROM "schema"."table" WHERE "fake"."fieldX" ILIKE \'%\' || @1 || \'%\'',
          ['valueX']),
    );

    test(
      'Select filter eq int',
      _test(
        SelectBuilder(schemaTable)..where(Filter.equals(fieldX, 20)),
        'SELECT * FROM "schema"."table" WHERE "fake"."fieldX" = @1',
        [20],
      ),
    );

    test(
      'Select filter eq double',
      _test(
        SelectBuilder(schemaTable)..where(Filter.equals(fieldX, 20.12)),
        'SELECT * FROM "schema"."table" WHERE "fake"."fieldX" = @1',
        [20.12],
      ),
    );

    test(
      'Select group by add',
      _test(
        SelectBuilder(schemaTable)
          ..groupBy([OperationExpression(fieldX, fieldX, OperationType.add)]),
        'SELECT * FROM "schema"."table" GROUP BY ("fake"."fieldX" + "fake"."fieldX")',
      ),
    );
  });

  group('SubQuery', () {
    test(
      'Select with total row_number()',
      _test(
          SelectBuilder(SelectFrom.fromQuerySource(
            'schema',
            SubQuery(
                TableDataBean(),
                [
                  WildcardSelect(),
                  ExpressionSelect(
                    // ignore: deprecated_member_use
                    SqlExpression('row_number() OVER (order by something)'),
                    'num',
                  ),
                ],
                alias: 'sub',
                filter: Filter.equals(fieldX, 'valueY')),
          ))
            ..where(Filter.equals(fieldX, 'valueX')),
          'SELECT * FROM (SELECT *, row_number() OVER (order by something) AS "num" FROM "schema"."table" WHERE "fake"."fieldX" = @1) "sub" WHERE "fake"."fieldX" = @2',
          ['valueY', 'valueX']),
    );
  });
}

dynamic Function() _test(SqlBuilder builder, String sql,
        [List substitutions = const []]) =>
    () => _expect(builder, sql, substitutions);

void _expect(SqlBuilder builder, String sql, [List substitutions = const []]) {
  final result = builder.buildSql();
  expect(result.toString(), equals(sql));
  expect(result.getSubstitutionValues().values, unorderedEquals(substitutions));
}
