import 'dart:typed_data';

import 'package:datahub/datahub.dart';
import 'package:datahub/test.dart';
import 'package:datahub_postgres/datahub_postgres.dart';
import 'package:test/test.dart';

import 'lib/test_schema/test_schema.dart';

void main() {
  final host = TestHost([
    () => PostgreSQLDatabaseAdapter('postgres', TestSchema()),
    () => CRUDRepository('postgres', TestObjectDataBean),
  ], args: [
    'test/config.yaml'
  ], config: {
    'maxConnectionLifetime': 10,
  });

  group('Test Schema', () {
    test('CRUD', host.test(() async {
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
  });
}
