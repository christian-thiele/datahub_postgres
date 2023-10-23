import 'dart:typed_data';

import 'package:buffer/buffer.dart';

import 'geometry_collection.dart';
import 'line_string.dart';
import 'byte_order.dart';
import 'geometry_type.dart';
import 'multi_line_string.dart';
import 'multi_point.dart';
import 'multi_polygon.dart';
import 'point.dart';
import 'polygon.dart';

const wkbZ = 0x80000000;
const wkbM = 0x40000000;
const wkbSRID = 0x20000000;

abstract class Geometry {
  final int? SRID;
  final GeometryType type;
  final bool hasZ;
  final bool hasM;

  Geometry(this.SRID, this.type, this.hasZ, this.hasM);

  static Geometry parseEWKB(Uint8List bytes) {
    final byteOrder = ByteOrder.read(bytes.first);

    final reader = ByteDataReader(endian: byteOrder.endian);
    reader.add(bytes);
    reader.readInt8();

    final typeDef = reader.readUint32();
    final hasZ = typeDef & wkbZ != 0;
    final hasM = typeDef & wkbM != 0;
    final hasSRID = typeDef & wkbSRID != 0;

    final baseType = typeDef & ~wkbZ & ~wkbM & ~wkbSRID;
    final type = GeometryType.read(baseType);

    final SRID = hasSRID ? reader.readUint32() : null;

    switch (type) {
      case GeometryType.point:
        return Point.read(SRID, reader, hasZ, hasM);
      case GeometryType.lineString:
        return LineString.read(SRID, reader, hasZ, hasM);
      case GeometryType.polygon:
        return Polygon.read(SRID, reader, hasZ, hasM);
      case GeometryType.multiPoint:
        return MultiPoint.read(SRID, reader, hasZ, hasM);
      case GeometryType.multiLineString:
        return MultiLineString.read(SRID, reader, hasZ, hasM);
      case GeometryType.multiPolygon:
        return MultiPolygon.read(SRID, reader, hasZ, hasM);
      case GeometryType.geometryCollection:
        return GeometryCollection.read(SRID, reader, hasZ, hasM);
    }
  }

  static Geometry read(int? SRID, ByteDataReader reader, bool hasZ, bool hasM) {
    reader.readUint8();
    final typeDef = reader.readUint32();
    final baseType = typeDef & ~wkbZ & ~wkbM & ~wkbSRID;
    final type = GeometryType.read(baseType);

    switch (type) {
      case GeometryType.point:
        return Point.read(SRID, reader, hasZ, hasM);
      case GeometryType.lineString:
        return LineString.read(SRID, reader, hasZ, hasM);
      case GeometryType.polygon:
        return Polygon.read(SRID, reader, hasZ, hasM);
      case GeometryType.multiPoint:
        return MultiPoint.read(SRID, reader, hasZ, hasM);
      case GeometryType.multiLineString:
        return MultiLineString.read(SRID, reader, hasZ, hasM);
      case GeometryType.multiPolygon:
        return MultiPolygon.read(SRID, reader, hasZ, hasM);
      case GeometryType.geometryCollection:
        return GeometryCollection.read(SRID, reader, hasZ, hasM);
    }
  }

  Uint8List toEWKB({ByteOrder byteOrder = ByteOrder.wkbNDR}) {
    final builder = ByteDataWriter(endian: byteOrder.endian);
    builder.writeInt8(byteOrder.id);
    final typeInt = type.id |
        (SRID != null ? wkbSRID : 0) |
        (hasZ ? wkbZ : 0) |
        (hasM ? wkbM : 0);
    builder.writeInt32(typeInt);
    if (SRID != null) {
      builder.writeInt32(SRID!);
    }

    builder.write(toBytes(byteOrder));
    return builder.toBytes();
  }

  Uint8List toBytes(ByteOrder byteOrder);
}
