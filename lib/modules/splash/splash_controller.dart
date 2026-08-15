import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide FormData;
import 'package:sprintf/sprintf.dart';
import 'package:tt_jig_ms/constant/app_constant.dart';
import 'package:tt_jig_ms/core/network/connection_manager.dart';
import 'package:tt_jig_ms/core/network/exception/api_exception.dart';
import 'package:tt_jig_ms/core/network/network_manager.dart';
import 'package:tt_jig_ms/core/routers/router.dart';
import 'package:tt_jig_ms/data/local/department_provider.dart';
import 'package:tt_jig_ms/data/local/reason_provider.dart';
import 'package:tt_jig_ms/data/local/user_provider.dart';
import 'package:tt_jig_ms/data/model/api_response_model.dart';
import 'package:tt_jig_ms/data/model/department_model.dart';
import 'package:tt_jig_ms/data/model/reason_model.dart';
import 'package:tt_jig_ms/helper/app_config.dart';
import 'package:tt_jig_ms/helper/get_controller_ext.dart';
import 'package:tt_jig_ms/helper/helper.dart';

class SplashController extends GetxController {
  final helper = Helper();
  final networkManager = NetworkManager();
  final userProvider = UserProvider();
  final connectionManager = ConnectionManager();
  final departmentProvider = DepartmentProvider();
  final reasonProvider = ReasonProvider();
  final stringStatus = "init".obs;
  final RxnDouble progress = RxnDouble();

  late Worker stateWorker;

  final configService = Get.find<AppConfigService>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  @override
  void dispose() {
    super.dispose();
    stateWorker.dispose();
    helper.state.value = .idle();
  }

  @override
  void onClose() {
    stateWorker.dispose();
    super.onClose();
    helper.state.value = .idle();
  }

  void _init() {
    stringStatus.value = localize.starting;
    _checkVersion();
    _getDepartments();
    _getReasons();
  }

  // MARK: API
  void _checkVersion() async {
    stringStatus.value = localize.checkingVersion;
    try {
      await configService.versionManager.checkVersion();
      var currentUser = userProvider.currentUser;
      if (kDebugMode ||
          !_isUpdateRequired(
            configService.appVersion.value,
            configService.versionManager.versionModel.applicationVersion,
          )) {
        stringStatus.value = localize.uptodate;
        Future.delayed(const Duration(seconds: 2), () {
          if (currentUser != null && currentUser.loggedOutAt == null) {
            _goToMainPage();
          } else {
            _goToLoginPage();
          }
        });
      } else {
        showDefaultDialog(
          title: localize.update,
          message: sprintf(localize.newVersionAvailable, [
            configService.versionManager.versionModel.applicationVersion,
          ]),
          confirm: () async {
            Get.back();
            configService.versionManager.downloadProgress.listen((event) {
              progress.value = event;
              if (event == 100) {
                stringStatus.value = localize.downloaded;
              } else {
                stringStatus.value = sprintf("%s %s%%", [
                  localize.downloading,
                  event.toStringAsFixed(0),
                ]);
              }
            });
            await configService.versionManager.forceUpdate();
          },
          cancel: () {
            SystemNavigator.pop();
          },
        );
      }
    } catch (e) {
      stringStatus.value = localize.failed;
      progress.value = 100;
      var message = "";
      if (e is DioException && e.error is ApiException) {
        // print('An error occurred: $e');
        // throw e.error as ApiException;
        message = (e.error as ApiException).message;
      } else if (e is String) {
        message = e.toString();
      } else {
        message = localize.somethingWrong;
      }
      stringStatus.value = message;
      helper.state.value = ViewState.error(
        MessageException(message: message, type: .error),
      );
    }
  }

  void _getDepartments() async {
    try {
      var response = await networkManager
          .get<ApiResponseModel<List<DepartmentModel>>>(
            '${Env.apiBaseUrl}/${APIRoute.departmentInfo}',
            parser: (json) {
              return ApiResponseModel.fromJson(json, (departmentList) {
                List<DepartmentModel> results = [];
                if (departmentList is List) {
                  var data = departmentList
                      .whereType<Map<String, dynamic>>()
                      .toList();
                  results = data.map((e) {
                    return DepartmentModel.fromJson(e);
                  }).toList();
                }
                return results;
              });
            },
          );
      departmentProvider.setDepartments(departments: response.data ?? []);
    } catch (e) {
      var message = "";
      if (e is DioException && e.error is ApiException) {
        message = (e.error as ApiException).message;
      } else if (e is String) {
        message = e.toString();
      } else {
        message = localize.somethingWrong;
      }
      debugPrint(message);
      // state.value = ViewState.error(
      //   MessageException(message: message, type: .error),
      // );
    }
  }

  void _getReasons() async {
    try {
      var response = await networkManager
          .get<ApiResponseModel<List<ReasonModel>>>(
            '${Env.apiBaseUrl}/${APIRoute.reasonInfo}',
            parser: (json) {
              return ApiResponseModel.fromJson(json, (reasonList) {
                List<ReasonModel> results = [];
                if (reasonList is List) {
                  var data = reasonList
                      .whereType<Map<String, dynamic>>()
                      .toList();
                  results = data.map((e) {
                    return ReasonModel.fromJson(e);
                  }).toList();
                }
                return results;
              });
            },
          );
      reasonProvider.setReasons(reasons: response.data ?? []);
    } catch (e) {
      var message = "";
      if (e is DioException && e.error is ApiException) {
        message = (e.error as ApiException).message;
      } else if (e is String) {
        message = e.toString();
      } else {
        message = localize.somethingWrong;
      }
      debugPrint(message);
      // state.value = ViewState.error(
      //   MessageException(message: message, type: .error),
      // );
    }
  }

  // MARK: Custom
  bool _isUpdateRequired(String actual, String api) {
    List<int> actualParts = actual.split('.').map(int.parse).toList();
    List<int> apiParts = api.split('.').map(int.parse).toList();

    int length = actualParts.length > apiParts.length
        ? actualParts.length
        : apiParts.length;

    for (int i = 0; i < length; i++) {
      int actualVal = i < actualParts.length ? actualParts[i] : 0;
      int apiVal = i < apiParts.length ? apiParts[i] : 0;

      if (apiVal > actualVal) return true;
      if (apiVal < actualVal) return false;
    }
    return false;
  }

  // MARK: Route
  void _goToMainPage() {
    Get.offAndToNamed(RouteName.menuScreen);
    // Get.put(MainMenuController());
  }

  void _goToLoginPage() {
    Get.offAndToNamed(RouteName.loginScreen);
    // Get.put(LoginController());
  }
}
