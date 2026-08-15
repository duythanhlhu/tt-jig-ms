import 'dart:async';

import 'package:bt_service/bt_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:universal_ble/universal_ble.dart';

enum ScannerPriority { camera, bluetooth }

class BluetoothScannerManager {
  static final BluetoothScannerManager _instance =
      BluetoothScannerManager._internal();

  factory BluetoothScannerManager() => _instance;

  BluetoothScannerManager._internal() {
    init();
  }

  // final _flutterReactiveBle = FlutterReactiveBle();
  final _btService = BtService.instance;

  RxList discoveredDevices = <Map<String, dynamic>>[].obs;

  RxBool isConnected = false.obs;
  RxBool isConnecting = false.obs;
  RxBool isScanning = false.obs;
  RxBool permissionsGranted = false.obs;
  Rx<ScannerPriority> scannerPriority = ScannerPriority.camera.obs;
  RxString result = "".obs;
  Map<String, dynamic>? selectedDevice;

  Stream<Uint8List>? dataSub;
  StreamSubscription<String>? _stateSub;
  StreamSubscription<Map<String, dynamic>>? _deviceSub;
  // StreamSubscription? _bleScanSub;
  // StreamSubscription? _bleConnectionSub;

  void init() async {
    await _requestPermissions();
    await _checkConnectionStatus();
    _setupListeners();
  }

  /// Request Bluetooth and Location permissions automatically
  Future<void> _requestPermissions() async {
    try {
      debugPrint('Requesting Bluetooth and Location permissions...');

      // Request permissions based on Android version
      final permissions = <Permission>[];

      // For Android 12+ (API 31+), we need BLUETOOTH_SCAN and BLUETOOTH_CONNECT
      // For Android < 12, we need location permissions for scanning
      if (await _isAndroid12OrHigher()) {
        permissions.addAll([
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
        ]);
        // Also request location for backward compatibility
        permissions.add(Permission.location);
      } else {
        permissions.addAll([Permission.bluetooth, Permission.location]);
      }

      final statuses = await permissions.request();

      // Check if all required permissions are granted
      bool allGranted = true;
      final deniedPermissions = <String>[];

      for (final permission in permissions) {
        final status = statuses[permission];
        if (status != null && !status.isGranted) {
          allGranted = false;
          deniedPermissions.add(permission.toString());
        }
      }

      if (allGranted) {
        debugPrint('All permissions granted successfully');
        permissionsGranted.value = true;
      } else {
        debugPrint(
          'PERMISSION ERROR: ${'Permission not granted: ${deniedPermissions.join(", ")}'}',
        );
      }
    } catch (e) {
      debugPrint('PERMISSION ERROR: ${'Failed to request permissions: $e'}');
    }
  }

  /// Check if Android version is 12 or higher
  Future<bool> _isAndroid12OrHigher() async {
    try {
      final plugin = DeviceInfoPlugin();
      final android = await plugin.androidInfo;
      // This is a simple check - in a real app you might use platform_info
      // For now, we'll request both sets of permissions to be safe
      return android.version.release.toInt() >
          11; // Assume Android 12+ to be safe
    } catch (e) {
      return true; // Default to requesting new permissions
    }
  }

