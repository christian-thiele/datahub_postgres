// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bool_array.dart';

// **************************************************************************
// CopyWithExtensionGenerator
// **************************************************************************

extension BoolArrayCopyExtension on BoolArray {
  BoolArray copyWith({
    int? id,
    List<bool>? values,
  }) {
    return BoolArray(
      id: id ?? this.id,
      values: values ?? this.values,
    );
  }
}

// **************************************************************************
// DataBeanGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names

final BoolArrayDataBean = _BoolArrayDataBeanImpl._();

class _BoolArrayDataBeanImpl extends PrimaryKeyDataBean<BoolArray, int> {
  @override
  final layoutName = 'bool_array';

  @override
  PrimaryKey get primaryKey => id;

  _BoolArrayDataBeanImpl._();

  final id = PrimaryKey<IntDataType>(
    layoutName: 'bool_array',
    name: 'id',
    length: 0,
    autoIncrement: true,
  );

  final values = DataField<BoolArrayDataType>(
    layoutName: 'bool_array',
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
  Map<DataField, dynamic> unmap(BoolArray dao,
      {bool includePrimaryKey = false}) {
    return {
      if (includePrimaryKey) id: dao.id,
      values: dao.values,
    };
  }

  @override
  BoolArray mapValues(Map<String, dynamic> data) {
    return BoolArray(
      id: data['id'],
      values: decodeListTyped<List<bool>, bool>(data['values']),
    );
  }
}

// **************************************************************************
// DataSuperclassGenerator
// **************************************************************************

abstract class _Dao extends PrimaryKeyDao<BoolArray, int> {
  @override
  _BoolArrayDataBeanImpl get bean => BoolArrayDataBean;

  @override
  int getPrimaryKey() => (this as BoolArray).id;
}
