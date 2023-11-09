import 'package:datahub/datahub.dart';

import 'bool_array.dart';
import 'double_array.dart';
import 'enum_array.dart';
import 'string_array.dart';
import 'int_array.dart';
import 'test_object.dart';

export 'test_object.dart';

class TestSchema extends DataSchema {
  TestSchema()
      : super(
          'test_${DateTime.timestamp().millisecondsSinceEpoch}',
          1,
          [
            TestObjectDataBean,
            StringArrayDataBean,
            IntArrayDataBean,
            DoubleArrayDataBean,
            BoolArrayDataBean,
            EnumArrayDataBean,
          ],
        );
}
