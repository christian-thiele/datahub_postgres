import 'dart:typed_data';

import 'package:datahub/datahub.dart';

import 'custom_enum.dart';

part 'int_array.g.dart';

@DaoType()
class IntArray extends _Dao {
  @PrimaryKeyDaoField()
  final int id;

  final List<int> values;

  IntArray({this.id = 0, required this.values});
}
