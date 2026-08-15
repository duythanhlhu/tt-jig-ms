import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tt_jig_ms/constant/app_constant.dart';
import 'package:tt_jig_ms/core/network/connection_manager.dart';
import 'package:tt_jig_ms/core/network/exception/api_exception.dart';
import 'package:tt_jig_ms/core/network/network_manager.dart';
import 'package:tt_jig_ms/core/routers/router.dart';
import 'package:tt_jig_ms/data/local/user_provider.dart';
import 'package:tt_jig_ms/data/model/api_response_model.dart';
import 'package:tt_jig_ms/data/model/menu_model.dart';
import 'package:tt_jig_ms/data/model/report_model.dart';
import 'package:tt_jig_ms/helper/app_config.dart';
import 'package:tt_jig_ms/helper/bluetooth_scanner_manager.dart';
import 'package:tt_jig_ms/helper/get_controller_ext.dart';
import 'package:tt_jig_ms/helper/helper.dart';
import 'package:tt_jig_ms/helper/language_provider.dart';

class MainMenuController extends GetxController {
  final connectionManager = ConnectionManager();
  final networkManager = NetworkManager();
  final userProvider = UserProvider();
  final bluetoothManager = BluetoothScannerManager();
  final helper = Helper();

  LanguageProvider languageProvider = Get.find<LanguageProvider>();
  final configService = Get.find<AppConfigService>();
  final RxMap<String, List<MenuModel>> groupedMenu = RxMap();
  final RxList<ReportModel> reports = RxList();

  late Worker stateWorker;

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      groupedMenu.value = MenuModel.groupedMenuList;
      update();
      await getReport();
      _reconnectBluetoothDevice();
    });
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    super.update(ids, condition);
    groupedMenu.value = MenuModel.groupedMenuList;
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
    Helper.setDefaultOrientation();
    helper.state.value = .idle();
  }

  @override
  void onReady() async {
    super.onReady();
    await Helper.setPotraitOrientation();
    // Helper.setDefaultOrientation();
  }

  // MARK: API
  Future<void> getReport() async {
    try {
      var response = await networkManager
          .post<ApiResponseModel<List<ReportModel>>>(
            '${Env.apiBaseUrl}/${APIRoute.userReport}',
            parser: (json) {
              return ApiResponseModel.fromJson(json, (reportList) {
                List<ReportModel> results = [];
                if (reportList is List) {
                  var data = reportList
                      .whereType<Map<String, dynamic>>()
                      .toList();
                  results = data.map((e) {
                    return ReportModel.fromJson(e);
                  }).toList();
                }
                return results;
              });
            },
          );
      reports.value = response.data ?? [];
    } catch (e) {
      var message = "";
      if (e is DioException && e.error is ApiException) {
        message = (e.error as ApiException).message;
      } else if (e is String) {
        message = e.toString();
      } else {
        message = localize.somethingWrong;
      }
      helper.state.value = ViewState.error(
        MessageException(message: message, type: .error),
      );
    }
  }

  // MARK: Action
  void handleAction(MenuModel menu) {
    if (!menu.active) {
      return;
    }
    switch (menu.id) {
      case 0 || 1 || 2 || 9 || 11:
        gotoTransactionList(menu);
        break;
      case 3 || 4 || 5 || 6 || 7 || 8:
        goToWebView(menu);
        break;
      case 10:
        goToNewTransaction(menu);
        break;
      default:
        return;
    }
  }

  void doLogout() {
    userProvider.setLogOut();
    goToLogin();
  }

  void confirmLogout(VoidCallback confirm) {
    showDefaultDialog(
      title: localize.logout,
      message: localize.confirmLogout,
      confirm: confirm,
    );
  }

  void _reconnectBluetoothDevice() async {
    var address = configService.bluetoothAddress.value;
    if (address.isNotEmpty) {
      try {
        Map<String, dynamic> device = json.decode(address);
        bluetoothManager.selectDevice(device);
        bluetoothManager.connect();
      } catch (e) {
        configService.removeBluetoothDeviceCache();
      }
    }
    return;
  }

  // MARK: Route
  void goToWebView(MenuModel menu) {
    Get.toNamed(RouteName.webviewScreen, arguments: menu);
  }

  void gotoTransactionList(MenuModel menu) {
    Get.toNamed(RouteName.transactionListScreen, arguments: menu);
  }

  void goToNewTransaction(MenuModel menu) {
    Get.toNamed(RouteName.createTransactionScreen, arguments: menu);
  }

  void goToLogin() {
    Get.offAndToNamed(RouteName.loginScreen);
  }
}
