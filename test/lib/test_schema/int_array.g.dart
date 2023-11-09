// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'int_array.dart';

// **************************************************************************
// CopyWithExtensionGenerator
// **************************************************************************

extension IntArrayCopyExtension on IntArray {
  IntArray copyWith({
    int? id,
    List<int>? values,
  }) {
    return IntArray(
      id: id ?? this.id,
      values: values ?? this.values,
    );
  }
}

// **************************************************************************
// DataBeanGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names

final IntArrayDataBean = _IntArrayDataBeanImpl._();

class _IntArrayDataBeanImpl extends PrimaryKeyDataBean<IntArray, int> {
  @override
  final layoutName = 'int_array';

  @override
  PrimaryKey get primaryKey => id;

  _IntArrayDataBeanImpl._();

  final id = PrimaryKey<IntDataType>(
    layoutName: 'int_array',
    name: 'id',
    length: 0,
    autoIncrement: true,
  );

  final values = DataField<IntArrayDataType>(
    layoutName: 'int_array',
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
  Map<DataField, dynamic> unmap(IntArray dao,
      {bool includePrimaryKey = false}) {
    return {
      if (includePrimaryKey) id: dao.id,
      values: dao.values,
    };
  }

  @override
  IntArray mapValues(Map<String, dynamic> data) {
    return IntArray(
      id: data['id'],
      values: decodeListTyped<List<int>, int>(data['values']),
    );
  }
}

// **************************************************************************
// DataSuperclassGenerator
// **************************************************************************

abstract class _Dao extends PrimaryKeyDao<IntArray, int> {
  @override
  _IntArrayDataBeanImpl get bean => IntArrayDataBean;

  @override
  int getPrimaryKey() => (this as IntArray).id;
}
