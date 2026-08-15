// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponseModel<T> _$ApiResponseModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiResponseModel<T>(
      success: json['SUCCESS'] as bool,
      message: json['MESSAGE'] as String?,
      count: json['COUNT'] as int?,
      data: _$nullableGenericFromJson(json['DATA'], fromJsonT),
      query: json['QUERY'] as String?,
      pass: json['PASS'] as bool?,
    );

Map<String, dynamic> _$ApiResponseModelToJson<T>(
  ApiResponseModel<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'SUCCESS': instance.success,
      'MESSAGE': instance.message,
      'COUNT': instance.count,
      'DATA': _$nullableGenericToJson(instance.data, toJsonT),
      'QUERY': instance.query,
      'PASS': instance.pass,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
