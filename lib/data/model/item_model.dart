import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tt_jig_ms/modules/create_transaction/create_transaction_controller.dart';

part 'item_model.g.dart';

@JsonSerializable()
class ItemModel {
  @JsonKey(name: "LABEL_ID")
  final String? labelID;
  @JsonKey(name: "PACK_LOCATION")
  final String? packLocation;
  @JsonKey(name: "STATUS")
  final String? status;
  @JsonKey(name: "DEV_ITEM_CODE")
  final String? devItemCode;
  @JsonKey(name: "ALIAS_TOOLING")
  final String? toolingAlias;
  @JsonKey(name: "ALIAS_PART")
  final String? partAlias;
  @JsonKey(name: "ALIAS_MODEL")
  final String? modelAlias;
  @JsonKey(name: "SIZE_CD")
  final String? sizeCD;
  @JsonKey(name: "STYLE")
  final String? style;
  @JsonKey(name: "NK_CODE")
  final String? nikeCode;
  @JsonKey(name: "PACK_LABEL")
  final String? packLabel;
  @JsonKey(name: "RACK_LOCATION")
  final String? rackLocation;
  @JsonKey(name: "TOTAL_QTY_GROUP")
  final String? groupQty;
  @JsonKey(name: "CREATED_BY")
  final String? createdBy;
  @JsonKey(name: "CREATION_DATE")
  final String? createdAt;
  @JsonKey(name: "UPDATED_BY")
  final String? updatedBy;
  @JsonKey(name: "UPDATE_DATE")
  final String? updatedAt;

  ItemModel({
    this.labelID,
    this.sizeCD,
    this.partAlias,
    this.modelAlias,
    this.style,
    this.groupQty,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.devItemCode,
    this.nikeCode,
    this.packLabel,
    this.packLocation,
    this.rackLocation,
    this.status,
    this.toolingAlias,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$ItemModelToJson(this);

  String get description => [
    toolingAlias ?? "",
    modelAlias ?? "",
    partAlias ?? "",
  ].whereNot((element) => element.isEmpty).join(", ");
}

@JsonSerializable()
class RequestItemModel {
  @JsonKey(name: "labelId")
  String labelID;
  @JsonKey(name: "labelType")
  ScanMode labelType;

  RequestItemModel({required this.labelID, required this.labelType});

  factory RequestItemModel.fromJson(Map<String, dynamic> json) =>
      _$RequestItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$RequestItemModelToJson(this);
}

@JsonSerializable()
class ItemHistoryModel {
  @JsonKey(name: "LABEL_ID")
  String? labelID;
  @JsonKey(name: "DESCRIPTION")
  String? description;
  @JsonKey(name: "TOTAL_ITEM")
  String? totalItem;
  @JsonKey(name: 'CREATED_BY')
  String? createdBy;
  @JsonKey(name: "TRANS_ID")
  String? transID;
  @JsonKey(name: 'CREATED_AT')
  String? createdAt;

  ItemHistoryModel({
    this.labelID,
    this.description,
    this.totalItem,
    this.createdBy,
  });

  factory ItemHistoryModel.fromJson(Map<String, dynamic> json) {
    final String creation = json['CREATED_BY'] as String? ?? '';
    final parts = creation.split(' ');

    json['CREATED_BY'] = parts.isNotEmpty ? parts.first : '';
    json['CREATED_AT'] = parts.length > 1
        ? [parts[1], parts[2]].join(" ").replaceAll(RegExp(r'[()]'), '')
        : '';

    return _$ItemHistoryModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ItemHistoryModelToJson(this);

  // static String _extractCreatedBy(dynamic creation) {
  //   return (creation as String).split(' ').first;
  // }

  // static String _extractCreatedAt(dynamic creation) {
  //   List<String> parts = (creation as String).split(' ');
  //   return parts.length > 1 ? parts.last.replaceAll(RegExp(r'[()]'), '') : '';
  // }
}
