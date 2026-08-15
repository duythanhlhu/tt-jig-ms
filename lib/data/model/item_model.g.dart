// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => ItemModel(
      labelID: json['LABEL_ID'] as String?,
      sizeCD: json['SIZE_CD'] as String?,
      partAlias: json['ALIAS_PART'] as String?,
      modelAlias: json['ALIAS_MODEL'] as String?,
      style: json['STYLE'] as String?,
      groupQty: json['TOTAL_QTY_GROUP'] as String?,
      createdBy: json['CREATED_BY'] as String?,
      createdAt: json['CREATION_DATE'] as String?,
      updatedBy: json['UPDATED_BY'] as String?,
      updatedAt: json['UPDATE_DATE'] as String?,
      devItemCode: json['DEV_ITEM_CODE'] as String?,
      nikeCode: json['NK_CODE'] as String?,
      packLabel: json['PACK_LABEL'] as String?,
      packLocation: json['PACK_LOCATION'] as String?,
      rackLocation: json['RACK_LOCATION'] as String?,
      status: json['STATUS'] as String?,
      toolingAlias: json['ALIAS_TOOLING'] as String?,
    );

Map<String, dynamic> _$ItemModelToJson(ItemModel instance) => <String, dynamic>{
      'LABEL_ID': instance.labelID,
      'PACK_LOCATION': instance.packLocation,
      'STATUS': instance.status,
      'DEV_ITEM_CODE': instance.devItemCode,
      'ALIAS_TOOLING': instance.toolingAlias,
      'ALIAS_PART': instance.partAlias,
      'ALIAS_MODEL': instance.modelAlias,
      'SIZE_CD': instance.sizeCD,
      'STYLE': instance.style,
      'NK_CODE': instance.nikeCode,
      'PACK_LABEL': instance.packLabel,
      'RACK_LOCATION': instance.rackLocation,
      'TOTAL_QTY_GROUP': instance.groupQty,
      'CREATED_BY': instance.createdBy,
      'CREATION_DATE': instance.createdAt,
      'UPDATED_BY': instance.updatedBy,
      'UPDATE_DATE': instance.updatedAt,
    };

RequestItemModel _$RequestItemModelFromJson(Map<String, dynamic> json) =>
    RequestItemModel(
      labelID: json['labelId'] as String,
      labelType: $enumDecode(_$ScanModeEnumMap, json['labelType']),
    );

Map<String, dynamic> _$RequestItemModelToJson(RequestItemModel instance) =>
    <String, dynamic>{
      'labelId': instance.labelID,
      'labelType': _$ScanModeEnumMap[instance.labelType]!,
    };

const _$ScanModeEnumMap = {
  ScanMode.sender: 'SENDER',
  ScanMode.receiver: 'RECEIVER',
  ScanMode.item: 'ITEM',
  ScanMode.boxItem: 'ITEM_IN_BOX',
  ScanMode.box: 'BOX',
  ScanMode.boxDestination: 'BOX_DESTINATION',
  ScanMode.rack: 'RACK',
};

ItemHistoryModel _$ItemHistoryModelFromJson(Map<String, dynamic> json) =>
    ItemHistoryModel(
      labelID: json['LABEL_ID'] as String?,
      description: json['DESCRIPTION'] as String?,
      totalItem: json['TOTAL_ITEM'] as String?,
      createdBy: json['CREATED_BY'] as String?,
    )
      ..transID = json['TRANS_ID'] as String?
      ..createdAt = json['CREATED_AT'] as String?;

Map<String, dynamic> _$ItemHistoryModelToJson(ItemHistoryModel instance) =>
    <String, dynamic>{
      'LABEL_ID': instance.labelID,
      'DESCRIPTION': instance.description,
      'TOTAL_ITEM': instance.totalItem,
      'CREATED_BY': instance.createdBy,
      'TRANS_ID': instance.transID,
      'CREATED_AT': instance.createdAt,
    };
