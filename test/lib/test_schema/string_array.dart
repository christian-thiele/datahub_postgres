
import 'package:datahub/datahub.dart';


part 'string_array.g.dart';

@DaoType()
class StringArray extends _Dao {
  @PrimaryKeyDaoField()
  final int id;

  final List<String> values;

  StringArray({this.id = 0, required this.values});
}
