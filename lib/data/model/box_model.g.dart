// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoxModel _$BoxModelFromJson(Map<String, dynamic> json) => BoxModel(
      packLabel: json['PACK_LABEL'] as String?,
      packName: json['PACK_NAME'] as String?,
      packType: json['PACK_TYPE'] as String?,
      rackLocation: json['RACK_LOCATION'] as String?,
      totalItem: json['TOTAL_ITEM'] as String?,
      createdBy: json['CREATED_BY'] as String?,
      createdAt: json['CREATION_DATE'] as String?,
      updatedBy: json['UPDATED_BY'] as String?,
      updatedAt: json['UPDATE_DATE'] as String?,
      limitItem: json['LIMIT_ITEM'] as String?,
      description: json['DESCRIPTION'] as String?,
    );

Map<String, dynamic> _$BoxModelToJson(BoxModel instance) => <String, dynamic>{
      'DESCRIPTION': instance.description,
      'PACK_LABEL': instance.packLabel,
      'PACK_NAME': instance.packName,
      'PACK_TYPE': instance.packType,
      'RACK_LOCATION': instance.rackLocation,
      'TOTAL_ITEM': instance.totalItem,
      'CREATED_BY': instance.createdBy,
      'CREATION_DATE': instance.createdAt,
      'UPDATED_BY': instance.updatedBy,
      'UPDATE_DATE': instance.updatedAt,
      'LIMIT_ITEM': instance.limitItem,
    };