  void _setupListeners() {
    try {
      _stateSub = _btService.onState.distinct().listen(
        (state) {
          if (state == "connected") {
            scannerPriority.value = ScannerPriority.bluetooth;
            isConnected.value = true;
          } else {
            scannerPriority.value = ScannerPriority.camera;
            isConnected.value = false;
          }
          isConnecting.value = false;
          if (state == 'scan_finished') {
            isScanning.value = false;
            // UniversalBle.stopScan();
            debugPrint(
              'Scan finished. Found ${discoveredDevices.length} devices',
            );
          } else {
            debugPrint('STATE: $state');
          }
        },
        onError: (error) {
          debugPrint('STATE STREAM ERROR: $error');
        },
      );

      // _flutterReactiveBle.connectedDeviceStream.listen(
      //   (state) {
      //     switch (state.connectionState) {
      //       case .connected:
      //         isConnected.value = true;
      //         scannerPriority.value = ScannerPriority.bluetooth;
      //         isConnecting.value = false;
      //         break;
      //       case .connecting:
      //         isConnecting.value = true;
      //         break;
      //       default:
      //         isConnecting.value = false;
      //         isConnected.value = false;
      //     }
      //   },
      //   onError: (error) {
      //     debugPrint('STATE STREAM ERROR: $error');
      //   },
      // );

      dataSub = _btService.onData;
      // .listen(
      //   (bytes) {
      //     debugPrint('DATA RECEIVED: ${bytes.length} bytes');
      //     // Optionally display the data as text if it's printable
      //     try {
      //       // Visualize control characters
      //       final text = String.fromCharCodes(bytes);
      //       if (text.length < 100) {
      //         result.value = text;
      //         debugPrint('  Content: $text');
      //       }
      //     } catch (_) {
      //       // Not valid UTF-8, skip text display
      //     }
      //   },
      //   onError: (error) {
      //     debugPrint('DATA STREAM ERROR: $error');
      //   },
      // );

      _deviceSub = _btService.onDeviceDiscovered.listen(
        (device) {
          try {
            // Safely extract device information
            final address = device['address']?.toString() ?? '';
            final name = device['name']?.toString() ?? 'Unknown Device';

            // Check if device already exists
            final exists = discoveredDevices.any(
              (d) => d['address']?.toString() == address,
            );
            if (!exists && address.isNotEmpty) {
              discoveredDevices.add({
                'address': address,
                'name': name,
                'type': device['type']?.toString() ?? '',
              });
              debugPrint('DEVICE FOUND: $name ($address)');
            }
          } catch (e) {
            debugPrint('ERROR parsing device: $e');
          }
        },
        onError: (error) {
          debugPrint('DEVICE STREAM ERROR: $error');
        },
      );

      // UniversalBle.scanStream.listen(
      //   (BleDevice bleDevice) {
      //     try {
      //       // Safely extract device information
      //       final address = bleDevice.deviceId;
      //       final name = bleDevice.name ?? 'Unknown Device';

      //       // Check if device already exists
      //       final exists = discoveredDevices.any(
      //         (d) => d['address']?.toString() == address,
      //       );
      //       if (!exists && address.isNotEmpty) {
      //         _addDeviceToList({
      //           'address': address,
      //           'name': name,
      //           'type': 'Ble',
      //         });
      //         debugPrint('DEVICE BLE FOUND: $name ($address)');
      //       }
      //     } catch (e) {
      //       debugPrint('ERROR parsing device: $e');
      //     }
      //   },
      //   onError: (error) {
      //     debugPrint('DATA STREAM ERROR: $error');
      //   },
      // );
    } catch (e) {
      debugPrint('ERROR setting up listeners: $e');
    }
  }

  Future<void> _checkConnectionStatus() async {
    try {
      var status = await _btService.isConnected();
      if (status) {
        scannerPriority.value = ScannerPriority.bluetooth;
      } else {
        scannerPriority.value = ScannerPriority.camera;
      }
      isConnected.value = status;
    } catch (e) {
      debugPrint('Error checking connection: $e');
    }
  }

  Future<void> connect() async {
    if (!permissionsGranted.value) {
      debugPrint(
        'ERROR: Permissions not granted. Please grant Bluetooth permissions.',
      );
      await _requestPermissions();
      return;
    }

    final addr = selectedDevice?['address'].trim();
    if (addr.isEmpty) {
      debugPrint('ERROR: Please enter a MAC address');
      return;
    }

    if (await _btService.isConnected()) {
      return;
    }

    isConnecting.value = true;
    debugPrint('Connecting to $addr...');

    await _connect(
      selectedDevice?['address'],
      selectedDevice?['type'] == 'Ble',
    );
  }

