import 'dart:io';

import 'package:datahub/datahub.dart';
import 'package:datahub/test.dart';
import 'package:datahub_postgres/datahub_postgres.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'lib/blogsystem/blog_schema.dart';

void main() {
  TestHost([
    () => PostgreSQLDatabaseAdapter('postgres', BlogSchema()),
  ], args: [
    'test/config.yaml'
  ]).declare((host) {
    host.test('SocketError handling', () async {
      final postgres = resolve<PostgreSQLDatabaseAdapter>();
      expect(
          () async => await postgres.useConnection(
                (connection) async {
                  await connection.runTransaction((context) async {
                    await Future.delayed(const Duration(milliseconds: 100));
                    throw SocketException('Test');
                  });
                },
              ),
          throwsA(isA<SocketException>()));
    }, timeout: Timeout.none);
  });
}
