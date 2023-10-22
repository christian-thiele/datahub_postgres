import 'package:datahub/datahub.dart';

import 'text_entry.dart';

class CustomFieldSchema extends DataSchema {
  CustomFieldSchema()
      : super(
          'custom_field',
          1,
          [
            TextEntryDataBean,
          ],
        );
}
