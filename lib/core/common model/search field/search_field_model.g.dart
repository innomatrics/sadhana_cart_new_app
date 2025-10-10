// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_field_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchFieldModelAdapter extends TypeAdapter<SearchFieldModel> {
  @override
  final int typeId = 2;

  @override
  SearchFieldModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchFieldModel(
      searchField: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SearchFieldModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.searchField);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchFieldModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
