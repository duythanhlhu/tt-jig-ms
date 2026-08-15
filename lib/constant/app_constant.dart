import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Env {
  static String serverDomain = "172.70.10.166";
  static String get projectName => kDebugMode ? 'jigmsmobile' : 'jigmsmobile';
  static String apiBaseUrl =
      "https://tkgsdh.t2group.co.kr/$projectName"; //"http://$serverDomain/tkgsdh/$projectName";

  // Version
  static String appName = 'jigms_mobile';
  static String dbLink = 'TKSI_VERSION@DL_MESTOMES20';

  // cache key
  static String cookieStoreKey = 'cookieStoreKey';
  static String serverStoreKey = 'serverStoredKey';
  static String languageStoreKey = 'languageStoreKey';
  static String rememberMeStoreKey = 'rememberMeStoreKey';
  static String lastDeviceAddressStoreKey = 'lastDeviceAddressStoreKey';
}

class AppConstant {
  static String appName = "TTMobile iFrame";
  static String appDesc = "Mobile Management System";
  // static String appVersion = "1.0.0.1";
  // static String appVersionBottom = "v$appVersion";

  static String imagePath = "assets/images/";
  static String iconPath = "assets/icons/";
  static String soundPath = "sounds/";

  static String kukdongURL =
      "https://tkgsdh.t2group.co.kr/kukdong"; // "http://${Env.serverDomain}/tkgsdh/kukdong"
  static String rackURL =
      "https://tkgsdh.t2group.co.kr/jigmsmobile/rack"; // 'http://${Env.serverDomain}/tkgsdh/${Env.projectName}/rack',
  static String onHandURL =
      "https://tkgsdh.t2group.co.kr/jigmsmobile/onhand"; // 'http://${Env.serverDomain}/tkgsdh/${Env.projectName}/onhand',
  static String sewingURL = "https://tkgsdh.t2group.co.kr/sewingmonitoring";
  static String jigWarehouseURL = "http://${Env.serverDomain}/Jig_Warehouse";
  static String jigURL =
      "https://tkgsdh.t2group.co.kr/jig"; //"http://${Env.serverDomain}/tkgsdh/jig";
}

class AppColor {
  static Color tkgColor = const Color.fromRGBO(6, 163, 159, 1);
  static Color tkgColor2 = const Color.fromARGB(255, 155, 232, 229);
  static Color tkgColorPink = const Color.fromARGB(255, 249, 213, 210);
  static Color tkgColorBlue = const Color.fromARGB(255, 186, 222, 251);
  static Color tkgColorGrey = const Color(0xfff5f5f5);
  static Color tkgColorYellow = Colors.yellow.shade100;
  static Color tkgColorOrange = const Color.fromARGB(255, 246, 195, 118);
  static Color tkgColorGreen = Colors.green.shade100;
  static Color redtkgColor = const Color.fromARGB(255, 245, 97, 97);
  static Color primaryColor = Colors.blue.shade700;
  static Color colorBlue = Colors.blue;
  static Color colorDarkBlue = Colors.blue.shade700;
  static Color colorRed = Colors.red;
  static Color colorCyan = Colors.cyan.shade300;
  static Color colorLightGrey = Colors.grey.shade300;
  static Color colorLightGrey100 = Colors.grey.shade100;
  static Color colorGreyShade = const Color(0xfff5f5f5);

  static Color appColorPrimary = Color(0xFF1157FA);
  static Color iconColorPrimary = Color(0xFFFFFFFF);
  static Color iconColorSecondary = Color(0xFFA8ABAD);
  static Color appSecondaryBackgroundColor = Color(0xFF131d25);
  static Color appTextColorPrimary = Color(0xFF212121);
  static Color appTextColorSecondary = Color(0xFF5A5C5E);
  static Color appShadowColor = Color(0x95E9EBF0);
  static Color appColorPrimaryLight = Color(0xFFF9FAFF);

  // Dark Theme Colors
  static Color appBackgroundColorDark = Color(0xFF121212);
  static Color cardBackgroundBlackDark = Color(0xFF1F1F1F);
  static Color colorPrimaryBlack = Color(0xFF131d25);
  static Color iconColorPrimaryDark = Color(0xFF212121);
  static Color iconColorSecondaryDark = Color(0xFFA8ABAD);
  static Color appShadowColorDark = Color(0x1A3E3942);
}
