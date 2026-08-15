import 'package:get/get.dart';
import 'package:tt_jig_ms/modules/bluetooth/bluetooth_device_controller.dart';
import 'package:tt_jig_ms/modules/bluetooth/bluetooth_device_page.dart';
import 'package:tt_jig_ms/modules/create_transaction/create_transaction_controller.dart';
import 'package:tt_jig_ms/modules/create_transaction/create_transaction_page.dart';
import 'package:tt_jig_ms/modules/filter/filter_controller.dart';
import 'package:tt_jig_ms/modules/login/login_controller.dart';
import 'package:tt_jig_ms/modules/login/login_page.dart';
import 'package:tt_jig_ms/modules/menu/menu_controller.dart';
import 'package:tt_jig_ms/modules/menu/menu_page.dart';
import 'package:tt_jig_ms/modules/splash/splash_controller.dart';
import 'package:tt_jig_ms/modules/splash/splash_page.dart';
import 'package:tt_jig_ms/modules/transaction_list/transaction_list_controller.dart';
import 'package:tt_jig_ms/modules/transaction_list/transaction_list_page.dart';
import 'package:tt_jig_ms/modules/webview/webview_controller.dart';
import 'package:tt_jig_ms/modules/webview/webview_page.dart';

class RouteName {
  static const String splashScreen = "/splash";
  static const String loginScreen = "/login";
  static const String menuScreen = "/mainMenu";
  static const String webviewScreen = "/webview";
  static const String transactionListScreen = "/transactionList";
  static const String createTransactionScreen = "/createTransaction";
  static const String bluetoothConfigScreen = "/bluetooth";
}

class AppRoutes {
  static List<GetPage<dynamic>> appRoutes() => [
    GetPage(
      name: RouteName.splashScreen,
      page: () => const SplashPage(),
      binding: BindingsBuilder(() {
        // Get.put(SplashController());
        Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
      }),
      transition: .noTransition,
      // transitionDuration: Duration(milliseconds: 250),
      // transition: Transition.leftToRightWithFade
    ),
    GetPage(
      name: RouteName.loginScreen,
      page: () => LoginPage(),
      binding: BindingsBuilder(() {
        // Get.put(LoginController());
        Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
      }),
      transition: .noTransition,
    ),
    GetPage(
      name: RouteName.menuScreen,
      page: () => MenuPage(),
      binding: BindingsBuilder(() {
        // Get.put(MainMenuController());
        Get.lazyPut<MainMenuController>(
          () => MainMenuController(),
          fenix: true,
        );
      }),
      transition: .noTransition,
    ),
    GetPage(
      name: RouteName.webviewScreen,
      page: () => WebviewPage(),
      binding: BindingsBuilder(() {
        // Get.put(WebviewController());
        Get.lazyPut<WebviewController>(() => WebviewController(), fenix: true);
      }),
      transition: .noTransition,
    ),
    GetPage(
      name: RouteName.transactionListScreen,
      page: () => TransactionListPage(),
      binding: BindingsBuilder(() {
        // Get.put(FilterController());
        // Get.put(TransactionListController());
        Get.lazyPut<FilterController>(() => FilterController(), fenix: true);
        Get.lazyPut<TransactionListController>(
          () => TransactionListController(),
          fenix: true,
        );
      }),
      transition: .noTransition,
    ),
    GetPage(
      name: RouteName.createTransactionScreen,
      page: () => CreateTransactionPage(),
      binding: BindingsBuilder(() {
        // Get.put(CreateTransactionController());
        Get.lazyPut<CreateTransactionController>(
          () => CreateTransactionController(),
          fenix: true,
        );
        Get.lazyPut<FilterController>(() => FilterController(), fenix: true);
        Get.lazyPut<TransactionListController>(
          () => TransactionListController(),
          fenix: true,
        );
      }),
      transition: .noTransition,
    ),
    GetPage(
      name: RouteName.bluetoothConfigScreen,
      page: () => BluetoothDevicePage(),
      binding: BindingsBuilder(() {
        // Get.put(BluetoothDeviceController());
        Get.lazyPut<BluetoothDeviceController>(
          () => BluetoothDeviceController(),
          fenix: true,
        );
      }),
      transition: .noTransition,
    ),
  ];
}
