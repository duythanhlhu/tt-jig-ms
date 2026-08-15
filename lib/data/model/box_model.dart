import 'package:json_annotation/json_annotation.dart';

part 'box_model.g.dart';

@JsonSerializable()
class BoxModel {
  @JsonKey(name: "DESCRIPTION")
  final String? description;
  @JsonKey(name: "PACK_LABEL")
  final String? packLabel;
  @JsonKey(name: "PACK_NAME")
  final String? packName;
  @JsonKey(name: "PACK_TYPE")
  final String? packType;
  @JsonKey(name: "RACK_LOCATION")
  final String? rackLocation;
  @JsonKey(name: "TOTAL_ITEM")
  final String? totalItem;
  @JsonKey(name: "CREATED_BY")
  final String? createdBy;
  @JsonKey(name: "CREATION_DATE")
  final String? createdAt;
  @JsonKey(name: "UPDATED_BY")
  final String? updatedBy;
  @JsonKey(name: "UPDATE_DATE")
  final String? updatedAt;
  @JsonKey(name: "LIMIT_ITEM")
  final String? limitItem;

  BoxModel({
    this.packLabel,
    this.packName,
    this.packType,
    this.rackLocation,
    this.totalItem,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.limitItem,
    this.description,
  });

  factory BoxModel.fromJson(Map<String, dynamic> json) =>
      _$BoxModelFromJson(json);
  Map<String, dynamic> toJson() => _$BoxModelToJson(this);
}
