import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tt_jig_ms/helper/get_controller_ext.dart';
import 'package:tt_jig_ms/helper/get_view_ext.dart';
import 'package:tt_jig_ms/l10n/app_localizations.dart';
import 'package:tt_jig_ms/modules/bluetooth/bluetooth_device_controller.dart';

class BluetoothDevicePage extends GetView<BluetoothDeviceController> {
  const BluetoothDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.worker = ever(controller.helper.state, (current) {
      // if (current.isLoading) {
      // showLoading();
      // } else {
      controller.hideLoading();

      if (current.exception != null) {
        controller.showError(current.exception!);
        controller.helper.state.value = .idle();
      }
      // }
    });

    AppLocalizations localize = context.localize;

    return Obx(() {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        localize.deviceDiscovery,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              (controller.bluetoothManager.isScanning.value ||
                                  controller
                                      .bluetoothManager
                                      .isConnected
                                      .value ||
                                  controller
                                      .bluetoothManager
                                      .isConnecting
                                      .value ||
                                  !controller
                                      .bluetoothManager
                                      .permissionsGranted
                                      .value)
                              ? null
                              : controller.scanDevices,
                          icon: Icon(
                            controller.bluetoothManager.isScanning.value
                                ? Icons.search
                                : Icons.search,
                          ),
                          label: Text(
                            controller.bluetoothManager.isScanning.value
                                ? '${localize.scanning}...'
                                : localize.scanDevices,
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              controller.bluetoothManager.isScanning.value
                              ? controller.bluetoothManager.stopScan
                              : null,
                          icon: const Icon(Icons.stop),
                          label: Text(localize.stop),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          (controller.bluetoothManager.isScanning.value ||
                              controller.bluetoothManager.isConnected.value ||
                              controller.bluetoothManager.isConnecting.value ||
                              !controller
                                  .bluetoothManager
                                  .permissionsGranted
                                  .value)
                          ? null
                          : controller.bluetoothManager.loadPairedDevices,
                      icon: const Icon(Icons.list),
                      label: Text(localize.pairedDevice),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  if (controller
                      .bluetoothManager
                      .discoveredDevices
                      .isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      '${localize.foundDevice} (${controller.bluetoothManager.discoveredDevices.length})',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      // height: 200,
                      child: ObxValue((devices) {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: devices.length,
                          itemBuilder: (context, index) {
                            final device = devices[index];
                            final name =
                                device['name']?.toString() ??
                                localize.unknownDevice;
                            final address = device['address']?.toString() ?? '';
                            final String? type = device['type'].toString();
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: const Icon(Icons.bluetooth),
                                title: Text("$name ($type)"),
                                subtitle: Text(address),
                                trailing: OutlinedButton(
                                  onPressed: null,
                                  child: Text(localize.select),
                                ),
                                // trailing: IconButton(
                                //   icon: const Icon(Icons.arrow_forward),
                                //   onPressed: () => controller.bluetoothManager
                                //       .selectDevice(address, name),
                                //   tooltip: 'Select this device',
                                // ),
                                onTap: () => controller.connectTo(device),
                              ),
                            );
                          },
                        );
                      }, controller.bluetoothManager.discoveredDevices),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
