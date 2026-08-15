// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) =>
    EmployeeModel(
      employeeID: json['EMP_ID'] as String,
      employeeName: json['EMP_NAME'] as String,
      area: json['AREA'] as String,
      email: json['EMAIL'] as String?,
      building: json['BUILDING'] as String?,
      level: json['EMP_LEVEL'] as String,
      role: json['USER_ROLE'] as String?,
      appName: json['APP_NAME'] as String?,
    );

Map<String, dynamic> _$EmployeeModelToJson(EmployeeModel instance) =>
    <String, dynamic>{
      'EMP_ID': instance.employeeID,
      'EMP_NAME': instance.employeeName,
      'AREA': instance.area,
      'EMAIL': instance.email,
      'BUILDING': instance.building,
      'EMP_LEVEL': instance.level,
      'USER_ROLE': instance.role,
      'APP_NAME': instance.appName,
    };
