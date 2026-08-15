// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rack_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RackModel _$RackModelFromJson(Map<String, dynamic> json) => RackModel(
      rackLabel: json['RACK_LABEL'] as String?,
      rackName: json['RACK_NAME'] as String?,
      rackGroup: json['RACK_GROUP'] as String?,
      area: json['AREA'] as String?,
      cell: json['CELL'] as String?,
      cellNo: json['CELL_NO'] as String?,
      cellLevel: json['CELL_LEVEL'] as String?,
      createdBy: json['CREATED_BY'] as String?,
      createdAt: json['CREATION_DATE'] as String?,
      updatedBy: json['UPDATED_BY'] as String?,
      updatedAt: json['UPDATE_DATE'] as String?,
      totalBox: json['TOTAL_BOX'] as String?,
      limitItem: json['LIMIT_ITEM'] as String?,
    );

Map<String, dynamic> _$RackModelToJson(RackModel instance) => <String, dynamic>{
      'RACK_LABEL': instance.rackLabel,
      'RACK_NAME': instance.rackName,
      'RACK_GROUP': instance.rackGroup,
      'AREA': instance.area,
      'CELL': instance.cell,
      'CELL_NO': instance.cellNo,
      'CELL_LEVEL': instance.cellLevel,
      'CREATED_BY': instance.createdBy,
      'CREATION_DATE': instance.createdAt,
      'UPDATED_BY': instance.updatedBy,
      'UPDATE_DATE': instance.updatedAt,
      'TOTAL_BOX': instance.totalBox,
      'LIMIT_ITEM': instance.limitItem,
    };
