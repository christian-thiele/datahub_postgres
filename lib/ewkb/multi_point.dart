import 'dart:typed_data';

import 'package:buffer/buffer.dart';

import 'byte_order.dart';
import 'geometry.dart';
import 'geometry_type.dart';

import 'point.dart';

class MultiPoint extends Geometry {
  final List<Point> points;

  MultiPoint(int? SRID, this.points, bool hasZ, bool hasM)
      : super(SRID, GeometryType.multiPoint, hasZ, hasM);

  factory MultiPoint.read(
      int? SRID, ByteDataReader reader, bool hasZ, bool hasM) {
    final length = reader.readUint32();
    return MultiPoint(
      SRID,
      List.generate(length, (i) => Geometry.read(SRID, reader, hasZ, hasM) as Point),
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
    final buffer = StringBuffer('MULTIPOINT ');
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
