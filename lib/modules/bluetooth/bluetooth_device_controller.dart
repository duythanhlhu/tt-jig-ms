import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_jig_ms/constant/app_constant.dart';
import 'package:tt_jig_ms/core/network/exception/api_exception.dart';
import 'package:tt_jig_ms/helper/bluetooth_scanner_manager.dart';
import 'package:tt_jig_ms/helper/helper.dart';

class BluetoothDeviceController extends GetxController {
  BluetoothScannerManager bluetoothManager = BluetoothScannerManager();
  final helper = Helper();
  late Worker worker;

  @override
  void dispose() {
    super.dispose();
    worker.dispose();
    helper.state.value = .idle();
  }

  @override
  void onClose() {
    worker.dispose();
    super.onClose();
    helper.state.value = .idle();
  }

  void scanDevices() async {
    try {
      await bluetoothManager.startScan();
    } catch (e) {
      helper.state.value = ViewState.error(
        MessageException(message: e.toString(), type: .warning),
      );
    }
  }

  void connectTo(Map<String, dynamic> device) async {
    bluetoothManager.selectDevice(device);
    try {
      await bluetoothManager.connect();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(Env.lastDeviceAddressStoreKey, json.encode(device));
      Get.back();
    } catch (e) {
      helper.state.value = ViewState.error(
        MessageException(message: e.toString(), type: .warning),
      );
    }
  }
}
