import 'package:datahub/datahub.dart';
import 'package:datahub_postgres/postgis.dart';

part 'text_entry.g.dart';

@DaoType()
class TextEntry extends _Dao {
  @PrimaryKeyDaoField()
  final int id;
  @DaoField(length: 1024)
  final String text;
  final String author;
  @DaoField(type: GeographyDataType)
  final Geometry position;

  TextEntry({
    this.id = 0,
    required this.text,
    required this.author,
    required this.position,
  });
}
