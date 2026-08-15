import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_jig_ms/constant/app_constant.dart';
import 'package:tt_jig_ms/helper/version_manager.dart';

class AppConfigService extends GetxService {
  var appVersion = '1.0.0'.obs;
  var appName = ''.obs;
  var isFirstTime = true.obs;
  var cachedUserID = "".obs;
  var bluetoothAddress = "".obs;
  var deviceInfo = "".obs;

  final VersionManager versionManager = VersionManager.init(
    appName: Env.appName,
    dbLink: Env.dbLink,
  );

  Future<AppConfigService> init() async {
    debugPrint("AppConfigService starting...");
    _getPackageInfo();
    _getDeviceInfo();
    _getUserCache();
    _getBluetoothDevice();
    return this;
  }

  void _getPackageInfo() {
    PackageInfo.fromPlatform().then((value) {
      appName.value = value.appName;
      appVersion.value = value.version;
    });
  }

  void _getDeviceInfo() async {
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      this.deviceInfo.value =
          "${deviceInfo.brand} ${deviceInfo.name} (${deviceInfo.model})";
    } else if (Platform.isIOS) {
      final deviceInfo = await DeviceInfoPlugin().iosInfo;
      this.deviceInfo.value = "iOS ${deviceInfo.model}";
    }
  }

  void _getUserCache() async {
    final prefs = await SharedPreferences.getInstance();
    cachedUserID.value = prefs.getString(Env.rememberMeStoreKey) ?? "";
  }

  void cacheUser(String userID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(Env.rememberMeStoreKey, userID);
  }

  void removeBluetoothDeviceCache() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(Env.lastDeviceAddressStoreKey);
  }

  void cacheBluetoothDevice(Map device) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(Env.lastDeviceAddressStoreKey, json.encode(device));
  }

  void _getBluetoothDevice() async {
    final prefs = await SharedPreferences.getInstance();
    bluetoothAddress.value =
        prefs.getString(Env.lastDeviceAddressStoreKey) ?? "";
  }
}
