import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_jig_ms/constant/app_constant.dart';

class LanguageProvider extends GetxService {
  final _locale = Get.deviceLocale.obs;
  Locale get currentLocale => _locale.value ?? const Locale('en', 'US');

  Future<LanguageProvider> init() async {
    final prefs = await SharedPreferences.getInstance();
    var locale = Locale(prefs.getString(Env.languageStoreKey) ?? "en");
    _locale.value = locale;
    return this;
  }

  Future<void> switchLocale(String language) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(Env.languageStoreKey, language);

    var locale = Locale(language);
    _locale.value = locale; // Update nilai Rx
    await Get.updateLocale(locale); // Update engine GetX
    Get.forceAppUpdate(); // Memastikan Context lokal ter-refresh
  }
}
