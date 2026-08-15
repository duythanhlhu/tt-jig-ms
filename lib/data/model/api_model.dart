import 'package:json_annotation/json_annotation.dart';

part 'api_model.g.dart';

enum ServerDB {
  @JsonValue('mes')
  mes,
  @JsonValue('amesdev')
  amesdev,
  @JsonValue('mestest')
  mestest,
  @JsonValue('ames')
  ames,
  @JsonValue('erg')
  erg,
}

@JsonSerializable()
class ApiModel {
  @JsonKey(name: "DB")
  final ServerDB database;

  @JsonKey(name: "QUERY")
  final Map<String, dynamic>? paramaters;

  ApiModel({
    required this.database,
    required this.paramaters,
  });

  factory ApiModel.fromJson(Map<String, dynamic> json) =>
      _$ApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$ApiModelToJson(this);
}
