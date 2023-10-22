import 'dart:typed_data';

import 'package:boost/boost.dart';
import 'package:datahub_postgres/wkb/wkb.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('EWKB', () {
    test('Decode Point', () {
      final bytes = hex2Bin('0101000020E6100000534145D5AF242740151DC9E53F784940');
      final geo = parseWkb(bytes) as Point;
      print(geo.srid);
      print(geo.x);
      print(geo.y);
      print(geo.z);
      print(geo.m);
    });

    test('Encode Point', () {
      final point = Point(4326, 10, 51, null, null);
      final bytes = point.toEWKB();
      print(bytes.toHexString());
    });
  });
}

Uint8List hex2Bin(String hex) {
  final intList = <int>[];
  var pos = 0;
  while (pos < hex.length) {
    intList.add(int.parse(hex.substring(pos, pos + 2), radix: 16));
    pos += 2;
  }
  return Uint8List.fromList(intList);
}