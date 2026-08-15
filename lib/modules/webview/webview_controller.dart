import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';
import 'package:tt_jig_ms/constant/app_constant.dart';
import 'package:tt_jig_ms/core/network/connection_manager.dart';
import 'package:tt_jig_ms/core/network/exception/api_exception.dart';
import 'package:tt_jig_ms/data/model/menu_model.dart';
import 'package:tt_jig_ms/helper/app_config.dart';
import 'package:tt_jig_ms/helper/get_controller_ext.dart';
import 'package:tt_jig_ms/helper/helper.dart';
import 'package:tt_jig_ms/helper/language_provider.dart';

class WebviewController extends GetxController {
  late StreamSubscription<InternetStatus> subscription;
  final connectionManager = ConnectionManager();
  final internetStatus = ConnectionManager().internetStatus;
  final ipAddress = "".obs;
  final deviceInfo = "".obs;
  final helper = Helper();

  late MenuModel selectedMenu;
  late Worker _worker;

  InAppWebViewController? _webViewController;

  final languageProvider = Get.find<LanguageProvider>();
  final configService = Get.find<AppConfigService>();

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      requestPermission();
      _getDeviceIPAddress();
      _restoreCookies();
      deviceInfo.value = configService.deviceInfo.value;
      // _handleConnection();
    });
    super.onInit();

    selectedMenu = Get.arguments;

    _worker = ever(connectionManager.internetStatus, (status) {
      internetStatus.value = status;
      if (status == InternetStatus.disconnected) {
        helper.state.value = .error(
          MessageException(message: localize.connectionGone, type: .error),
        );
      } else {
        helper.state.value = .idle();
        reloadWebView();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _worker.dispose();
    helper.state.value = .idle();
  }

  @override
  void onClose() async {
    _worker.dispose();
    await Helper.setPotraitOrientation();
    super.onClose();
    helper.state.value = .idle();
  }

  @override
  void onReady() async {
    super.onReady();
    await Helper.setLandscapeOrientation();
  }

  // MARK: API
  Future<void> requestPermission() async {
    String? message;
    try {
      // Request camera permission
      final cameraStatus = await Permission.camera.request();
      switch (cameraStatus) {
        case PermissionStatus.granted:
          message = localize.cameraGranted;
          break;
        case PermissionStatus.denied:
          message = localize.cameraDenied;
          break;
        case PermissionStatus.permanentlyDenied:
          message = localize.cameraDeniedPermanent;
          break;
        default:
          message = localize.init;
      }

      // Request microphone permission (might be needed for video)
      final microphoneStatus = await Permission.microphone.request();
      switch (microphoneStatus) {
        case PermissionStatus.granted:
          message = localize.micGranted;
          break;
        case PermissionStatus.denied:
          message = localize.micDenied;
          break;
        case PermissionStatus.permanentlyDenied:
          message = localize.micDeniedPermanent;
          break;
        default:
          message = localize.init;
      }
    } catch (e) {
      message = sprintf(localize.errorPemission, [e]);
    }
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  Future<void> saveCookie() async {
    final prefs = await SharedPreferences.getInstance();
    final cookieManager = CookieManager.instance();

    try {
      // Get all cookies for the domain
      final cookies = await cookieManager.getCookies(url: selectedMenu.url!);

      // Serialize cookies to JSON
      final cookiesList = cookies.map((cookie) {
        return {
          'name': cookie.name,
          'value': cookie.value,
          'domain': cookie.domain ?? selectedMenu.url!.host,
          'path': cookie.path ?? '/',
          'isHttpOnly': cookie.isHttpOnly,
          'isSecure': cookie.isSecure,
          'expiresDate': cookie.expiresDate,
          'sameSite': cookie.sameSite?.toString(),
        };
      }).toList();

      final jsonString = jsonEncode(cookiesList);
      await prefs.setString(Env.cookieStoreKey, jsonString);
      debugPrint('Cookies persisted: ${cookiesList.length} cookies saved');
    } catch (e) {
      debugPrint('Failed to persist cookies: $e');
    }
  }

  Future<void> _restoreCookies() async {
    final prefs = await SharedPreferences.getInstance();
    final cookieManager = CookieManager.instance();

    try {
      final jsonString = prefs.getString(Env.cookieStoreKey);
      if (jsonString == null || jsonString.isEmpty) {
        debugPrint('No saved cookies found');
        return;
      }

      final cookiesList = jsonDecode(jsonString) as List;

      debugPrint('Restoring ${cookiesList.length} cookies...');

      for (var cookieData in cookiesList) {
        try {
          HTTPCookieSameSitePolicy? sameSitePolicy;
          if (cookieData['sameSite'] != null) {
            final sameSiteStr = cookieData['sameSite'] as String;
            if (sameSiteStr.contains('LAX')) {
              sameSitePolicy = HTTPCookieSameSitePolicy.LAX;
            } else if (sameSiteStr.contains('STRICT')) {
              sameSitePolicy = HTTPCookieSameSitePolicy.STRICT;
            } else if (sameSiteStr.contains('NONE')) {
              sameSitePolicy = HTTPCookieSameSitePolicy.NONE;
            }
          }

          await cookieManager.setCookie(
            url: selectedMenu.url!,
            name: cookieData['name'] as String,
            value: cookieData['value'] as String,
            domain: cookieData['domain'] as String? ?? selectedMenu.url!.host,
            path: cookieData['path'] as String? ?? '/',
            isHttpOnly: cookieData['isHttpOnly'] as bool? ?? false,
            isSecure: cookieData['isSecure'] as bool? ?? false,
            expiresDate: cookieData['expiresDate'] as int?,
            sameSite: sameSitePolicy,
          );
        } catch (e) {
          debugPrint('Failed to restore cookie ${cookieData['name']}: $e');
        }
      }

      debugPrint('Cookies restored successfully');
    } catch (e) {
      debugPrint('Failed to restore cookies: $e');
    }
  }

  // void _handleConnection() {
  //   connectionManager.subscription.listen((event) {
  //     internetStatus.value = event;
  //     if (event == InternetStatus.disconnected) {
  //       throw localize.connectionGone;
  //     } else {
  //       reloadWebView();
  //     }
  //   });
  // }

  void _getDeviceIPAddress() async {
    for (var interface in await NetworkInterface.list()) {
      debugPrint('== Interface: ${interface.name} ==');
      for (var addr in interface.addresses) {
        ipAddress.value = addr.address;
        debugPrint(
          '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}',
        );
      }
    }
  }

  // MARK: Setter
  void onWebViewCreated(InAppWebViewController controller) {
    _webViewController = controller;
  }

  // MARK: Action
  void reloadWebView() {
    _webViewController?.loadUrl(urlRequest: URLRequest(url: webUri()));
  }

  // MARK: Custom
  WebUri webUri({String userid = ""}) {
    final int getNowTimeStamp = DateTime.now().millisecondsSinceEpoch;

    if (userid.isEmpty) {
      userid = deviceInfo.value;
    }

    return WebUri.uri(
      Uri.http(selectedMenu.url!.host, selectedMenu.url!.path, {
        "user_id": userid,
        "ip_address": ipAddress.value,
        "datetime": getNowTimeStamp.toString(),
      }),
    );
  }
}
