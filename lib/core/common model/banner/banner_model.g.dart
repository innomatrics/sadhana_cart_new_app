// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BannerModelAdapter extends TypeAdapter<BannerModel> {
  @override
  final int typeId = 1;

  @override
  BannerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BannerModel(
      bannerId: fields[0] as String,
      bannerName: fields[1] as String,
      image: fields[2] as String,
      productId: fields[3] as String,
      status: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BannerModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.bannerId)
      ..writeByte(1)
      ..write(obj.bannerName)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.productId)
      ..writeByte(4)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BannerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
