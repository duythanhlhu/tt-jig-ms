import 'dart:async';

import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:tt_jig_ms/constant/app_constant.dart';
import 'package:tt_jig_ms/core/routers/router.dart';
import 'package:tt_jig_ms/modules/menu/menu_controller.dart';
import 'package:tt_jig_ms/modules/splash/splash_controller.dart';
import 'package:tt_jig_ms/modules/transaction_list/transaction_list_controller.dart';

class ConnectionManager {
  StreamSubscription<InternetStatus>? _subscription;
  final internetStatus = InternetStatus.connected.obs;

  static final ConnectionManager _instance = ConnectionManager._internal();

  factory ConnectionManager() => _instance;

  ConnectionManager._internal() {
    _handleConnection();
  }

  void _handleConnection() {
    final connection = InternetConnection.createInstance(
      // checkInterval: Duration(seconds: 5),
      customCheckOptions: [
        InternetCheckOption(
          uri: Uri.parse(Env.apiBaseUrl),
          timeout: Duration(seconds: 3),
        ),

        // InternetCheckOption(
        //   uri: Uri.parse('https://1.1.1.1'),
        //   timeout: Duration(seconds: 3),
        // ),
      ],
    );

    _subscription = connection.onStatusChange.listen((event) {
      internetStatus.value = event;
      if (event == .connected) {
        GetxController? controller;
        switch (Get.currentRoute) {
          case RouteName.splashScreen:
            // Get.delete<SplashController>(force: true);
            // Get.offNamed(Get.currentRoute, preventDuplicates: false);
            // Get.put(SplashController());
            controller = Get.find<SplashController>();
            break;
          // case RouteName.loginScreen:
          //   Get.delete<LoginController>(force: true);
          //   Get.offNamed(Get.currentRoute, preventDuplicates: false);
          //   Get.put(LoginController());
          //   break;
          case RouteName.menuScreen:
            // Get.delete<MenuController>(force: true);
            // Get.offNamed(Get.currentRoute, preventDuplicates: false);
            // Get.put(MenuController());
            controller = Get.find<MainMenuController>();
            break;
          case RouteName.transactionListScreen:
            // Get.delete<TransactionListController>(force: true);
            // Get.offNamed(Get.currentRoute, preventDuplicates: false);
            // Get.put(TransactionListController());
            controller = Get.find<TransactionListController>();
            break;
          default:
            break;
        }
        controller?.onInit();
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}
