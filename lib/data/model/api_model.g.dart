// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiModel _$ApiModelFromJson(Map<String, dynamic> json) => ApiModel(
      database: $enumDecode(_$ServerDBEnumMap, json['DB']),
      paramaters: json['QUERY'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ApiModelToJson(ApiModel instance) => <String, dynamic>{
      'DB': _$ServerDBEnumMap[instance.database]!,
      'QUERY': instance.paramaters,
    };

const _$ServerDBEnumMap = {
  ServerDB.mes: 'mes',
  ServerDB.amesdev: 'amesdev',
  ServerDB.mestest: 'mestest',
  ServerDB.ames: 'ames',
  ServerDB.erg: 'erg',
};
