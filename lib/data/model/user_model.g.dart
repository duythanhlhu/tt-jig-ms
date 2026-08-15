// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as int?,
      employeeID: fields[1] as String,
      employeeName: fields[2] as String,
      employeeEmail: fields[3] as String,
      area: fields[4] as String,
      building: fields[5] as String?,
      level: fields[6] as String,
      role: fields[7] as String?,
      appName: fields[8] as String?,
      loggedAt: fields[9] as DateTime?,
      loggedOutAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.employeeID)
      ..writeByte(2)
      ..write(obj.employeeName)
      ..writeByte(3)
      ..write(obj.employeeEmail)
      ..writeByte(4)
      ..write(obj.area)
      ..writeByte(5)
      ..write(obj.building)
      ..writeByte(6)
      ..write(obj.level)
      ..writeByte(7)
      ..write(obj.role)
      ..writeByte(8)
      ..write(obj.appName)
      ..writeByte(9)
      ..write(obj.loggedAt)
      ..writeByte(10)
      ..write(obj.loggedOutAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
