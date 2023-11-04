import 'dart:typed_data';

import 'package:datahub/datahub.dart';
import 'package:datahub/test.dart';
import 'package:datahub_postgres/datahub_postgres.dart';
import 'package:test/test.dart';

import 'lib/blogsystem/article_dao.dart';
import 'lib/blogsystem/blog_schema.dart';

void main() {
  final host = TestHost([
    () => PostgreSQLDatabaseAdapter('postgres', BlogSchema()),
    () => CRUDRepository('postgres', ArticleDaoDataBean),
  ], args: [
    'test/config.yaml'
  ], config: {
    'maxConnectionLifetime': 10,
  });

  group('Test Schema', () {
    test('Pool behavior (PostgreSQL)', host.test(() async {
      final article = ArticleDao(
        userId: 1,
        blogKey: 'abc',
        content: 'abc123',
        createdTimestamp: DateTime.now(),
        image: Uint8List(0),
        lastEditTimestamp: DateTime.now(),
        title: 'Test',
      );

      final repo = resolve<CRUDRepository<ArticleDao, int>>();
      final adapter = resolve<DatabaseAdapter>();
      expect(adapter.poolAvailable, 3);
      expect(adapter.poolSize, 3);

      Future<void> somethingStupid() async {
        await repo.transaction((context) async {
          print('Blocking transaction.');
          expect(adapter.poolAvailable, 1);
          await Future.delayed(const Duration(seconds: 5));
        });
        print('Released transaction.');
        expect(adapter.poolAvailable, 3);
      }

      final future = somethingStupid();

      final id = await repo.create(article);
      print('Created with id $id');
      final results = await repo.getAll();
      expect(results.length, greaterThan(0));

      expect(adapter.poolAvailable, 2);
      await future;

      await Future.delayed(const Duration(seconds: 10));

      expect(adapter.poolAvailable, 3);
      await repo.transaction((context) async {
        print((await repo.first())!.id);
        expect(adapter.poolAvailable, 2);
        await repo.transaction((context) async {
          print((await repo.first())!.id);
          expect(adapter.poolAvailable, 2);
        });
      });

      expect(adapter.poolAvailable, 3);
    }), timeout: Timeout.none);
  });
}
