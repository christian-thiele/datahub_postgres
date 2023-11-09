import 'dart:typed_data';

import 'package:datahub/datahub.dart';
import 'package:datahub/test.dart';
import 'package:datahub_postgres/datahub_postgres.dart';
import 'package:test/test.dart';

import 'lib/test_schema/bool_array.dart';
import 'lib/test_schema/custom_enum.dart';
import 'lib/test_schema/double_array.dart';
import 'lib/test_schema/enum_array.dart';
import 'lib/test_schema/int_array.dart';
import 'lib/test_schema/string_array.dart';
import 'lib/test_schema/test_schema.dart';

void main() {
  final host = TestHost(
    [
      () => PostgreSQLDatabaseAdapter('postgres', TestSchema()),
      () => CRUDRepository('postgres', TestObjectDataBean),
      () => CRUDRepository('postgres', StringArrayDataBean),
      () => CRUDRepository('postgres', IntArrayDataBean),
      () => CRUDRepository('postgres', DoubleArrayDataBean),
      () => CRUDRepository('postgres', BoolArrayDataBean),
      () => CRUDRepository('postgres', EnumArrayDataBean),
    ],
    args: ['test/config.yaml'],
    config: {
      'postgres': {
        'poolSize': 1,
      },
    },
  );

  group('Test Schema', () {
    test('Simple CRUD', host.test(() async {
      final repo = resolve<CRUDRepository<TestObject, int>>();
      expect(await repo.count(), 0);

      final testObject = TestObject(
        string: 'string',
        boolean: true,
        intNumber: 4,
        doubleNumber: 12.3,
        jsonList: [
          1,
          2,
          3.5,
          true,
          "abc",
          {"someProperty": "value"},
          [1, 2, 3],
        ],
        jsonMap: {"someProperty": "v"},
        bytes: Uint8List.fromList([1, 2, 3, 255, 244, 233]),
        timestamp: DateTime.timestamp(),
        enumValue: CustomEnum.something,
        enumValues: [],
      );

      final id = await repo.create(testObject);
      expect(id, 1);

      final id2 = await repo.create(testObject.copyWith(boolean: false));
      expect(id2, 2);

      expect(await repo.count(), 2);

      final falseResults =
          await repo.getAll(filter: TestObjectDataBean.boolean.equals(false));
      expect(falseResults.length, 1);

      final trueResults =
          await repo.getAll(filter: TestObjectDataBean.boolean.equals(true));
      expect(trueResults.length, 1);

      await repo.deleteById(id);

      expect(await repo.count(), 1);

      expect(TestObjectDataBean.unmap(trueResults.first),
          equals(TestObjectDataBean.unmap(testObject)));

      await repo.update(testObject.copyWith(id: id2, doubleNumber: 55));

      expect(
          TestObjectDataBean.unmap((await repo.findById(id2))!),
          equals(TestObjectDataBean.unmap(
              testObject.copyWith(id: id2, doubleNumber: 55))));
    }));

    test('Filter equals', host.test(() async {
      final repo = resolve<CRUDRepository<TestObject, int>>();
      await _populate(repo);
      expect(
          await repo.count(filter: TestObjectDataBean.string.equals('string')),
          1);
      expect(await repo.count(filter: TestObjectDataBean.string.equals(1)), 0);
      expect(await repo.count(filter: TestObjectDataBean.string.equals('test')),
          1);
      expect(
          await repo.count(filter: TestObjectDataBean.string.equals('test22')),
          0);
      expect(
          await repo.count(filter: TestObjectDataBean.boolean.equals(true)), 1);
      expect(await repo.count(filter: TestObjectDataBean.boolean.equals(false)),
          1);
      expect(
          await repo.count(filter: TestObjectDataBean.intNumber.equals(1)), 0);
      expect(
          await repo.count(filter: TestObjectDataBean.intNumber.equals(4)), 2);
      expect(
          await repo.count(
              filter: TestObjectDataBean.doubleNumber.equals(12.3)),
          2);
      expect(
          await repo.count(
              filter: TestObjectDataBean.doubleNumber.equals(12.4)),
          0);
      expect(
          await repo.count(
              filter: TestObjectDataBean.bytes
                  .equals(Uint8List.fromList([1, 2, 3, 255, 244, 233]))),
          2);
      expect(
          await repo.count(
              filter: TestObjectDataBean.bytes
                  .equals(Uint8List.fromList([1, 2, 3, 245, 244, 233]))),
          0);
      expect(
          await repo.count(
            filter: TestObjectDataBean.enumValue.equals(CustomEnum.something),
          ),
          1);
      expect(
          await repo.count(
            filter:
                TestObjectDataBean.enumValue.equals(CustomEnum.somethingElse),
          ),
          0);
    }));

    test('Filter isIn', host.test(() async {
      final repo = resolve<CRUDRepository<TestObject, int>>();
      await _populate(repo);
      expect(
        await repo.count(
            filter: TestObjectDataBean.string.isIn(['abc', 'string'])),
        1,
      );
      expect(
        await repo.count(
            filter: TestObjectDataBean.string.isIn(['abc', '123'])),
        0,
      );
      expect(
        await repo.count(filter: TestObjectDataBean.string.isIn(['test'])),
        1,
      );
      expect(
        await repo.count(filter: TestObjectDataBean.string.isIn(null)),
        0,
      );
      expect(
        await repo.count(filter: TestObjectDataBean.string.isIn([])),
        0,
      );
      expect(
        await repo.count(filter: TestObjectDataBean.intNumber.isIn([2, 3, 4])),
        2,
      );
      expect(
        await repo.count(filter: TestObjectDataBean.intNumber.isIn([2, 3, 1])),
        0,
      );
      expect(
        await repo.count(
            filter: TestObjectDataBean.doubleNumber.isIn([2.3, 12.3, 1])),
        2,
      );
      expect(
        await repo.count(
            filter:
                TestObjectDataBean.doubleNumber.isIn([12.2, 2.3, 12.300001])),
        0,
      );
      expect(
        await repo.count(
            filter: TestObjectDataBean.enumValue
                .isIn([CustomEnum.something, CustomEnum.value3])),
        2,
      );
      expect(
        await repo.count(
            filter: TestObjectDataBean.enumValue
                .isIn([CustomEnum.somethingElse, CustomEnum.value4])),
        0,
      );
      expect(
        await repo.count(
            filter: ValueExpression(CustomEnum.something)
                .isIn(TestObjectDataBean.enumValues)),
        1,
      );
      expect(
        await repo.count(
            filter: ValueExpression(CustomEnum.value3)
                .isIn(TestObjectDataBean.enumValues)),
        2,
      );
    }));

    test('String Array', host.test(() async {
      final repo = resolve<CRUDRepository<StringArray, int>>();
      final emptyId = await repo.create(StringArray(values: []));
      final filledId =
          await repo.create(StringArray(values: ['test1', 'blabla']));

      expect(await repo.count(), 2);
      expect(
          await repo.count(
              filter:
                  ValueExpression('test1').isIn(StringArrayDataBean.values)),
          1);
      expect(
          await repo.count(
              filter:
                  ValueExpression('blablubb').isIn(StringArrayDataBean.values)),
          0);

      final empty = await repo.findById(emptyId);
      expect(empty?.values, []);

      final filled = await repo.findById(filledId);
      expect(filled?.values, ['test1', 'blabla']);
    }));

    test('Int Array', host.test(() async {
      final repo = resolve<CRUDRepository<IntArray, int>>();
      final emptyId = await repo.create(IntArray(values: []));
      final filledId = await repo.create(IntArray(values: [1, 5, 7]));

      expect(await repo.count(), 2);
      expect(
          await repo.count(
              filter: ValueExpression(5).isIn(IntArrayDataBean.values)),
          1);
      expect(
          await repo.count(
              filter: ValueExpression(3).isIn(IntArrayDataBean.values)),
          0);

      final empty = await repo.findById(emptyId);
      expect(empty?.values, []);

      final filled = await repo.findById(filledId);
      expect(filled?.values, [1, 5, 7]);
    }));

    test('Double Array', host.test(() async {
      final repo = resolve<CRUDRepository<DoubleArray, int>>();
      final emptyId = await repo.create(DoubleArray(values: []));
      final filledId = await repo.create(DoubleArray(values: [1.3, 5.2, 7]));

      expect(await repo.count(), 2);
      expect(
          await repo.count(
              filter: ValueExpression(5.2).isIn(DoubleArrayDataBean.values)),
          1);
      expect(
          await repo.count(
              filter: ValueExpression(3.1).isIn(DoubleArrayDataBean.values)),
          0);

      final empty = await repo.findById(emptyId);
      expect(empty?.values, []);

      final filled = await repo.findById(filledId);
      expect(filled?.values, [1.3, 5.2, 7]);
    }));

    test('Bool Array', host.test(() async {
      final repo = resolve<CRUDRepository<BoolArray, int>>();
      final emptyId = await repo.create(BoolArray(values: []));
      final filledId =
          await repo.create(BoolArray(values: [true, false, true]));

      expect(await repo.count(), 2);
      expect(
          await repo.count(
              filter: ValueExpression(true).isIn(BoolArrayDataBean.values)),
          1);
      expect(
          await repo.count(
              filter: ValueExpression(false).isIn(BoolArrayDataBean.values)),
          1);

      final empty = await repo.findById(emptyId);
      expect(empty?.values, []);

      final filled = await repo.findById(filledId);
      expect(filled?.values, [true, false, true]);
    }));

    test('Enum Array', host.test(() async {
      final repo = resolve<CRUDRepository<EnumArray, int>>();
      final emptyId = await repo.create(EnumArray(values: []));
      final filledId = await repo.create(EnumArray(values: [
        CustomEnum.something,
        CustomEnum.value3,
        CustomEnum.somethingElse
      ]));

      expect(await repo.count(), 2);
      expect(
          await repo.count(
              filter: ValueExpression(CustomEnum.value3)
                  .isIn(EnumArrayDataBean.values)),
          1);
      expect(
          await repo.count(
              filter: ValueExpression(CustomEnum.value4)
                  .isIn(EnumArrayDataBean.values)),
          0);

      final empty = await repo.findById(emptyId);
      expect(empty?.values, []);

      final filled = await repo.findById(filledId);
      expect(filled?.values,
          [CustomEnum.something, CustomEnum.value3, CustomEnum.somethingElse]);
    }));
  });
}

