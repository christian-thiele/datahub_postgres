import 'package:datahub/datahub.dart';
import 'package:datahub/test.dart';
import 'package:datahub_postgres/datahub_postgres.dart';
import 'package:datahub_postgres/postgis.dart';
import 'package:test/test.dart';

import 'lib/custom_field/custom_field_schema.dart';
import 'lib/custom_field/text_entry.dart';

void main() {
  final host = TestHost(
    [
      () => PostgreSQLDatabaseAdapter(
            'postgres',
            CustomFieldSchema(),
            types: [
              PostgresqlGeographyDataType(),
            ],
          ),
      () => CRUDRepository('postgres', TextEntryDataBean),
    ],
    args: ['test/config.yaml'],
  );

  group('Persistence', () {
    test('Repository (PostgreSQL)', host.test(() async {
      final repo = resolve<CRUDRepository<TextEntry, int>>();
      final thingy = await repo.getAll();
      for (var element in thingy) {
        print(element.position);
      }
    }), timeout: Timeout.none);
  });
}
