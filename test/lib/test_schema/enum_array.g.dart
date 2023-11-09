// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enum_array.dart';

// **************************************************************************
// CopyWithExtensionGenerator
// **************************************************************************

extension EnumArrayCopyExtension on EnumArray {
  EnumArray copyWith({
    int? id,
    List<CustomEnum>? values,
  }) {
    return EnumArray(
      id: id ?? this.id,
      values: values ?? this.values,
    );
  }
}

// **************************************************************************
// DataBeanGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names

final EnumArrayDataBean = _EnumArrayDataBeanImpl._();

class _EnumArrayDataBeanImpl extends PrimaryKeyDataBean<EnumArray, int> {
  @override
  final layoutName = 'enum_array';

  @override
  PrimaryKey get primaryKey => id;

  _EnumArrayDataBeanImpl._();

  final id = PrimaryKey<IntDataType>(
    layoutName: 'enum_array',
    name: 'id',
    length: 0,
    autoIncrement: true,
  );

  final values = DataField<StringArrayDataType>(
    layoutName: 'enum_array',
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
  Map<DataField, dynamic> unmap(EnumArray dao,
      {bool includePrimaryKey = false}) {
    return {
      if (includePrimaryKey) id: dao.id,
      values: dao.values,
    };
  }

  @override
  EnumArray mapValues(Map<String, dynamic> data) {
    return EnumArray(
      id: data['id'],
      values: decodeList<List<CustomEnum>, CustomEnum>(data['values'],
          (v, n) => CustomEnum.values.firstWhere((e) => e.name == v)),
    );
  }
}

// **************************************************************************
// DataSuperclassGenerator
// **************************************************************************

abstract class _Dao extends PrimaryKeyDao<EnumArray, int> {
  @override
  _EnumArrayDataBeanImpl get bean => EnumArrayDataBean;

  @override
  int getPrimaryKey() => (this as EnumArray).id;
}
