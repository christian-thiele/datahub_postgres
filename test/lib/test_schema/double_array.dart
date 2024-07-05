
import 'package:datahub/datahub.dart';


part 'double_array.g.dart';

@DaoType()
class DoubleArray extends _Dao {
  @PrimaryKeyDaoField()
  final int id;

  final List<double> values;

  DoubleArray({this.id = 0, required this.values});
}
