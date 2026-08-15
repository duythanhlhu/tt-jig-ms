// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestLoginModel _$RequestLoginModelFromJson(Map<String, dynamic> json) =>
    RequestLoginModel(
      employeeID: json['EMPID'] as String,
      password: json['PWD'] as String,
      rememberMe: json['rememberMe'] as bool? ?? false,
    );

Map<String, dynamic> _$RequestLoginModelToJson(RequestLoginModel instance) =>
    <String, dynamic>{
      'EMPID': instance.employeeID,
      'PWD': instance.password,
      'rememberMe': instance.rememberMe,
    };