Future<void> _populate(CRUDRepository<TestObject, int> repo) async {
  expect(await repo.count(), 0);

  final testObject = TestObject(
    string: 'string',
    boolean: true,
    intNumber: 4,
    doubleNumber: 12.3,
    jsonList: [
      1,
      2,
      3.5,
      true,
      "abc",
      {"someProperty": "value"},
      [1, 2, 3],
    ],
    jsonMap: {"someProperty": "v"},
    bytes: Uint8List.fromList([1, 2, 3, 255, 244, 233]),
    timestamp: DateTime.timestamp(),
    enumValue: CustomEnum.something,
    enumValues: [CustomEnum.somethingElse, CustomEnum.value3],
  );

  final id = await repo.create(testObject);
  expect(id, 1);

  final testObject2 = TestObject(
    string: 'test',
    boolean: false,
    intNumber: 4,
    doubleNumber: 12.3,
    jsonList: [
      1,
      2,
      3.5,
      true,
      "abc",
      {"someProperty": "value"},
      [1, 2, 3],
    ],
    jsonMap: {"someProperty": "v"},
    bytes: Uint8List.fromList([1, 2, 3, 255, 244, 233]),
    timestamp: DateTime.timestamp(),
    enumValue: CustomEnum.value3,
    enumValues: [CustomEnum.something, CustomEnum.value3],
  );

  final id2 = await repo.create(testObject2);
  expect(id2, 2);
}
