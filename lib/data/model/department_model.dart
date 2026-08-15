import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:hive/hive.dart';

part 'department_model.g.dart';

@HiveType(typeId: 1)
class DepartmentModel extends HiveObject with CustomDropdownListFilter {
  @HiveField(0)
  final String code;

  @HiveField(1)
  final String name;

  DepartmentModel({required this.code, required this.name});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(code: json['CODE'], name: json["DEPT"]);
  }

  Map<String, dynamic> toJson() {
    return {"CODE": code, "DEPT": name};
  }

  @override
  bool filter(String query) {
    return name.toLowerCase().contains(query.toLowerCase());
  }

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DepartmentModel &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}
