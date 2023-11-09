// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'double_array.dart';

// **************************************************************************
// CopyWithExtensionGenerator
// **************************************************************************

extension DoubleArrayCopyExtension on DoubleArray {
  DoubleArray copyWith({
    int? id,
    List<double>? values,
  }) {
    return DoubleArray(
      id: id ?? this.id,
      values: values ?? this.values,
    );
  }
}

// **************************************************************************
// DataBeanGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names

final DoubleArrayDataBean = _DoubleArrayDataBeanImpl._();

class _DoubleArrayDataBeanImpl extends PrimaryKeyDataBean<DoubleArray, int> {
  @override
  final layoutName = 'double_array';

  @override
  PrimaryKey get primaryKey => id;

  _DoubleArrayDataBeanImpl._();

  final id = PrimaryKey<IntDataType>(
    layoutName: 'double_array',
    name: 'id',
    length: 0,
    autoIncrement: true,
  );

  final values = DataField<DoubleArrayDataType>(
    layoutName: 'double_array',
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
  Map<DataField, dynamic> unmap(DoubleArray dao,
      {bool includePrimaryKey = false}) {
    return {
      if (includePrimaryKey) id: dao.id,
      values: dao.values,
    };
  }

  @override
  DoubleArray mapValues(Map<String, dynamic> data) {
    return DoubleArray(
      id: data['id'],
      values: decodeListTyped<List<double>, double>(data['values']),
    );
  }
}

// **************************************************************************
// DataSuperclassGenerator
// **************************************************************************

abstract class _Dao extends PrimaryKeyDao<DoubleArray, int> {
  @override
  _DoubleArrayDataBeanImpl get bean => DoubleArrayDataBean;

  @override
  int getPrimaryKey() => (this as DoubleArray).id;
}
