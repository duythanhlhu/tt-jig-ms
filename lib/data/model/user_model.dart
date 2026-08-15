import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String employeeID;

  @HiveField(2)
  String employeeName;

  @HiveField(3)
  String employeeEmail;

  @HiveField(4)
  String area;

  @HiveField(5)
  String? building;

  @HiveField(6)
  String level;

  @HiveField(7)
  String? role;

  @HiveField(8)
  String? appName;

  @HiveField(9)
  DateTime loggedAt;

  @HiveField(10)
  DateTime? loggedOutAt;

  UserModel({
    this.id,
    required this.employeeID,
    required this.employeeName,
    required this.employeeEmail,
    required this.area,
    this.building,
    required this.level,
    required this.role,
    this.appName,
    DateTime? loggedAt,
    this.loggedOutAt,
  }) : loggedAt = loggedAt ?? DateTime.now();

  // ---------- JSON ----------
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      employeeID: json['EMP_ID'],
      employeeName: json['ENAME'] ?? json["EMP_NAME"],
      employeeEmail: json['EMAIL'],
      area: json['AREA'],
      building: json["BUILDING"],
      level: json["EMP_LEVEL"],
      role: json["USER_ROLE"],
      appName: json["APP_NAME"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "EMP_ID": employeeID,
      "ENAME": employeeName,
      "EMAIL": employeeEmail,
      "AREA": area,
      "BUILDING": building,
      "EMP_LEVEL": level,
      "USER_ROLE": role,
      "APP_NAME": appName,
      "LOGGED_IN": loggedAt.toIso8601String(),
      "LOGGED_OUT": loggedAt.toIso8601String(),
    };
  }
}
