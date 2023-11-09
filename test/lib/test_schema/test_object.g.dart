// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_object.dart';

// **************************************************************************
// CopyWithExtensionGenerator
// **************************************************************************

extension TestObjectCopyExtension on TestObject {
  TestObject copyWith({
    int? id,
    String? string,
    bool? boolean,
    int? intNumber,
    double? doubleNumber,
    List<dynamic>? jsonList,
    Map<String, dynamic>? jsonMap,
    Uint8List? bytes,
    DateTime? timestamp,
    CustomEnum? enumValue,
    List<CustomEnum>? enumValues,
  }) {
    return TestObject(
      id: id ?? this.id,
      string: string ?? this.string,
      boolean: boolean ?? this.boolean,
      intNumber: intNumber ?? this.intNumber,
      doubleNumber: doubleNumber ?? this.doubleNumber,
      jsonList: jsonList ?? this.jsonList,
      jsonMap: jsonMap ?? this.jsonMap,
      bytes: bytes ?? this.bytes,
      timestamp: timestamp ?? this.timestamp,
      enumValue: enumValue ?? this.enumValue,
      enumValues: enumValues ?? this.enumValues,
    );
  }
}

// **************************************************************************
// DataBeanGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names

final TestObjectDataBean = _TestObjectDataBeanImpl._();

class _TestObjectDataBeanImpl extends PrimaryKeyDataBean<TestObject, int> {
  @override
  final layoutName = 'test_object';

  @override
  PrimaryKey get primaryKey => id;

  _TestObjectDataBeanImpl._();

  final id = PrimaryKey<IntDataType>(
    layoutName: 'test_object',
    name: 'id',
    length: 0,
    autoIncrement: true,
  );

  final string = DataField<StringDataType>(
    layoutName: 'test_object',
    name: 'string',
    nullable: false,
    length: 0,
  );

  final boolean = DataField<BoolDataType>(
    layoutName: 'test_object',
    name: 'boolean',
    nullable: false,
    length: 0,
  );

  final intNumber = DataField<IntDataType>(
    layoutName: 'test_object',
    name: 'int_number',
    nullable: false,
    length: 0,
  );

  final doubleNumber = DataField<DoubleDataType>(
    layoutName: 'test_object',
    name: 'double_number',
    nullable: false,
    length: 0,
  );

  final jsonList = DataField<JsonListDataType>(
    layoutName: 'test_object',
    name: 'json_list',
    nullable: false,
    length: 0,
  );

  final jsonMap = DataField<JsonMapDataType>(
    layoutName: 'test_object',
    name: 'json_map',
    nullable: false,
    length: 0,
  );

  final bytes = DataField<ByteDataType>(
    layoutName: 'test_object',
    name: 'bytes',
    nullable: false,
    length: 0,
  );

  final timestamp = DataField<DateTimeDataType>(
    layoutName: 'test_object',
    name: 'timestamp',
    nullable: false,
    length: 0,
  );

  final enumValue = DataField<StringDataType>(
    layoutName: 'test_object',
    name: 'enum_value',
    nullable: false,
    length: 0,
  );

  final enumValues = DataField<StringArrayDataType>(
    layoutName: 'test_object',
    name: 'enum_values',
    nullable: false,
    length: 0,
  );

  @override
  late final fields = [
    id,
    string,
    boolean,
    intNumber,
    doubleNumber,
    jsonList,
    jsonMap,
    bytes,
    timestamp,
    enumValue,
    enumValues,
  ];

  @override
  Map<DataField, dynamic> unmap(TestObject dao,
      {bool includePrimaryKey = false}) {
    return {
      if (includePrimaryKey) id: dao.id,
      string: dao.string,
      boolean: dao.boolean,
      intNumber: dao.intNumber,
      doubleNumber: dao.doubleNumber,
      jsonList: dao.jsonList,
      jsonMap: dao.jsonMap,
      bytes: dao.bytes,
      timestamp: dao.timestamp,
      enumValue: dao.enumValue.name,
      enumValues: dao.enumValues,
    };
  }

  @override
  TestObject mapValues(Map<String, dynamic> data) {
    return TestObject(
      id: data['id'],
      string: data['string'],
      boolean: data['boolean'],
      intNumber: data['int_number'],
      doubleNumber: data['double_number'],
      jsonList: decodeListTyped<List<dynamic>, dynamic>(data['json_list']),
      jsonMap: decodeMapTyped<Map<String, dynamic>, dynamic>(data['json_map']),
      bytes: data['bytes'],
      timestamp: data['timestamp'],
      enumValue:
          CustomEnum.values.firstWhere((v) => v.name == (data['enum_value'])),
      enumValues: decodeList<List<CustomEnum>, CustomEnum>(data['enum_values'],
          (v, n) => CustomEnum.values.firstWhere((e) => e.name == v)),
    );
  }
}

// **************************************************************************
// DataSuperclassGenerator
// **************************************************************************

abstract class _Dao extends PrimaryKeyDao<TestObject, int> {
  @override
  _TestObjectDataBeanImpl get bean => TestObjectDataBean;

  @override
  int getPrimaryKey() => (this as TestObject).id;
}
