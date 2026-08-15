import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
class RequestLoginModel {
  @JsonKey(name: "EMPID")
  final String employeeID;

  @JsonKey(name: "PWD")
  final String password;

  bool rememberMe;

  RequestLoginModel({
    required this.employeeID,
    required this.password,
    this.rememberMe = false,
  });

  factory RequestLoginModel.fromJson(Map<String, dynamic> json) =>
      _$RequestLoginModelFromJson(json);
  Map<String, dynamic> toJson() => _$RequestLoginModelToJson(this);
}
