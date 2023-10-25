import 'dart:typed_data';

import 'package:buffer/buffer.dart';

import 'byte_order.dart';
import 'geometry.dart';
import 'geometry_type.dart';
import 'line_string.dart';

class Polygon extends Geometry {
  final List<LineString> rings;

  Polygon(int? SRID, this.rings, bool hasZ, bool hasM)
      : super(SRID, GeometryType.polygon, hasZ, hasM);

  factory Polygon.read(int? SRID, ByteDataReader reader, bool hasZ, bool hasM) {
    final length = reader.readUint32();
    return Polygon(
      SRID,
      List.generate(
        length,
        (i) => Geometry.read(SRID, reader, hasZ, hasM) as LineString,
      ),
      hasZ,
      hasM,
    );
  }

  @override
  Uint8List toBytes(ByteOrder byteOrder) {
    final bytes = ByteDataWriter(endian: byteOrder.endian);
    bytes.writeUint32(rings.length);
    for (final ring in rings) {
      bytes.write(ring.toBytes(byteOrder));
    }
    return bytes.toBytes();
  }

  @override
  String toString() {
    final buffer = StringBuffer('POLYGON ');
    if (hasZ) {
      buffer.write('Z');
    }
    if (hasM) {
      buffer.write('M');
    }

    if (hasZ || hasM) {
      buffer.write(' ');
    }

    buffer.write(toText());
    return buffer.toString();
  }

  String toText() {
    return '(${rings.map((e) => e.toText()).join(',')})';
  }
}
