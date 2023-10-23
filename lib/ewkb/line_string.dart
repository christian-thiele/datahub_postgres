import 'dart:typed_data';

import 'package:buffer/buffer.dart';

import 'byte_order.dart';
import 'geometry.dart';
import 'geometry_type.dart';

import 'point.dart';

class LineString extends Geometry {
  final List<Point> points;

  LineString(int? SRID, this.points, bool hasZ, bool hasM)
      : super(SRID, GeometryType.lineString, hasZ, hasM);

  factory LineString.read(
      int? SRID, ByteDataReader reader, bool hasZ, bool hasM) {
    final length = reader.readUint32();
    return LineString(
      SRID,
      List.generate(
        length,
        (i) => Geometry.read(SRID, reader, hasZ, hasM) as Point,
      ),
      hasZ,
      hasM,
    );
  }

  @override
  Uint8List toBytes(ByteOrder byteOrder) {
    final bytes = ByteDataWriter(endian: byteOrder.endian);
    bytes.writeUint32(points.length);
    for (final point in points) {
      bytes.write(point.toBytes(byteOrder));
    }
    return bytes.toBytes();
  }

  @override
  String toString() {
    final buffer = StringBuffer('LINESTRING ');
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
    return '(${points.map((e) => e.toText()).join(',')})';
  }
}
