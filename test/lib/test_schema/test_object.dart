import 'dart:typed_data';

import 'package:datahub/datahub.dart';

part 'test_object.g.dart';

@DaoType()
class TestObject extends _Dao {
  @PrimaryKeyDaoField()
  final int id;
  final String string;
  final bool boolean;
  final int intNumber;
  final double doubleNumber;
  final List<dynamic> jsonList;
  final Map<String, dynamic> jsonMap;
  final Uint8List bytes;
  final DateTime timestamp;

  TestObject({
    this.id = 0,
    required this.string,
    required this.boolean,
    required this.intNumber,
    required this.doubleNumber,
    required this.jsonList,
    required this.jsonMap,
    required this.bytes,
    required this.timestamp,
  });
}