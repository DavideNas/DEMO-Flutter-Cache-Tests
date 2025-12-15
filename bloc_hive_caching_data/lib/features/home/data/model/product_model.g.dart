// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductsModelAdapter extends TypeAdapter<ProductsModel> {
  @override
  final int typeId = 0;

  @override
  ProductsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductsModel(
      success: fields[0] as bool,
      totalProducts: fields[1] as int,
      message: fields[2] as String,
      offset: fields[3] as int,
      limit: fields[4] as int,
      products: (fields[5] as List).cast<Products>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductsModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.success)
      ..writeByte(1)
      ..write(obj.totalProducts)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.offset)
      ..writeByte(4)
      ..write(obj.limit)
      ..writeByte(5)
      ..write(obj.products);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
