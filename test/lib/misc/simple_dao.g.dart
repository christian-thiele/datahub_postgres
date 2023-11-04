// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_dao.dart';

// **************************************************************************
// CopyWithExtensionGenerator
// **************************************************************************

extension SimpleCopyExtension on Simple {
  Simple copyWith({
    int? id,
    String? text,
    DateTime? timestamp,
    double? number,
    bool? yesOrNo,
    Uint8List? someBytes,
  }) {
    return Simple(
      id ?? this.id,
      text ?? this.text,
      timestamp ?? this.timestamp,
      number ?? this.number,
      yesOrNo ?? this.yesOrNo,
      someBytes ?? this.someBytes,
    );
  }
}

// **************************************************************************
// DataBeanGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names

final SimpleDataBean = _SimpleDataBeanImpl._();

class _SimpleDataBeanImpl extends PrimaryKeyDataBean<Simple, int> {
  @override
  final layoutName = 'simple';

  @override
  PrimaryKey get primaryKey => id;

  _SimpleDataBeanImpl._();

  final id = PrimaryKey<StringDataType>(
    layoutName: 'simple',
    name: 'id',
    length: 0,
    autoIncrement: true,
  );

  final text = DataField<StringDataType>(
    layoutName: 'simple',
    name: 'text',
    nullable: false,
    length: 0,
  );

  final timestamp = DataField<DateTimeDataType>(
    layoutName: 'simple',
    name: 'timestamp',
    nullable: false,
    length: 0,
  );

  final number = DataField<DoubleDataType>(
    layoutName: 'simple',
    name: 'number',
    nullable: false,
    length: 0,
  );

  final yesOrNo = DataField<BoolDataType>(
    layoutName: 'simple',
    name: 'yes_or_no',
    nullable: false,
    length: 0,
  );

  final someBytes = DataField<ByteDataType>(
    layoutName: 'simple',
    name: 'some_bytes',
    nullable: false,
    length: 0,
  );

  @override
  late final fields = [
    id,
    text,
    timestamp,
    number,
    yesOrNo,
    someBytes,
  ];

  @override
  Map<DataField, dynamic> unmap(Simple dao, {bool includePrimaryKey = false}) {
    return {
      if (includePrimaryKey) id: dao.id,
      text: dao.text,
      timestamp: dao.timestamp,
      number: dao.number,
      yesOrNo: dao.yesOrNo,
      someBytes: dao.someBytes,
    };
  }

  @override
  Simple mapValues(Map<String, dynamic> data) {
    return Simple(
      data['id'],
      data['text'],
      data['timestamp'],
      data['number'],
      data['yes_or_no'],
      data['some_bytes'],
    );
  }
}

// **************************************************************************
// DataSuperclassGenerator
// **************************************************************************

abstract class _Dao extends PrimaryKeyDao<Simple, int> {
  @override
  _SimpleDataBeanImpl get bean => SimpleDataBean;

  @override
  int getPrimaryKey() => (this as Simple).id;
}
