import 'dart:convert';
import 'dart:typed_data';

import 'package:datahub/persistence.dart';
import 'package:postgres/postgres.dart';

import 'sql/sql.dart';

export 'package:postgres/postgres.dart' show PostgreSQLDataType;

abstract class PostgresqlDataType<T, TDataType extends DataType<T>> {
  Type get baseType => TDataType;

  const PostgresqlDataType();

  ParamSql getTypeSql(DataField field);

  ParamSql toPostgresValue(DataField? field, T? data);

  T? toDaoValue(dynamic data);

  bool appliesToValue(dynamic value) => value is T;
}

class PostgresqlStringDataType
    extends PostgresqlDataType<String, StringDataType> {
  const PostgresqlStringDataType();

  @override
  ParamSql getTypeSql(DataField field) {
    final length = field.length == 0 ? 255 : field.length;
    return ParamSql('varchar($length)');
  }

  @override
  String? toDaoValue(dynamic data) => data?.toString();

  @override
  ParamSql toPostgresValue(DataField? field, String? data) {
    return ParamSql.param(data, PostgreSQLDataType.unknownType);
  }
}

class PostgresqlIntDataType extends PostgresqlDataType<int, IntDataType> {
  const PostgresqlIntDataType();

  @override
  ParamSql getTypeSql(DataField field) {
    if (field is PrimaryKey && field.autoIncrement) {
      if (field.length == 16) {
        return ParamSql('smallserial');
      } else if (field.length == 32) {
        return ParamSql('serial');
      } else if (field.length == 64 || field.length == 0) {
        return ParamSql('bigserial');
      } else {
        throw PersistenceException(
            'PostgreSQL implementation does not support serial length ${field.length}.'
            ' Only 32 or 64 allowed.)');
      }
    } else {
      if (field.length == 16) {
        return ParamSql('int2');
      } else if (field.length == 32) {
        return ParamSql('int4');
      } else if (field.length == 64 || field.length == 0) {
        return ParamSql('int8');
      } else {
        throw PersistenceException(
            'PostgreSQL implementation does not support int length ${field.length}.'
            ' Only 16, 32 or 64 allowed.)');
      }
    }
  }

  @override
  int? toDaoValue(data) {
    if (data == null) {
      return null;
    }

    if (data is int) {
      return data;
    }

    if (data is num) {
      return data.toInt();
    }

    throw PersistenceException(
        'Invalid result type for PostgresqlIntDataType.');
  }

  @override
  ParamSql toPostgresValue(DataField? field, int? data) {
    if (field?.length == 32) {
      return ParamSql.param<Object>(data, PostgreSQLDataType.unknownType);
    } else if (field == null || field.length == 64 || field.length == 0) {
      return ParamSql.param<Object>(data, PostgreSQLDataType.unknownType);
    } else {
      throw PersistenceException(
          'PostgreSQL implementation does not support int length ${field.length}.'
          'Only 32 or 64 allowed.)');
    }
  }
}

class PostgresqlBoolDataType extends PostgresqlDataType<bool, BoolDataType> {
  const PostgresqlBoolDataType();

  @override
  ParamSql getTypeSql(DataField field) => ParamSql('boolean');

  @override
  bool? toDaoValue(data) {
    if (data == null) {
      return null;
    }

    if (data is bool) {
      return data;
    }

    if (data is num) {
      return data > 0;
    }

    throw PersistenceException(
        'Invalid result type for PostgresqlBoolDataType.');
  }

  @override
  ParamSql toPostgresValue(DataField? field, bool? data) =>
      ParamSql.param<Object>(data, PostgreSQLDataType.unknownType);
}

class PostgresqlDoubleDataType
    extends PostgresqlDataType<double, DoubleDataType> {
  const PostgresqlDoubleDataType();

  @override
  ParamSql getTypeSql(DataField field) {
    if (field.length == 32) {
      return ParamSql('real');
    } else if (field.length == 64 || field.length == 0) {
      return ParamSql('double precision');
    } else {
      throw PersistenceException(
          'PostgreSQL implementation does not support int length ${field.length}.'
          'Only 16, 32 or 64 allowed.)');
    }
  }

  @override
  double? toDaoValue(data) {
    if (data == null) {
      return null;
    }

    if (data is num) {
      return data.toDouble();
    }

    throw PersistenceException(
        'Invalid result type for PostgresqlIntDataType.');
  }

  @override
  ParamSql toPostgresValue(DataField? field, double? data) =>
      ParamSql.param<Object>(data, PostgreSQLDataType.unknownType);
}

class PostgresqlDateTimeDataType
    extends PostgresqlDataType<DateTime, DateTimeDataType> {
  const PostgresqlDateTimeDataType();

  @override
  ParamSql getTypeSql(DataField field) => ParamSql('timestamp with time zone');

  @override
  DateTime? toDaoValue(data) {
    if (data == null) {
      return null;
    }

    if (data is DateTime) {
      return data;
    }

    if (data is int) {
      return DateTime.fromMillisecondsSinceEpoch(data);
    }

    if (data is String) {
      return DateTime.parse(data);
    }

    throw PersistenceException(
        'Invalid result type for PostgresqlDateTimeDataType.');
  }

  @override
  ParamSql toPostgresValue(DataField? field, DateTime? data) =>
      ParamSql.param<Object>(data, PostgreSQLDataType.unknownType);
}

