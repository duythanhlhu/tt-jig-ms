import 'package:json_annotation/json_annotation.dart';

part 'version_model.g.dart';

@JsonSerializable()
class VersionModel {
  @JsonKey(name: "C_SYSTEM")
  final String applicationName;

  @JsonKey(name: "FILENAME")
  final String fileName;

  @JsonKey(name: "FILEVER")
  final String applicationVersion;

  @JsonKey(name: "PATH")
  final String applicationPath;

  @JsonKey(name: "REF")
  final String ref;

  @JsonKey(name: "FTP_PATH")
  final String ftpPath;

  VersionModel({
    required this.applicationName,
    required this.fileName,
    required this.applicationVersion,
    required this.applicationPath,
    required this.ref,
    required this.ftpPath,
  });

  factory VersionModel.fromJson(Map<String, dynamic> json) =>
      _$VersionModelFromJson(json);
  Map<String, dynamic> toJson() => _$VersionModelToJson(this);

  String generateDownloadUrl() {
    return [applicationPath, ftpPath, fileName].join();
  }
}
