import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tt_jig_ms/constant/app_constant.dart';
import 'package:tt_jig_ms/core/network/exception/api_exception.dart';

class Helper {
  // static final Helper _instance = Helper._internal();

  // factory Helper() => _instance;

  // Helper._internal();

  var state = ViewState.idle().obs;

  static bool isTablet =
      (PlatformDispatcher.instance.views.first.physicalSize.shortestSide /
          PlatformDispatcher.instance.views.first.devicePixelRatio) >=
      600;

  static bool isTabletWith(BuildContext context) {
    final double width = MediaQuery.of(context).size.shortestSide;

    return width >= 600;
  }

  static Orientation getDeviceOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  static Future<void> setLandscapeOrientation() async {
    await Future.delayed(const Duration(milliseconds: 400));

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  static Future<void> setDefaultOrientation() async {
    // await Future.delayed(const Duration(milliseconds: 400));

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  static Future<void> setPotraitOrientation() async {
    await Future.delayed(const Duration(milliseconds: 400));

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }
}

class AssetHelper {
  static String getImagePath(String name) {
    return AppConstant.imagePath + name;
  }

  static String getIconPath(String name) {
    return AppConstant.iconPath + name;
  }

  static String getSoundPath(String name) {
    return AppConstant.soundPath + name;
  }
}

extension DateTimeExt on DateTime {
  String reformatTo(String format) {
    return DateFormat(
      format,
      Get.locale?.languageCode ?? Locale("en").languageCode,
    ).format(this);
  }
}

extension StringExt on String {
  String get removePrefixSufixZebra =>
      replaceAll(RegExp(r'[\x00-\x1F\x7F-\xFF]'), '');
  String get cleanScan => replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '').trim();

  String extractStringInBrackets({String prefix = "(", String sufix = ")"}) {
    int startIndex = indexOf(prefix);
    int endIndex = indexOf(sufix);

    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      return substring(startIndex + 1, endIndex);
    } else {
      return "";
    }
  }

  String get cleanBarcode {
    // 1. Hapus karakter non-ASCII (seperti Ã³, Ã¼)
    String clearASCII = replaceAll(RegExp(r'[^\x20-\x7E]'), '').trim();

    // 2. Gunakan Regex untuk mengambil pola yang valid saja:
    // Pola ini mencari: Huruf/Angka di awal, diikuti kombinasi Huruf, Angka, atau Hubung (-)
    // Dan secara otomatis mengabaikan 'q' kecil di akhir jika itu karakter tambahan scanner
    RegExp regex = RegExp(r'[A-Z0-9][A-Z0-9-]*[0-9A-Z]');

    Iterable<RegExpMatch> matches = regex.allMatches(clearASCII);

    if (matches.isNotEmpty) {
      return matches.first.group(0) ?? "";
    }

    return clearASCII; // Fallback jika tidak ada match
  }
}
