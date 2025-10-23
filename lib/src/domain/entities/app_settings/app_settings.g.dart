// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 30;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      id: fields[0] as String?,
      themeMode: fields[1] as String,
      primaryColor: fields[2] as int,
      customTheme: fields[3] as String,
      language: fields[4] as String,
      isRTL: fields[5] as bool,
      dateFormat: fields[6] as String,
      timeFormat: fields[7] as String,
      createdAt: fields[8] as DateTime?,
      updatedAt: fields[9] as DateTime?,
      requirePin: fields[11] as bool,
      pinCode: fields[12] as String,
      isDirty: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.themeMode)
      ..writeByte(2)
      ..write(obj.primaryColor)
      ..writeByte(3)
      ..write(obj.customTheme)
      ..writeByte(4)
      ..write(obj.language)
      ..writeByte(5)
      ..write(obj.isRTL)
      ..writeByte(6)
      ..write(obj.dateFormat)
      ..writeByte(7)
      ..write(obj.timeFormat)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.isDirty)
      ..writeByte(11)
      ..write(obj.requirePin)
      ..writeByte(12)
      ..write(obj.pinCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
