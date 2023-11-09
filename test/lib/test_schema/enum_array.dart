import 'package:datahub/datahub.dart';

import 'custom_enum.dart';

part 'enum_array.g.dart';

@DaoType()
class EnumArray extends _Dao {
  @PrimaryKeyDaoField()
  final int id;

  final List<CustomEnum> values;

  EnumArray({this.id = 0, required this.values});
}
