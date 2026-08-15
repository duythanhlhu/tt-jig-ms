import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tt_jig_ms/constant/app_constant.dart';
import 'package:tt_jig_ms/core/network/exception/api_exception.dart';
import 'package:tt_jig_ms/core/network/network_manager.dart';
import 'package:tt_jig_ms/data/model/api_model.dart';
import 'package:tt_jig_ms/data/model/api_response_model.dart';
import 'package:tt_jig_ms/data/model/version_model.dart';
import 'package:tt_jig_ms/l10n/app_localizations.dart';

class VersionManager extends ChangeNotifier {
  static VersionManager? _instance;
  late final String _appName;
  late final String _dbLink;

  VersionManager._internal(String dbLink, String appName) {
    _appName = appName;
    _dbLink = dbLink;
  }
  factory VersionManager.init({
    required String dbLink,
    required String appName,
  }) {
    _instance ??= VersionManager._internal(dbLink, appName);
    return _instance!;
  }
  static VersionManager get instance {
    if (_instance == null) {
      throw Exception("Need initialization");
    }
    return _instance!;
  }

  final networkManager = NetworkManager();
  final _streamController = StreamController<double>();
  late VersionModel _versionModel;
  late final AppLocalizations localize;

  Stream<double> get downloadProgress => _streamController.stream;
  VersionModel get versionModel => _versionModel;

  Future<void> checkVersion() async {
    var model = ApiModel(
      database: ServerDB.mes,
      paramaters: {
        "QUERY": "SELECT * FROM $_dbLink WHERE C_SYSTEM = '$_appName'",
        // "SELECT * FROM TKSI_VERSION@DL_TTERGTOTTMES WHERE C_SYSTEM = 'pm30_mobile'",
      },
    );
    try {
      FormData formData = FormData.fromMap(model.paramaters!);
      var response = await networkManager.post<ApiResponseModel<VersionModel>>(
        '${Env.apiBaseUrl}/raw',
        body: formData,
        parser: (json) {
          return ApiResponseModel.fromJson(json, (versionJson) {
            var version = (versionJson as List).first;
            return VersionModel.fromJson(version);
          });
        },
      );
      _versionModel = response.data!;
      _versionModel;
    } catch (e) {
      String errorMessage;
      if (e is DioException && e.error is ApiException) {
        errorMessage = (e.error as ApiException).message;
      } else {
        errorMessage = localize.somethingWrong;
      }
      throw errorMessage;
    }
  }

  Future<void> forceUpdate() async {
    // 1. Request permissions (if necessary)
    if (Platform.isAndroid || Platform.isIOS) {
      var status = await _storagePermission();
      if (!status.isGranted) {
        debugPrint('Permission denied');
        throw 'Permission denied';
      }
    }

    // 2. Get the local storage path
    // getApplicationDocumentsDirectory() is suitable for app-specific storage
    // For saving to public directories like "Downloads", more complex logic is needed (see path_provider docs)
    final directory = await getApplicationDocumentsDirectory();
    final savePath = '${directory.path}/Downloads/${_versionModel.fileName}}';

    try {
      await networkManager.download(
        _versionModel.generateDownloadUrl(),
        savePath,
        (progress) {
          _streamController.add(progress);
        },
      );
    } catch (e) {
      _streamController.addError(e);
    } finally {
      _installUpdate(savePath);
    }
  }

  Future<PermissionStatus> _storagePermission() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    final storageStatus = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;

    if (storageStatus == PermissionStatus.granted) {
      debugPrint("storage granted");
    }
    if (storageStatus == PermissionStatus.denied) {
      debugPrint("storage denied");
    }
    if (storageStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
    return storageStatus;
  }

  void _installUpdate(String filePath) async {
    await OpenFilex.open(filePath);
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }
}
