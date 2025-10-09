// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsHiveAdapter extends TypeAdapter<SettingsHive> {
  @override
  final int typeId = 5;

  @override
  SettingsHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsHive(
      vatPercentage: fields[0] as double,
      discountPercentage: fields[1] as double,
      discountAmount: fields[2] as double,
      isDiscountPercentage: fields[3] as bool,
      enableRoundOff: fields[4] as bool,
      lastUpdated: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsHive obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.vatPercentage)
      ..writeByte(1)
      ..write(obj.discountPercentage)
      ..writeByte(2)
      ..write(obj.discountAmount)
      ..writeByte(3)
      ..write(obj.isDiscountPercentage)
      ..writeByte(4)
      ..write(obj.enableRoundOff)
      ..writeByte(5)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
