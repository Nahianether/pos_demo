// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemHiveAdapter extends TypeAdapter<CartItemHive> {
  @override
  final int typeId = 2;

  @override
  CartItemHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItemHive(
      product: fields[0] as ProductHive,
      quantity: fields[1] as int,
      note: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CartItemHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.product)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
