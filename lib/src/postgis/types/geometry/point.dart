import 'dart:typed_data';

import 'package:buffer/buffer.dart';

import 'byte_order.dart';
import 'geometry.dart';
import 'geometry_type.dart';

class Point extends Geometry {
  final double x;
  final double y;
  final double? z;
  final double? m;

  Point(int? SRID, this.x, this.y, [this.z, this.m])
      : super(SRID, GeometryType.point, z != null, m != null);

  factory Point.read(int? SRID, ByteDataReader reader, bool hasZ, bool hasM) {
    return Point(
      SRID,
      reader.readFloat64(),
      reader.readFloat64(),
      hasZ ? reader.readFloat64() : null,
      hasM ? reader.readFloat64() : null,
    );
  }

  @override
  Uint8List toBytes(ByteOrder byteOrder) {
    final builder = ByteDataWriter(endian: byteOrder.endian);
    builder.writeFloat64(x);
    builder.writeFloat64(y);
    if (z != null) {
      builder.writeFloat64(z!);
    }
    if (m != null) {
      builder.writeFloat64(m!);
    }
    return builder.toBytes();
  }

  @override
  String toString() {
    final buffer = StringBuffer('POINT ');
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
    final buffer = StringBuffer('($x $y');
    if (hasZ) {
      buffer.write(' $z');
    }
    if (hasM) {
      buffer.write(' $m');
    }
    buffer.write(')');
    return buffer.toString();
  }
}
