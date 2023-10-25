import 'package:datahub/datahub.dart';
import 'package:datahub_postgres/datahub_postgres.dart';

/// For geometry types returns the minimum 2D Cartesian (planar) distance
/// between two geometries, in projected units (spatial ref units).
///
/// For geography types defaults to return the minimum geodesic distance
/// between two geographies in meters, compute on the spheroid determined by
/// the SRID. If use_spheroid is false, a faster spherical calculation is used.
Expression stDistance(Expression g1, Expression g2,
        {Expression? useSpheroid}) =>
    SqlExpression.function('ST_Distance', [
      g1,
      g2,
      if (useSpheroid != null) useSpheroid,
    ]);

/// Returns true if the geometries are within a given distance.
///
/// For geometry: The distance is specified in units defined by the spatial
/// reference system of the geometries. For this function to make sense, the
/// source geometries must be in the same coordinate system (have the same SRID).
///
/// For geography: units are in meters and distance measurement defaults to
/// use_spheroid = true. For faster evaluation use use_spheroid = false to
/// measure on the sphere.
Expression stDWithin(Expression g1, Expression g2, Expression tolerance,
        {Expression? useSpheroid}) =>
    SqlExpression.function('ST_DWithin', [
      g1,
      g2,
      tolerance,
      if (useSpheroid != null) useSpheroid,
    ]);
