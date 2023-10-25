import 'dart:typed_data';

import 'package:buffer/buffer.dart';

import 'polygon.dart';
import 'byte_order.dart';
import 'geometry.dart';
import 'geometry_type.dart';

class MultiPolygon extends Geometry {
  final List<Polygon> polygons;

  MultiPolygon(int? SRID, this.polygons, bool hasZ, bool hasM)
      : super(SRID, GeometryType.multiPolygon, hasZ, hasM);

  factory MultiPolygon.read(
      int? SRID, ByteDataReader reader, bool hasZ, bool hasM) {
    final length = reader.readUint32();
    return MultiPolygon(
      SRID,
      List.generate(
        length,
        (i) => Geometry.read(SRID, reader, hasZ, hasM) as Polygon,
      ),
      hasZ,
      hasM,
    );
  }

  @override
  Uint8List toBytes(ByteOrder byteOrder) {
    final bytes = ByteDataWriter(endian: byteOrder.endian);
    bytes.writeUint32(polygons.length);
    for (final polygon in polygons) {
      bytes.write(polygon.toBytes(byteOrder));
    }
    return bytes.toBytes();
  }

  @override
  String toString() {
    final buffer = StringBuffer('MULTIPOLYGON ');
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
    return '(${polygons.map((e) => e.toText()).join(',')})';
  }
}
