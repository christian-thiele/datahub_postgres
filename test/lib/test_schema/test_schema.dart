import 'package:datahub/datahub.dart';

import 'test_object.dart';

export 'test_object.dart';

class TestSchema extends DataSchema {
  TestSchema()
      : super(
          'test_${DateTime.timestamp().millisecondsSinceEpoch}',
          1,
          [
            TestObjectDataBean,
          ],
        );
}
