import 'package:json_annotation/json_annotation.dart';

part 'api_response_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponseModel<T> {
  @JsonKey(name: "SUCCESS")
  final bool success;

  @JsonKey(name: "MESSAGE")
  final String? message;

  @JsonKey(name: "COUNT")
  final int? count;

  @JsonKey(name: "DATA")
  final T? data;

  @JsonKey(name: "QUERY")
  final String? query;

  @JsonKey(name: "PASS")
  final bool? pass;

  ApiResponseModel({
    required this.success,
    required this.message,
    required this.count,
    required this.data,
    this.query,
    this.pass,
  });

  // Factory constructor to create an instance from JSON.
  // It takes a 'fromJsonT' function to handle the generic type T.
  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseModelFromJson(json, fromJsonT);

  // Method to convert an instance to JSON.
  // It takes a 'toJsonT' function to handle the generic type T.
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseModelToJson(this, toJsonT);
}
