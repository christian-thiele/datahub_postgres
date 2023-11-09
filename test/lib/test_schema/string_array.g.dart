// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'string_array.dart';

// **************************************************************************
// CopyWithExtensionGenerator
// **************************************************************************

extension StringArrayCopyExtension on StringArray {
  StringArray copyWith({
    int? id,
    List<String>? values,
  }) {
    return StringArray(
      id: id ?? this.id,
      values: values ?? this.values,
    );
  }
}

// **************************************************************************
// DataBeanGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names

final StringArrayDataBean = _StringArrayDataBeanImpl._();

class _StringArrayDataBeanImpl extends PrimaryKeyDataBean<StringArray, int> {
  @override
  final layoutName = 'string_array';

  @override
  PrimaryKey get primaryKey => id;

  _StringArrayDataBeanImpl._();

  final id = PrimaryKey<IntDataType>(
    layoutName: 'string_array',
    name: 'id',
    length: 0,
    autoIncrement: true,
  );

  final values = DataField<StringArrayDataType>(
    layoutName: 'string_array',
    name: 'values',
    nullable: false,
    length: 0,
  );

  @override
  late final fields = [
    id,
    values,
  ];

  @override
  Map<DataField, dynamic> unmap(StringArray dao,
      {bool includePrimaryKey = false}) {
    return {
      if (includePrimaryKey) id: dao.id,
      values: dao.values,
    };
  }

  @override
  StringArray mapValues(Map<String, dynamic> data) {
    return StringArray(
      id: data['id'],
      values: decodeListTyped<List<String>, String>(data['values']),
    );
  }
}

// **************************************************************************
// DataSuperclassGenerator
// **************************************************************************

abstract class _Dao extends PrimaryKeyDao<StringArray, int> {
  @override
  _StringArrayDataBeanImpl get bean => StringArrayDataBean;

  @override
  int getPrimaryKey() => (this as StringArray).id;
}
