import 'dart:typed_data';

import 'package:datahub/datahub.dart';

import 'custom_enum.dart';

part 'double_array.g.dart';

@DaoType()
class DoubleArray extends _Dao {
  @PrimaryKeyDaoField()
  final int id;

  final List<double> values;

  DoubleArray({this.id = 0, required this.values});
}
