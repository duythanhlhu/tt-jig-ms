import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:hive/hive.dart';

part 'reason_model.g.dart';

@HiveType(typeId: 2)
class ReasonModel with CustomDropdownListFilter {
  @HiveField(0)
  final String code;

  @HiveField(1)
  final String varName;

  ReasonModel({required this.code, required this.varName});

  factory ReasonModel.fromJson(Map<String, dynamic> json) {
    return ReasonModel(code: json['CODE'], varName: json["VAR_NAME"]);
  }

  Map<String, dynamic> toJson() {
    return {"CODE": code, "VAR_NAME": varName};
  }

  @override
  bool filter(String query) {
    return varName.toLowerCase().contains(query.toLowerCase());
  }

  @override
  String toString() {
    return varName;
  }
}
