import 'package:json_annotation/json_annotation.dart';

part 'report_model.g.dart';

@JsonSerializable()
class ReportModel {
  @JsonKey(name: "TODAY_REPORT")
  final String? reportType;
  @JsonKey(name: "QTY")
  final String? qty;

  ReportModel({this.reportType, this.qty});

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReportModelToJson(this);
}
