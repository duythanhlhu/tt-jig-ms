import 'package:json_annotation/json_annotation.dart';

part 'rack_model.g.dart';

@JsonSerializable()
class RackModel {
  @JsonKey(name: "RACK_LABEL")
  final String? rackLabel;
  @JsonKey(name: "RACK_NAME")
  final String? rackName;
  @JsonKey(name: "RACK_GROUP")
  final String? rackGroup;
  @JsonKey(name: "AREA")
  final String? area;
  @JsonKey(name: "CELL")
  final String? cell;
  @JsonKey(name: "CELL_NO")
  final String? cellNo;
  @JsonKey(name: "CELL_LEVEL")
  final String? cellLevel;
  @JsonKey(name: "CREATED_BY")
  final String? createdBy;
  @JsonKey(name: "CREATION_DATE")
  final String? createdAt;
  @JsonKey(name: "UPDATED_BY")
  final String? updatedBy;
  @JsonKey(name: "UPDATE_DATE")
  final String? updatedAt;
  @JsonKey(name: "TOTAL_BOX")
  final String? totalBox;
  @JsonKey(name: "LIMIT_ITEM")
  final String? limitItem;

  RackModel({
    this.rackLabel,
    this.rackName,
    this.rackGroup,
    this.area,
    this.cell,
    this.cellNo,
    this.cellLevel,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.totalBox,
    this.limitItem,
  });

  factory RackModel.fromJson(Map<String, dynamic> json) =>
      _$RackModelFromJson(json);
  Map<String, dynamic> toJson() => _$RackModelToJson(this);
}
