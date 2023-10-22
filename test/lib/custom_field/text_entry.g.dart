// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_entry.dart';

// **************************************************************************
// CopyWithExtensionGenerator
// **************************************************************************

extension TextEntryCopyExtension on TextEntry {
  TextEntry copyWith({
    int? id,
    String? text,
    String? author,
    Geometry? position,
  }) {
    return TextEntry(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      position: position ?? this.position,
    );
  }
}

// **************************************************************************
// DataBeanGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names

final TextEntryDataBean = _TextEntryDataBeanImpl._();

class _TextEntryDataBeanImpl extends PrimaryKeyDataBean<TextEntry, int> {
  @override
  final layoutName = 'text_entry';

  @override
  PrimaryKey get primaryKey => id;

  _TextEntryDataBeanImpl._();

  final id = PrimaryKey<IntDataType>(
    layoutName: 'text_entry',
    name: 'id',
    length: 0,
    autoIncrement: true,
  );

  final text = DataField<StringDataType>(
    layoutName: 'text_entry',
    name: 'text',
    nullable: false,
    length: 1024,
  );

  final author = DataField<StringDataType>(
    layoutName: 'text_entry',
    name: 'author',
    nullable: false,
    length: 0,
  );

  final position = DataField<GeographyDataType>(
    layoutName: 'text_entry',
    name: 'position',
    nullable: false,
    length: 0,
  );

  @override
  late final fields = [
    id,
    text,
    author,
    position,
  ];

  @override
  Map<DataField, dynamic> unmap(TextEntry dao,
      {bool includePrimaryKey = false}) {
    return {
      if (includePrimaryKey) id: dao.id,
      text: dao.text,
      author: dao.author,
      position: dao.position,
    };
  }

  @override
  TextEntry mapValues(Map<String, dynamic> data) {
    return TextEntry(
      id: data['id'],
      text: data['text'],
      author: data['author'],
      position: data['position'],
    );
  }
}

// **************************************************************************
// DataSuperclassGenerator
// **************************************************************************

abstract class _Dao extends PrimaryKeyDao<TextEntry, int> {
  @override
  _TextEntryDataBeanImpl get bean => TextEntryDataBean;

  @override
  int getPrimaryKey() => (this as TextEntry).id;
}
