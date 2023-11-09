import 'dart:typed_data';

import 'package:datahub/datahub.dart';

import 'custom_enum.dart';

part 'string_array.g.dart';

@DaoType()
class StringArray extends _Dao {
  @PrimaryKeyDaoField()
  final int id;

  final List<String> values;

  StringArray({this.id = 0, required this.values});
}
