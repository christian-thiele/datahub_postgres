import 'dart:async';

import 'package:datahub/datahub.dart';
import 'package:datahub/test.dart';
import 'package:datahub_postgres/datahub_postgres.dart';
import 'package:test/test.dart';

import 'lib/blogsystem/article_dao.dart';
import 'lib/blogsystem/blog_schema.dart';

void main() {
  final host = TestHost(
    [
      () => PostgreSQLDatabaseAdapter('postgres', BlogSchema()),
      () => CRUDRepository('postgres', ArticleDaoDataBean),
    ],
    args: ['test/config.yaml'],
  );

  group('Persistence', () {
    test('Blocking transactions (PostgreSQL)', host.test(() async {
      final repo = resolve<CRUDRepository<ArticleDao, int>>();
      final adapter = resolve<DatabaseAdapter>();
      print('Pool ${adapter.poolAvailable} / ${adapter.poolSize}');

      try {
        await repo.transaction((context) async {
          print('Blocking transaction.');
          print('Pool ${adapter.poolAvailable} / ${adapter.poolSize}');
          await countdown(3);
          print('Releasing transaction.');
        });
      } catch (e) {
        resolve<LogService>().error('Error', error: e);
      }
      print('Pool ${adapter.poolAvailable} / ${adapter.poolSize}');
    }), timeout: Timeout.none);
  });
}

Future<void> countdown(int seconds) async {
  for (var i = 0; i < seconds; i++) {
    print(seconds - i);
    await Future.delayed(const Duration(seconds: 1));
  }
}