  Future<void> _connect(String address, bool isBle) async {
    try {
      if (isBle) {
        // await UniversalBle.connect(address);
      } else {
        await _btService.connect(address);
      }
      debugPrint('Connection request sent');
    } on PlatformException catch (e) {
      isConnecting.value = false;
      throw (e.message!);
    } catch (e) {
      isConnecting.value = false;
      final errorMsg = e.toString();
      if (errorMsg.contains('PERMISSION_DENIED')) {
        debugPrint(
          'PERMISSION ERROR: Permission not granted. Please grant Bluetooth permissions.',
        );
        debugPrint('Permission not granted');
        permissionsGranted.value = false;
      } else {
        debugPrint('CONNECTION ERROR: $e');
      }
    }
  }

  Future<void> disconnect() async {
    try {
      await _btService.disconnect();
      // await UniversalBle.disconnect(selectedDevice?['address']);

      isConnected.value = false;
      scannerPriority.value = ScannerPriority.camera;
      debugPrint('Disconnection requested');
    } catch (e) {
      debugPrint('DISCONNECT ERROR: $e');
    }
  }

  Future<void> startScan() async {
    if (!permissionsGranted.value) {
      debugPrint(
        'ERROR: Permissions not granted. Please grant Bluetooth permissions.',
      );
      await _requestPermissions();
      return;
    }

    isScanning.value = true;
    discoveredDevices.clear();
    debugPrint('Starting device scan...');

    try {
      await _btService.startScan();

      // UniversalBle.startScan();
    } on PlatformException catch (e) {
      isScanning.value = false;
      throw e.message!;
    } catch (e) {
      isScanning.value = false;
      final errorMsg = e.toString();
      if (errorMsg.contains('PERMISSION_DENIED')) {
        debugPrint(
          'PERMISSION ERROR: Permission not granted. Please grant Bluetooth and Location permissions.',
        );
        debugPrint('Permission not granted');
        permissionsGranted.value = false;
      } else {
        debugPrint('SCAN ERROR: $e');
      }
    }
  }

  Future<void> stopScan() async {
    try {
      await _btService.stopScan();
      // UniversalBle.stopScan();
      isScanning.value = false;
      debugPrint('Scan stopped');
    } catch (e) {
      debugPrint('STOP SCAN ERROR: $e');
    }
  }

  Future<void> loadPairedDevices() async {
    if (!permissionsGranted.value) {
      debugPrint(
        'ERROR: Permissions not granted. Please grant Bluetooth permissions.',
      );
      await _requestPermissions();
      return;
    }

    try {
      final devices = await _btService.getPairedDevices();
      // List<BleDevice> bleDevices = await UniversalBle.getSystemDevices(
      //   withServices: [],
      // );
      discoveredDevices.clear();
      discoveredDevices.addAll(devices);
      // discoveredDevices.addAll(
      //   bleDevices.map(
      //     (e) => _addDeviceToList({
      //       'address': e.deviceId,
      //       'name': e.name,
      //       'type': 'Ble',
      //     }),
      //   ),
      // );
      debugPrint('Loaded ${devices.length} paired devices');
    } catch (e) {
      final errorMsg = e.toString();
      if (errorMsg.contains('PERMISSION_DENIED')) {
        debugPrint(
          'PERMISSION ERROR: Permission not granted. Please grant Bluetooth permissions.',
        );
        debugPrint('Permission not granted');
        permissionsGranted.value = false;
      } else {
        debugPrint('ERROR loading paired devices: $e');
      }
    }
  }

  void selectDevice(Map<String, dynamic> device) {
    selectedDevice = device;
    debugPrint('Selected device: ${device['name']} (${device['address']})');
  }

  void _addDeviceToList(Map<String, dynamic> device) {
    final address = device['address'];
    if (address == null || address.isEmpty) return;

    if (!discoveredDevices.any((d) => d['address'] == address)) {
      discoveredDevices.add(device);
    }
  }

  void dispose() {
    // dataSub?.cancel();
    _stateSub?.cancel();
    _deviceSub?.cancel();
  }
}
