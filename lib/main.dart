import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:dio_log/dio_log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:optimize_battery/optimize_battery.dart';
import 'package:tt_jig_ms/core/network/connection_manager.dart';
import 'package:tt_jig_ms/core/routers/router.dart';
import 'package:tt_jig_ms/data/model/department_model.dart';
import 'package:tt_jig_ms/data/model/reason_model.dart';
import 'package:tt_jig_ms/data/model/user_model.dart';
import 'package:tt_jig_ms/helper/app_config.dart';
import 'package:tt_jig_ms/helper/bluetooth_scanner_manager.dart';
import 'package:tt_jig_ms/helper/language_provider.dart';
import 'package:tt_jig_ms/l10n/app_localizations.dart';
import 'package:tt_jig_ms/modules/splash/splash_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(DepartmentModelAdapter());
  Hive.registerAdapter(ReasonModelAdapter());

  if (await isAutoStartAvailable ?? false) {
    await getAutoStartPermission();
  }
  WakelockPlus.enable();
  OptimizeBattery.stopOptimizingBatteryUsage();
  // Manager
  ConnectionManager();
  BluetoothScannerManager();
  // Route
  Get.lazyPut(() => SplashController());
  await Get.putAsync(() => LanguageProvider().init(), permanent: true);
  await Get.putAsync(() => AppConfigService().init(), permanent: true);
  // Get.put(MainMenuController());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Get.find<LanguageProvider>();

    return Obx(() {
      return GestureDetector(
        onLongPress: () {
          // if (kDebugMode) {
          Get.to(() => HttpLogListWidget());
          // }
        },
        child: GetMaterialApp(
          navigatorKey: Get.key,
          debugShowCheckedModeBanner: kDebugMode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: languageProvider.currentLocale,
          getPages: AppRoutes.appRoutes(),
          initialRoute: RouteName.splashScreen,
          theme: ThemeData(primaryColor: Colors.white),
        ),
      );
    });
  }
}
