// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 1;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      themeMode: fields[0] as int,
      defaultPriority: fields[1] as Priority,
      notificationsEnabled: fields[2] as bool,
      reminderOffsetMinutes: fields[3] as int,
      dailySummaryTime: fields[4] as String?,
      soundEnabled: fields[5] as bool,
      vibrationEnabled: fields[6] as bool,
      autoBackupEnabled: fields[7] as bool,
      onboardingCompleted: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.themeMode)
      ..writeByte(1)
      ..write(obj.defaultPriority)
      ..writeByte(2)
      ..write(obj.notificationsEnabled)
      ..writeByte(3)
      ..write(obj.reminderOffsetMinutes)
      ..writeByte(4)
      ..write(obj.dailySummaryTime)
      ..writeByte(5)
      ..write(obj.soundEnabled)
      ..writeByte(6)
      ..write(obj.vibrationEnabled)
      ..writeByte(7)
      ..write(obj.autoBackupEnabled)
      ..writeByte(8)
      ..write(obj.onboardingCompleted);
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
