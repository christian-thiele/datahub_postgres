import 'dart:typed_data';

import 'package:datahub/datahub.dart';

import 'custom_enum.dart';

part 'bool_array.g.dart';

@DaoType()
class BoolArray extends _Dao {
  @PrimaryKeyDaoField()
  final int id;

  final List<bool> values;

  BoolArray({this.id = 0, required this.values});
}
