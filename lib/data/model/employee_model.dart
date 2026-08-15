import 'package:json_annotation/json_annotation.dart';

part 'employee_model.g.dart';

@JsonSerializable()
class EmployeeModel {
  @JsonKey(name: "EMP_ID")
  String employeeID;

  @JsonKey(name: "EMP_NAME")
  String employeeName;

  @JsonKey(name: "AREA")
  String area;

  @JsonKey(name: "EMAIL")
  String? email;

  @JsonKey(name: "BUILDING")
  String? building;

  @JsonKey(name: "EMP_LEVEL")
  String level;

  @JsonKey(name: "USER_ROLE")
  String? role;

  @JsonKey(name: "APP_NAME")
  String? appName;

  EmployeeModel({
    required this.employeeID,
    required this.employeeName,
    required this.area,
    this.email,
    this.building,
    required this.level,
    this.role,
    this.appName,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);
}
