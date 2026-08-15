import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:tt_jig_ms/constant/app_constant.dart';
import 'package:tt_jig_ms/core/network/connection_manager.dart';
import 'package:tt_jig_ms/core/network/exception/api_exception.dart';
import 'package:tt_jig_ms/core/network/network_manager.dart';
import 'package:tt_jig_ms/core/routers/router.dart';
import 'package:tt_jig_ms/data/local/user_provider.dart';
import 'package:tt_jig_ms/data/model/api_response_model.dart';
import 'package:tt_jig_ms/data/model/login_model.dart';
import 'package:tt_jig_ms/data/model/user_model.dart';
import 'package:tt_jig_ms/helper/app_config.dart';
import 'package:tt_jig_ms/helper/get_controller_ext.dart';
import 'package:tt_jig_ms/helper/helper.dart';

class LoginController extends GetxController {
  final networkManager = NetworkManager();
  final connectionManager = ConnectionManager();
  final userProvider = UserProvider();
  final helper = Helper();

  final configService = Get.find<AppConfigService>();

  final RxnString cacheUserID = RxnString();
  final RxBool rememberMe = false.obs;

  late String userID = "";
  late String password = "";
  late Worker _worker, stateWorker;

  // final potraitFormKey = GlobalKey<FormState>();
  // final landscapeFormKey = GlobalKey<FormState>();

  Map<int, GlobalKey<FormState>> formKeys = {};

  @override
  void onInit() {
    super.onInit();
    _refreshKeys();

    _worker = ever(connectionManager.internetStatus, (status) {
      if (status == InternetStatus.disconnected) {
        helper.state.value = .error(
          MessageException(message: localize.connectionGone, type: .error),
        );
        // throw localize.connectionGone;
      } else {
        helper.state.value = .idle();
      }
    });

    // // Set the preferred orientations to landscape modes only
    // if (Helper.isTabletWith(Get.context!)) {
    //   Helper.setLandscapeOrientation();
    // } else {
    //   Helper.setPotraitOrientation();
    // }
  }

  @override
  void dispose() {
    super.dispose();
    _worker.dispose();
    stateWorker.dispose();
    helper.state.value = .idle();
  }

  @override
  void onClose() async {
    _worker.dispose();
    formKeys.clear();
    // await Helper.setPotraitOrientation();
    super.onClose();
    helper.state.value = .idle();
  }

  void _refreshKeys() {
    formKeys = {0: GlobalKey<FormState>(), 1: GlobalKey<FormState>()};
  }

  // MARK: API
  // void _handleConnection() {
  //   connectionManager.subscription.listen((event) {
  //     if (event == InternetStatus.disconnected) {
  //       throw localize.connectionGone;
  //     }
  //   });
  // }

  Future<bool> _getLogin() async {
    try {
      helper.state.value = ViewState.loading();
      var user = RequestLoginModel(employeeID: userID, password: password);
      FormData formData = FormData.fromMap(user.toJson());
      var response = await networkManager.post<ApiResponseModel<UserModel>>(
        '${Env.apiBaseUrl}/${APIRoute.login}',
        body: formData,
        parser: (json) {
          return ApiResponseModel.fromJson(json, (employeeJson) {
            return UserModel.fromJson(employeeJson as Map<String, dynamic>);
          });
        },
      );
      if (!(response.pass ?? true)) {
        throw (localize.loginFail);
      } else {
        if (rememberMe.value) {
          configService.cacheUser(userID);
        }
        userProvider.setLogin(user: response.data!);
        helper.state.value = ViewState.success(response.data);
        return true;
      }

      // return response.data;
    } catch (e) {
      String message;
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
      return false;
    }
  }

  // MARK: Action
  void doLogin() async {
    debugPrint("onTap login: =========================> $userID and $password");

    if (!await _getLogin()) return;
    goToMainPage();
    formKeys[0]?.currentState?.reset();
    formKeys[1]?.currentState?.reset();
    // potraitFormKey.currentState?.reset();
    // landscapeFormKey.currentState?.reset();
  }

  // MARK: Setter
  void setRememberMe(bool value) {
    rememberMe.value = value;
  }

  // MARK: Route
  void goToMainPage() {
    Get.offAndToNamed(RouteName.menuScreen);
    // Get.put(MainMenuController());
  }
}
