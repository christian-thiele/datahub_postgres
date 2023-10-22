import 'dart:typed_data';

import 'package:buffer/buffer.dart';

const wkbZ = 0x80000000;
const wkbM = 0x40000000;
const wkbSRID = 0x20000000;

enum GeometryType {
  point(1),
  lineString(2),
  polygon(3),
  multiPoint(4),
  multiLineString(5),
  multiPolygon(6),
  geometryCollection(7);

  const GeometryType(this.id);

  final int id;

  static GeometryType read(int id) =>
      GeometryType.values.firstWhere((e) => e.id == id);
}

enum ByteOrder {
  wkbXDR(0, Endian.big),
  wkbNDR(1, Endian.little);

  const ByteOrder(this.id, this.endian);

  final int id;
  final Endian endian;

  static ByteOrder read(int id) =>
      ByteOrder.values.firstWhere((e) => e.id == id);
}

abstract class Geometry {
  final int? srid;

  Geometry(this.srid);

  Uint8List toEWKB();
}

class Point extends Geometry {
  final double x;
  final double y;
  final double? z;
  final double? m;

  Point(super.srid, this.x, this.y, this.z, this.m);

  factory Point.read(int? srid, ByteDataReader reader, bool hasZ, bool hasM) {
    return Point(
      srid,
      reader.readFloat64(),
      reader.readFloat64(),
      hasZ ? reader.readFloat64() : null,
      hasM ? reader.readFloat64() : null,
    );
  }

  @override
  Uint8List toEWKB({ByteOrder byteOrder = ByteOrder.wkbNDR}) {
    final builder = ByteDataWriter(endian: byteOrder.endian);
    builder.writeInt8(byteOrder.id);
    final type = GeometryType.point.id |
        (srid != null ? wkbSRID : 0) |
        (z != null ? wkbZ : 0) |
        (m != null ? wkbM : 0);
    builder.writeInt32(type);
    if (srid != null) {
      builder.writeInt32(srid!);
    }

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
}

Geometry parseWkb(Uint8List bytes) {
  final byteOrder = ByteOrder.read(bytes.first);

  final reader = ByteDataReader(endian: byteOrder.endian);
  reader.add(bytes);
  reader.readInt8();

  final typeDef = reader.readUint32();
  final hasZ = typeDef & wkbZ != 0;
  final hasM = typeDef & wkbM != 0;
  final hasSrid = typeDef & wkbSRID != 0;

  final baseType = typeDef & ~wkbZ & ~wkbM & ~wkbSRID;
  final type = GeometryType.read(baseType);

  int? srid;
  if (hasSrid) {
    srid = reader.readUint32();
  }

  switch (type) {
    case GeometryType.point:
      return Point.read(srid, reader, hasZ, hasM);
    default:
      throw Exception('Type $type not implemented yet.');
  }
}

class ByteReader {
  final ByteData data;
  var endian = Endian.little;
  var _position = 0;

  ByteReader(this.data);

  int readUint8() {
    final value = data.getUint8(_position);
    _position += 1;
    return value;
  }

  int readUint32() {
    final value = data.getUint32(_position, endian);
    _position += 4;
    return value;
  }

  double readDouble32() {
    final value = data.getFloat64(_position, endian);
    _position += 8;
    return value;
  }
}
