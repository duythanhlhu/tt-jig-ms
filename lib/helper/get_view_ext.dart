import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tt_jig_ms/core/network/connection_manager.dart';
import 'package:tt_jig_ms/helper/bluetooth_scanner_manager.dart';
import 'package:tt_jig_ms/helper/helper.dart';
import 'package:tt_jig_ms/helper/language_provider.dart';
import 'package:tt_jig_ms/helper/list_view_manager.dart';
import 'package:tt_jig_ms/l10n/app_localizations.dart';
import 'package:tt_jig_ms/modules/bluetooth/bluetooth_device_controller.dart';
import 'package:tt_jig_ms/modules/bluetooth/bluetooth_device_page.dart';

extension GetViewExt<T extends GetxController> on GetView<T> {
  AppLocalizations get localize => Get.context!.localize;

  Widget languageSelector() {
    LanguageProvider languageProvider = Get.find<LanguageProvider>();
    return PopupMenuButton<String>(
      initialValue: languageProvider.currentLocale.languageCode,
      icon: Image.asset(
        AssetHelper.getIconPath(
          "${languageProvider.currentLocale.languageCode}.png",
        ),
        width: 35,
        height: 35,
      ),
      onSelected: (String value) async {
        // Handle the selection logic here
        debugPrint('Selected: $value');
        await languageProvider.switchLocale(value);
        // You can add logic to perform actions or update UI state
        controller.update();
      },
      itemBuilder: (BuildContext context) =>
          AppLocalizations.supportedLocales.map((e) {
            final FlutterLocalization localization =
                FlutterLocalization.instance;
            return PopupMenuItem<String>(
              value: e.languageCode,
              child: Row(
                children: [
                  Image.asset(
                    AssetHelper.getIconPath("${e.languageCode}.png"),
                    width: 35,
                    height: 35,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    localization.getLanguageName(languageCode: e.languageCode),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget listViewSelector(ListType selected, Function(ListType) callBack) {
    return PopupMenuButton<ListType>(
      icon: Image.asset(
        AssetHelper.getIconPath("${selected.name}.png"),
        width: 25,
        height: 25,
      ),
      initialValue: selected,
      onSelected: callBack,
      itemBuilder: (BuildContext context) => ListType.values.map((e) {
        return PopupMenuItem<ListType>(
          value: e,
          child: Row(
            children: [
              Image.asset(
                AssetHelper.getIconPath("${e.name}.png"),
                width: 25,
                height: 25,
              ),
              const SizedBox(width: 8),
              Text(context.translate(e.name)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget connectionIndicator() {
    final connectionManager = ConnectionManager();
    return ObxValue((status) {
      return Tooltip(
        message: status.value == .connected
            ? localize.connected
            : localize.notConnected,
        child: Icon(
          status.value == InternetStatus.connected
              ? Icons.wifi
              : Icons.signal_wifi_statusbar_connected_no_internet_4,
          size: 25,
          color: status.value == InternetStatus.connected
              ? Colors.greenAccent
              : Colors.redAccent,
        ),
      );
    }, connectionManager.internetStatus);
  }

  Widget scannerSelector() {
    BluetoothScannerManager bluetoothScannerManager = BluetoothScannerManager();
    return PopupMenuButton<String>(
      icon: Icon(Icons.qr_code_scanner, size: 25),
      onSelected: (String value) async {
        if (value == "camera" ||
            (value == "bt" && bluetoothScannerManager.isConnected.value)) {
          bluetoothScannerManager.scannerPriority.value =
              ScannerPriority.camera;
          bluetoothScannerManager.disconnect();
        } else {
          if (!bluetoothScannerManager.isConnected.value) {
            goToBluetoothPage();
          }
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: "camera",
          child: Row(
            children: [
              ObxValue((priority) {
                return Icon(
                  Icons.camera_alt,
                  color: priority.value == ScannerPriority.camera
                      ? Colors.blue
                      : Colors.grey,
                  size: 25,
                );
              }, bluetoothScannerManager.scannerPriority),
              SizedBox(width: 4),
              Text(localize.camera),
            ],
          ),
        ),
        PopupMenuItem(
          value: "bt",
          child: Row(
            children: [
              ObxValue((priority) {
                return priority.value == ScannerPriority.bluetooth
                    ? Icon(Icons.bluetooth, color: Colors.blue, size: 25)
                    : Icon(
                        Icons.bluetooth_disabled,
                        color: Colors.grey,
                        size: 25,
                      );
              }, bluetoothScannerManager.scannerPriority),
              SizedBox(width: 4),
              Text(localize.bluetooth),
            ],
          ),
        ),
      ],
    );
  }

  Widget infoField(
    IconData icons,
    String title,
    String subtitle,
    TextStyle subtitleStyle,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icons, size: 20),
          SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: secondaryTextStyle(size: 8)),
                Text(subtitle, style: subtitleStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget moveSegment(
    IconData departureIcon,
    String departure,
    IconData destinationIcon,
    String destination,
  ) {
    return Center(
      child: FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(departureIcon, size: 14),
            Text(departure, style: primaryTextStyle(size: 12)),
            SizedBox(width: 2),
            Icon(Icons.arrow_forward, size: 14),
            SizedBox(width: 2),
            Icon(destinationIcon, size: 14),
            Text(destination, style: primaryTextStyle(size: 12)),
          ],
        ),
      ),
    );
  }

  void goToBluetoothPage() {
    Get.dialog(
      const BluetoothDevicePage(),
      barrierDismissible: true, // 🔥 tap outside to close
      barrierColor: Colors.black54, // background overlay
    );
    // Get.to(
    //   () => const BluetoothDevicePage(),
    //   opaque: false, // Menjadikan latar belakang transparan
    //   transition: Transition.fadeIn, // Animasi muncul
    //   fullscreenDialog: true, // Opsional: Memberi nuansa dialog di iOS
    //   preventDuplicates: true,
    //   popGesture: false,
    // );
    Get.put(BluetoothDeviceController());
  }
}

extension ContextL10n on BuildContext {
  AppLocalizations get localize => AppLocalizations.of(this)!;

  String translate(String key) {
    switch (key) {
      case "incomingItem":
        return localize.incomingItem;
      case "building":
        return localize.building;
      case "outgoingItem":
        return localize.outgoingItem;
      case "move":
        return localize.move;
      case "rack":
        return localize.rack;
      case "kukdong":
        return localize.kukdong;
      case "stockOnHand":
        return localize.stockOnHand;
      case "onHand":
        return localize.onHand;
      case "inventory":
        return localize.inventory;
      case "rackMonitoring":
        return localize.rackMonitoring;
      case "monitoring":
        return localize.monitoring;
      case "sewing":
        return localize.sewing;
      case "returnItem":
        return localize.returnItem;
      case "items":
        return localize.items;
      case "item":
        return localize.item;
      case "box":
        return localize.box;
      case "barcodeInfo":
        return localize.barcodeInfo;
      case "destroyItem":
        return localize.destroyItem;
      case "stockOpname":
        return localize.stockOpname;
      case "ERR_CLEARTEXT_NOT_PERMITTED":
        return localize.cantReach;
      case "returnDate":
        return localize.returnDate;
      case "brokenDate":
        return localize.brokenDate;
      case "fixedDate":
        return localize.fixedDate;
      case "history":
        return localize.history;
      case "success":
        return localize.success;
      case "warning":
        return localize.warning;
      case "error":
        return localize.error;
      case "content":
        return localize.content;
      case "list":
        return localize.list;
      case "Item to Box":
        return localize.item2Box;
      case "Box to Rack":
        return localize.box2Rack;
      case "Box to Box":
        return localize.box2Box;
      case "Scanning Sender ID":
        return localize.scanSenderID;
      case "Scanning Receiver ID":
        return localize.scanReceiverID;
      case "Scanning Item ID":
        return localize.scanItemID;
      case "Scanning Box ID":
        return localize.scanBoxID;
      case "Scanning Rack ID":
        return localize.scanRackID;
      default:
        return key;
    }
  }
}
