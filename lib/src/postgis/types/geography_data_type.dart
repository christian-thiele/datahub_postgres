import 'dart:typed_data';

import 'package:datahub/persistence.dart';
import 'package:datahub_postgres/datahub_postgres.dart';

import 'geometry/geometry.dart';

class GeographyDataType extends DataType<Geometry> {
  const GeographyDataType();
}

class PostgresqlGeographyDataType
    extends PostgresqlDataType<Geometry, GeographyDataType> {
  @override
  ParamSql getTypeSql(DataField<DataType> field) => ParamSql('geography');

  @override
  Geometry? toDaoValue(data) {
    if (data == null) {
      return null;
    }

    if (data is Uint8List) {
      return Geometry.parseEWKB(data);
    }

    throw Exception('Invalid geography data.');
  }

  @override
  ParamSql toPostgresValue(DataField<DataType>? field, Geometry? data) {
    if (data != null) {
      final sql = ParamSql('st_geomfromewkb');
      sql.add(
          ParamSql.param(data.toEWKB(), PostgreSQLDataType.byteArray)..wrap());
      return sql;
    } else {
      return ParamSql('NULL');
    }
  }
}