class PostgresqlByteDataType
    extends PostgresqlDataType<Uint8List, ByteDataType> {
  const PostgresqlByteDataType();

  @override
  ParamSql getTypeSql(DataField field) => ParamSql('bytea');

  @override
  Uint8List? toDaoValue(data) {
    if (data == null) {
      return null;
    }

    if (data is Uint8List) {
      return data;
    }

    //TODO parse data

    throw PersistenceException(
        'Invalid result type for PostgresqlByteDataType.');
  }

  @override
  ParamSql toPostgresValue(DataField? field, Uint8List? data) =>
      ParamSql.param<List<int>>(data, PostgreSQLDataType.byteArray);
}

class PostgresqlJsonMapDataType
    extends PostgresqlDataType<Map<String, dynamic>, JsonMapDataType> {
  const PostgresqlJsonMapDataType();

  @override
  ParamSql getTypeSql(DataField field) => ParamSql('jsonb');

  @override
  Map<String, dynamic>? toDaoValue(data) {
    if (data == null) {
      return null;
    }

    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is String) {
      return jsonDecode(data) as Map<String, dynamic>;
    }

    throw PersistenceException(
        'Invalid result type for PostgresqlJsonMapDataType.');
  }

  @override
  ParamSql toPostgresValue(DataField? field, Map<String, dynamic>? data) {
    return ParamSql.param(jsonEncode(data), PostgreSQLDataType.unknownType);
  }
}

class PostgresqlJsonListDataType
    extends PostgresqlDataType<List<dynamic>, JsonListDataType> {
  const PostgresqlJsonListDataType();

  @override
  ParamSql getTypeSql(DataField field) => ParamSql('jsonb');

  @override
  List<dynamic>? toDaoValue(data) {
    if (data == null) {
      return null;
    }

    if (data is List<dynamic>) {
      return data;
    }

    if (data is String) {
      return jsonDecode(data) as List<dynamic>;
    }

    throw PersistenceException(
        'Invalid result type ${data.runtimeType} for PostgresqlJsonListDataType.');
  }

  @override
  ParamSql toPostgresValue(DataField? field, List<dynamic>? data) {
    return ParamSql.param(jsonEncode(data), PostgreSQLDataType.unknownType);
  }
}

class PostgresqlStringArrayDataType
    extends PostgresqlDataType<List<String>, StringArrayDataType> {
  const PostgresqlStringArrayDataType();

  @override
  ParamSql getTypeSql(DataField field) {
    final length = field.length == 0 ? 255 : field.length;
    return ParamSql('varchar($length)[]');
  }

  @override
  List<String>? toDaoValue(data) {
    if (data == null) {
      return null;
    }

    if (data is List<String>) {
      return data;
    }

    throw PersistenceException(
        'Invalid result type ${data.runtimeType} for PostgresqlStringArrayDataType.');
  }

  @override
  ParamSql toPostgresValue(DataField? field, List<dynamic>? data) {
    final sanitized =
        data?.map((e) => e is Enum ? e.name : e.toString()).toList();
    return ParamSql.param(sanitized, PostgreSQLDataType.unknownType);
  }
}

class PostgresqlIntArrayDataType
    extends PostgresqlDataType<List<int>, IntArrayDataType> {
  const PostgresqlIntArrayDataType();

  @override
  ParamSql getTypeSql(DataField field) {
    if (field.length == 16) {
      return ParamSql('int2[]');
    } else if (field.length == 32) {
      return ParamSql('int4[]');
    } else if (field.length == 64 || field.length == 0) {
      return ParamSql('int8[]');
    } else {
      throw PersistenceException(
          'PostgreSQL implementation does not support int length ${field.length}.'
          ' Only 16, 32 or 64 allowed.)');
    }
  }

  @override
  List<int>? toDaoValue(data) {
    if (data == null) {
      return null;
    }

    if (data is List<int>) {
      return data;
    }

    throw PersistenceException(
        'Invalid result type ${data.runtimeType} for PostgresqlIntArrayDataType.');
  }

  @override
  ParamSql toPostgresValue(DataField? field, List<int>? data) {
    return ParamSql.param(data, PostgreSQLDataType.unknownType);
  }
}

class PostgresqlDoubleArrayDataType
    extends PostgresqlDataType<List<double>, DoubleArrayDataType> {
  const PostgresqlDoubleArrayDataType();

  @override
  ParamSql getTypeSql(DataField field) {
    if (field.length == 32) {
      return ParamSql('real[]');
    } else if (field.length == 64 || field.length == 0) {
      return ParamSql('double precision[]');
    } else {
      throw PersistenceException(
          'PostgreSQL implementation does not support int length ${field.length}.'
          'Only 16, 32 or 64 allowed.)');
    }
  }

  @override
  List<double>? toDaoValue(data) {
    if (data == null) {
      return null;
    }

    if (data is List<double>) {
      return data;
    }

    throw PersistenceException(
        'Invalid result type ${data.runtimeType} for PostgresqlDoubleArrayDataType.');
  }

  @override
  ParamSql toPostgresValue(DataField? field, List<double>? data) {
    return ParamSql.param(data, PostgreSQLDataType.unknownType);
  }
}

class PostgresqlBoolArrayDataType
    extends PostgresqlDataType<List<bool>, BoolArrayDataType> {
  const PostgresqlBoolArrayDataType();

  @override
  ParamSql getTypeSql(DataField field) => ParamSql('boolean[]');

  @override
  List<bool>? toDaoValue(data) {
    if (data == null) {
      return null;
    }

    if (data is List<bool>) {
      return data;
    }

    throw PersistenceException(
        'Invalid result type ${data.runtimeType} for PostgresqlBoolArrayDataType.');
  }

  @override
  ParamSql toPostgresValue(DataField? field, List<bool>? data) {
    return ParamSql.param(data, PostgreSQLDataType.unknownType);
  }
}
