// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersionModel _$VersionModelFromJson(Map<String, dynamic> json) => VersionModel(
      applicationName: json['C_SYSTEM'] as String,
      fileName: json['FILENAME'] as String,
      applicationVersion: json['FILEVER'] as String,
      applicationPath: json['PATH'] as String,
      ref: json['REF'] as String,
      ftpPath: json['FTP_PATH'] as String,
    );

Map<String, dynamic> _$VersionModelToJson(VersionModel instance) =>
    <String, dynamic>{
      'C_SYSTEM': instance.applicationName,
      'FILENAME': instance.fileName,
      'FILEVER': instance.applicationVersion,
      'PATH': instance.applicationPath,
      'REF': instance.ref,
      'FTP_PATH': instance.ftpPath,
    };
