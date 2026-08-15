import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sprintf/sprintf.dart';
import 'package:tt_jig_ms/constant/app_constant.dart';
import 'package:tt_jig_ms/core/network/exception/api_exception.dart';
import 'package:tt_jig_ms/data/model/department_model.dart';
import 'package:tt_jig_ms/data/model/reason_model.dart';
import 'package:tt_jig_ms/helper/get_controller_ext.dart';
import 'package:tt_jig_ms/helper/get_view_ext.dart';
import 'package:tt_jig_ms/helper/helper.dart';
import 'package:tt_jig_ms/l10n/app_localizations.dart';
import 'package:tt_jig_ms/modules/create_transaction/create_transaction_controller.dart';

class CreateTransactionPage extends GetView<CreateTransactionController> {
  CreateTransactionPage({super.key});
  // String? scanFeedback;

  late BuildContext buildContext;
  late AppLocalizations localize;

  @override
  Widget build(BuildContext context) {
    // everAll([controller.errorMessage, controller.isLoading], (callback) {
    //   if (callback is bool) callback ? showLoading() : hideLoading();
    //   if (callback is String && callback.isNotEmpty) showError(callback);
    // });
    // controller.stateWorker = ever(controller.helper.state, (current) {
    //   if (current.isLoading) {
    //     showLoading();
    //   } else {
    //     hideLoading();

    //     if (current.exception != null) {
    //       showError(current.exception!);
    //     }
    //   }
    // });

    controller.dateWorker = ever(controller.selectedDate, (callback) {
      controller.returnDateField.text =
          callback?.reformatTo("dd MMMM yyyy") ?? "";
    });

    bool isHorizontal =
        // Helper.isTablet(context) ||
        Helper.getDeviceOrientation(context) == Orientation.landscape;

    buildContext = context;
    localize = context.localize;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text(buildContext.translate(controller.selectedMenu.title)),
        actions: [
          scannerSelector(),
          // IconButton(
          //   onPressed: () {
          //     controller.resetForm(() {
          //       controller.doResetForm();
          //     });
          //   },
          //   icon: Icon(Icons.clear),
          // ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              _buildScanModeBar(),
              Expanded(
                child: ListView(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (controller.selectedMenu.id == 10) ...[
                      _buildScanButton(),
                      Obx(() {
                        return Column(
                          children: [
                            SizedBox(height: 8),
                            _buildInfoCard(),
                            SizedBox(height: 8),
                            if ((controller.scanMode.value == .box ||
                                controller.scanMode.value == .rack))
                              _buildListTypeSegment(),
                            _buildItemHistoryList(),
                          ],
                        );
                      }),
                    ] else if (controller.selectedMenu.id == 2) ...[
                      _movingSegment(),
                      ObxValue((type) {
                        bool mustVertical =
                            isHorizontal && type.value != .item2Box;
                        return mustVertical
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _movingField(
                                  mustVertical,
                                  type.value,
                                ),
                              )
                            : Column(
                                children: _movingField(
                                  mustVertical,
                                  type.value,
                                ),
                              );
                      }, controller.moveType),
                    ] else ...[
                      _buildPartySection(),
                      // const SizedBox(height: 12),
                      // _buildScanFeedback(),
                      const SizedBox(height: 8),
                      _buildScanButton(),
                      const SizedBox(height: 16),
                      _buildItemList(),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScanModeBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      color: Colors.green.shade50,
      child: ObxValue((priority) {
        return Text(
          "${localize.scanMode}: ${priority.value == .bluetooth ? localize.bluetooth : localize.camera}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        );
      }, controller.bluetoothManager.scannerPriority),
    );
  }

  Widget _buildPartySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localize.transactionDate,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(DateTime.now().reformatTo("dd MMMM yyy")),
            Divider(),
            Obx(() {
              return controller.sender.value == null
                  ? _scanField(
                      localize.sender,
                      controller.isScanning.value &&
                              controller.scanMode.value == .sender
                          ? localize.cancelScanSenderId
                          : localize.scanSenderId,
                      () {
                        try {
                          controller.doScanAndGet(scanMode: .sender);
                        } catch (e) {
                          controller.showError(
                            MessageException(
                              message: e.toString(),
                              type: .warning,
                            ),
                          );
                        }
                      },
                    )
                  : _personField(
                      localize.sender,
                      "${controller.sender.value?.employeeID ?? ""} - ${controller.sender.value?.employeeName ?? ""}",
                      controller.isScanning.value &&
                              controller.scanMode.value == .sender
                          ? localize.cancel
                          : localize.change,
                      () {
                        try {
                          controller.doScanAndGet(
                            scanMode: .sender,
                            isEdit: true,
                          );
                        } catch (e) {
                          controller.showError(
                            MessageException(
                              message: e.toString(),
                              type: .warning,
                            ),
                          );
                        }
                      },
                    );
            }),
            Obx(() {
              return controller.receiver.value == null
                  ? _scanField(
                      localize.receiver,
                      controller.isScanning.value &&
                              controller.scanMode.value == .receiver
                          ? localize.cancelscanReceiverId
                          : localize.scanReceiverId,
                      () {
                        try {
                          controller.doScanAndGet(scanMode: .receiver);
                        } catch (e) {
                          controller.showError(
                            MessageException(
                              message: e.toString(),
                              type: .warning,
                            ),
                          );
                        }
                      },
                    )
                  : _personField(
                      localize.receiver,
                      "${controller.receiver.value?.employeeID ?? ""} - ${controller.receiver.value?.employeeName ?? ""}",
                      controller.isScanning.value &&
                              controller.scanMode.value == .receiver
                          ? localize.cancel
                          : localize.change,
                      () {
                        try {
                          controller.doScanAndGet(
                            scanMode: .receiver,
                            isEdit: true,
                          );
                        } catch (e) {
                          controller.showError(
                            MessageException(
                              message: e.toString(),
                              type: .warning,
                            ),
                          );
                        }
                      },
                    );
            }),

            if (controller.selectedMenu.id == 1) ...[
              _dropDownBuildingField(),
              _buildRemark(),
              _buildWONumber(),
            ] else if (controller.selectedMenu.id == 2)
              ...[]
            else if (controller.selectedMenu.id == 9) ...[
              _dropDownBuildingField(),
              _dropDownReturnTypeField(),
              _dropDownReasonField(),
              _buildReturnDate(),
            ] else if (controller.selectedMenu.id == 11) ...[
              _dropDownReasonField(),
            ],

            // _dropDownReturnTypeField(),
            // _dropDownReasonField(),
            // isHorizontal
            //     ? Row(children: _movingField(isHorizontal))
            //     : Column(children: _movingField(isHorizontal)),
          ],
        ),
      ),
    );
  }

  Widget _buildScanButton() {
    return Obx(() {
      var isScanning =
          controller.isScanning.value &&
          ([
                ScanMode.item,
                ScanMode.boxItem,
                ScanMode.boxDestination,
                ScanMode.rack,
              ].contains(controller.scanMode.value) ||
              ([1, 10].contains(controller.selectedMenu.id) &&
                  controller.scanMode.value == .box));
      return Column(
        children: [
          if ([1, 10].contains(controller.selectedMenu.id)) ...[
            ObxValue((type) {
              var options = controller.selectedMenu.id == 1
                  ? ScanMode.outgoing
                  : ScanMode.info;
              return SegmentedButton<ScanMode>(
                segments: options.map((e) {
                  return ButtonSegment<ScanMode>(
                    value: e,
                    label: Text(buildContext.translate(e.name.toLowerCase())),
                    icon: Icon(e.icon),
                  );
                }).toList(),
                selected: {type.value},
                onSelectionChanged: (Set<ScanMode> newSelection) {
                  if (controller.selectedMenu.id == 10) {
                    controller.setScanType(newSelection.first);
                  } else {
                    controller.confirmChange(() {
                      controller.setScanType(newSelection.first);
                    });
                  }
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(8),
                      ),
                    ),
                  ),
                ),
              );
            }, controller.goodsType),

            const SizedBox(height: 6),
          ],
          if (controller.bluetoothManager.scannerPriority.value == .bluetooth &&
              ([
                    ScanMode.item,
                    ScanMode.boxItem,
                  ].contains(controller.scanMode.value) ||
                  controller.selectedMenu.id == 10 &&
                      [
                        ScanMode.box,
                        ScanMode.rack,
                      ].contains(controller.scanMode.value))) ...[
            _waitingScanner(),
            SizedBox(height: 8),
          ],
          Row(
            children: [
              if (controller.bluetoothManager.scannerPriority.value == .camera)
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      backgroundColor: isScanning
                          ? Colors.orange
                          : ThemeData.light().colorScheme.onInverseSurface,
                    ),
                    onPressed: () {
                      try {
                        controller.doScanAndGet();
                      } catch (e) {
                        controller.showError(
                          MessageException(
                            message: e.toString(),
                            type: .warning,
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          localize.scanBarcode,
                          style: TextStyle(
                            fontSize: 18,
                            color: ThemeData.light().colorScheme.primary,
                          ),
                        ),
                        if (controller.helper.state.value.isLoading &&
                            controller.selectedMenu.id == 10) ...[
                          SizedBox(width: 8),
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              if (controller.selectedMenu.id != 10 &&
                  controller.allItem.value.isNotEmpty) ...[
                if (controller.bluetoothManager.scannerPriority.value ==
                    .camera)
                  SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      backgroundColor:
                          ThemeData.light().colorScheme.errorContainer,
                    ),
                    onPressed: () {
                      controller.clearItems(() {
                        controller.doClearList();
                        // if (controller.isScanning.value) {
                        //   controller.doScanAndGet();
                        // }
                      });
                    },
                    child: Text(localize.clear, style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ],
          ),
        ],
      );
    });
  }

  // Widget _buildScanFeedback() {
  //   if (scanFeedback == null) return const SizedBox.shrink();

  //   return Container(
  //     padding: const EdgeInsets.all(8),
  //     decoration: BoxDecoration(
  //       color: Colors.green,
  //       borderRadius: BorderRadius.circular(6),
  //     ),
  //     child: Text(scanFeedback!, style: const TextStyle(color: Colors.white)),
  //   );
  // }

  Widget _buildRemark() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localize.lineRemark,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          AppTextField(
            textFieldType: TextFieldType.OTHER,
            decoration: InputDecoration(
              hintText: localize.lineRemark,
              labelStyle: secondaryTextStyle(size: 16),
              prefixIcon: const Icon(Icons.comment, color: black),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            initialValue: controller.remark.value,
            onChanged: (value) => controller.remark.value = value,
          ),
        ],
      );
    });
  }

  Widget _buildWONumber() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Text(
            localize.woNumber,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          AppTextField(
            textFieldType: TextFieldType.OTHER,
            decoration: InputDecoration(
              hintText: localize.woNumber,
              labelStyle: secondaryTextStyle(size: 16),
              prefixIcon: const Icon(Icons.assignment_turned_in, color: black),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            initialValue: controller.woNumber.value,
            onChanged: (value) => controller.woNumber.value = value,
          ),
        ],
      );
    });
  }

  Widget _buildReturnDate() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            buildContext.translate(
              "${controller.returnType.value.name.toLowerCase()}Date",
            ),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Colors.black.withAlpha(75)),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: AppTextField(
              textFieldType: TextFieldType.OTHER,
              decoration: InputDecoration(
                hintText: buildContext.translate(
                  "${controller.returnType.value.name.toLowerCase()}Date",
                ),
                hintStyle: secondaryTextStyle(size: 16, color: Colors.grey),
                labelStyle: secondaryTextStyle(size: 16),
                prefixIcon: const Icon(Icons.calendar_month, color: black),
                border: InputBorder.none,
              ),
              textAlignVertical: TextAlignVertical.center,
              controller: controller.returnDateField,
              readOnly: true,
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: Get.context!,
                  initialDate: controller.selectedDate.value ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  controller.setReturnDate(picked);
                }
              },
              // onChanged: (value) => controller.remark.value = value,
            ),
          ),
          Divider(),
        ],
      );
    });
  }

  Widget _buildInfoCard() {
    var item = controller.item.value;
    var box = controller.boxDeparture.value;
    var rack = controller.rack.value;
    var scanMode = controller.scanMode.value;
    return item == null && box == null && rack == null
        ? SizedBox.shrink()
        : Card(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      localize.info,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: AppColor.tkgColor2,
                        decorationThickness: 2.0,
                        decorationStyle: TextDecorationStyle.solid,
                        color: Colors.transparent,
                        fontSize: 14,
                        shadows: [
                          Shadow(
                            color: AppColor.tkgColor, // Warna teks asli
                            offset: Offset(0, -5), // Geser teks ke atas
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (item != null && scanMode == .item) ...[
                    Text(
                      item.labelID ?? "-",
                      style: primaryTextStyle(
                        size: 36,
                        weight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "1 ",
                            style: primaryTextStyle(
                              size: 24,
                              weight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: localize.ofItem,
                            style: secondaryTextStyle(size: 12),
                          ),
                          TextSpan(
                            text: " ${item.groupQty} ",
                            style: primaryTextStyle(
                              size: 24,
                              weight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: localize.maxItems,
                            style: secondaryTextStyle(size: 12),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                infoField(
                                  Icons.style_outlined,
                                  localize.model,
                                  item.modelAlias ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                                infoField(
                                  Icons.gavel_sharp,
                                  localize.part,
                                  item.partAlias ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                                infoField(
                                  Icons.settings,
                                  localize.tools,
                                  item.toolingAlias ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),

                                infoField(
                                  Icons.inventory_2,
                                  localize.box,
                                  item.packLabel ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                                infoField(
                                  Icons.view_headline,
                                  localize.rack,
                                  item.rackLocation ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                infoField(
                                  Icons.person,
                                  localize.createdBy,
                                  item.createdBy ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                                infoField(
                                  Icons.date_range,
                                  localize.createdAt,
                                  item.createdAt ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                                infoField(
                                  Icons.person,
                                  localize.updatedBy,
                                  item.updatedBy ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                                infoField(
                                  Icons.date_range,
                                  localize.updatedBy,
                                  item.updatedAt ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                                infoField(
                                  Icons.compare_arrows,
                                  localize.size,
                                  item.sizeCD ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (scanMode == .box && box != null) ...[
                    Text(
                      box.packLabel ?? "-",
                      style: primaryTextStyle(
                        size: 36,
                        weight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "${box.totalItem}",
                            style: primaryTextStyle(
                              size: 24,
                              weight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: " ${localize.items}",
                            style: secondaryTextStyle(size: 12),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                infoField(
                                  Icons.style_outlined,
                                  localize.boxName,
                                  box.packName ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                                infoField(
                                  Icons.gavel_sharp,
                                  localize.type,
                                  box.packType ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                                infoField(
                                  Icons.settings,
                                  localize.rackLocation,
                                  box.rackLocation ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                infoField(
                                  Icons.person,
                                  localize.createdBy,
                                  box.createdBy ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                                infoField(
                                  Icons.date_range,
                                  localize.createdAt,
                                  box.createdAt ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (scanMode == .rack && rack != null) ...[
                    Text(
                      rack.rackLabel ?? "-",
                      style: primaryTextStyle(
                        size: 36,
                        weight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "${controller.itemInside.length}",
                            style: primaryTextStyle(
                              size: 24,
                              weight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: " ${localize.boxes}",
                            style: secondaryTextStyle(size: 12),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                infoField(
                                  Icons.style_outlined,
                                  localize.rackName,
                                  rack.rackName ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                                infoField(
                                  Icons.gavel_sharp,
                                  localize.group,
                                  rack.rackGroup ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                                infoField(
                                  Icons.settings,
                                  localize.area,
                                  rack.area ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),

                                infoField(
                                  Icons.inventory_2,
                                  localize.cell,
                                  rack.cell ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                                infoField(
                                  Icons.view_headline,
                                  localize.cellNo,
                                  rack.cellNo ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                infoField(
                                  Icons.person,
                                  localize.createdBy,
                                  rack.createdBy ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                                infoField(
                                  Icons.date_range,
                                  localize.createdAt,
                                  rack.createdAt ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                                infoField(
                                  Icons.person,
                                  localize.updatedBy,
                                  rack.updatedBy ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                                infoField(
                                  Icons.date_range,
                                  localize.updatedBy,
                                  rack.updatedAt ?? "-",
                                  secondaryTextStyle(
                                    weight: FontWeight.normal,
                                    size: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
  }

  Widget _buildItemList() {
    return Card(
      child: ObxValue((items) {
        return Column(
          children: [
            ...items.map((item) {
              return Container(
                // color: item.isUnknown ? Colors.yellow.shade200 : null,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.labelID ?? "-",
                            style: primaryTextStyle(
                              size: 16,
                              weight: fontWeightBoldGlobal,
                            ),
                          ),
                          Text(
                            item.description,
                            style: secondaryTextStyle(size: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.confirmRemoveItem(
                          item: item,
                          confirm: () {
                            controller.doRemoveItem(item: item);
                          },
                        );
                      },
                      icon: Icon(
                        Icons.remove_circle,
                        size: 20,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            }),
            controller.helper.state.value.isLoading &&
                    [
                      ScanMode.item,
                      ScanMode.boxItem,
                    ].contains(controller.scanMode.value)
                ? CircularProgressIndicator()
                : SizedBox.shrink(),
          ],
        );
      }, controller.allItem),
    );
  }

  Widget _buildListTypeSegment() {
    return ObxValue((option) {
      var segments = controller.scanMode.value == .rack
          ? DetailListType.rack
          : DetailListType.nonRack;
      return SegmentedButton<DetailListType>(
        showSelectedIcon: false,
        segments: segments.map((e) {
          var str = "";
          if (e == .history) {
            str = controller.itemHistory.isNotEmpty
                ? " (${controller.itemHistory.length})"
                : "";
          } else {
            str = controller.itemInside.isNotEmpty
                ? " (${controller.itemInside.length})"
                : "";
          }
          return ButtonSegment<DetailListType>(
            value: e,
            label: Text(sprintf("%s%s", [buildContext.translate(e.name), str])),
          );
        }).toList(),
        selected: {option.value},
        onSelectionChanged: (Set<DetailListType> newSelection) {
          controller.setDetailListType(newSelection.first);
        },
        style: ButtonStyle(
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.all(Radius.circular(8)),
            ),
          ),
        ),
      );
    }, controller.listType);
  }

  Widget _buildItemHistoryList() {
    return Card(
      child: Column(
        children: [
          if (controller.itemDetail.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                // "${buildContext.translate(controller.listType.value.name.toLowerCase())} (${controller.itemDetail.length})",
                buildContext.translate(
                  controller.listType.value.name.toLowerCase(),
                ),
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationColor: AppColor.tkgColor2,
                  decorationThickness: 2.0,
                  decorationStyle: TextDecorationStyle.solid,
                  color: Colors.transparent,
                  fontSize: 14,
                  shadows: [
                    Shadow(
                      color: AppColor.tkgColor, // Warna teks asli
                      offset: Offset(0, -5), // Geser teks ke atas
                    ),
                  ],
                ),
              ),
            ),
          ...controller.itemDetail.map((item) {
            return Container(
              margin: EdgeInsets.only(left: 12, right: 12, bottom: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        infoField(
                          Icons.label,
                          localize.labelId,
                          item.labelID ?? "-",
                          primaryTextStyle(
                            size: 16,
                            weight: fontWeightBoldGlobal,
                          ),
                        ),
                        infoField(
                          Icons.description,
                          localize.desc,
                          item.description ?? "-",
                          secondaryTextStyle(size: 12),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        infoField(
                          Icons.person,
                          localize.createdBy,
                          item.createdBy ?? "-",
                          secondaryTextStyle(size: 12),
                        ),
                        infoField(
                          Icons.calendar_month,
                          localize.createdAt,
                          item.createdAt ?? "-",
                          secondaryTextStyle(size: 12),
                        ),
                      ],
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     controller.doRemoveItem(item: item);
                  //   },
                  //   icon: Icon(Icons.remove_circle, size: 20),
                  // ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    controller.helper.state.value.exception?.message ?? "",
                    style: primaryTextStyle(color: Colors.red, size: 20),
                  ),
                ),
                // controller.isScanning.value
                //     ? CustomLoadingText(
                //         message: buildContext.translate(
                //           controller.scanMode.value?.message ?? "",
                //         ),
                //       )
                //     : SizedBox.shrink(),
                // Spacer(),
                // controller.helper.state.value.isLoading
                //     ? CircularProgressIndicator()
                //     : SizedBox.shrink(),
                // Spacer(),
                if ([1, 9, 11].contains(controller.selectedMenu.id) ||
                    (controller.selectedMenu.id == 2 &&
                        controller.moveType.value == .item2Box))
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${localize.totalItems}: ${controller.allItem.length}",
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            if (controller.selectedMenu.id != 10) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.submitButtonAction,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        backgroundColor: Colors.green,
                      ),
                      child: Text(
                        localize.submit,
                        style: primaryTextStyle(color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.cancelButton.value
                          ? () {
                              controller.resetForm(() {
                                controller.doResetForm();
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        localize.cancel,
                        style: primaryTextStyle(color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      }),
    );
  }

  Widget _scanField(String title, String subtitle, VoidCallback onTap) {
    var containerColor = subtitle.contains(localize.cancel)
        ? Colors.orange
        : Colors.transparent;
    var buttonColor = subtitle.contains(localize.cancel)
        ? Colors.white
        : ThemeData.light().colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: subtitle.contains(localize.cancel)
                  ? SizedBox(
                      height: 48,
                      child: Stack(
                        alignment: .center,
                        children: [
                          Positioned.fill(
                            top: 4,
                            bottom: 4,
                            child: Shimmer.fromColors(
                              baseColor: Colors.orange,
                              highlightColor: Colors.yellow,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: BorderSide(
                                    color: Colors.black.withAlpha(75),
                                    width: 1,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: onTap,
                                child: SizedBox.expand(),
                              ),
                            ),
                          ),
                          IgnorePointer(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  subtitle,
                                  style: TextStyle(color: Colors.white),
                                ),
                                if (controller.helper.state.value.isLoading &&
                                    subtitle.contains(localize.cancel)) ...[
                                  SizedBox(width: 8),
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(4),
                        ),
                        side: BorderSide(
                          color: Colors.black.withAlpha(75),
                          width: 1,
                        ),
                        // backgroundColor: containerColor,
                      ),
                      onPressed: onTap,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(subtitle, style: TextStyle(color: buttonColor)),
                          if (controller.scanMode.value != null)
                            if (controller.helper.state.value.isLoading &&
                                controller
                                        .bluetoothManager
                                        .scannerPriority
                                        .value ==
                                    .camera &&
                                ((controller.scanMode.value!.index == 0 &&
                                        title == "Sender") ||
                                    (controller.scanMode.value!.index == 1 &&
                                        title == "Receiver") ||
                                    (controller.scanMode.value!.index == 4 &&
                                        (title == "BOX" ||
                                            title == "OLD LOCATION BOX ID")) ||
                                    (controller.scanMode.value!.index == 5 &&
                                        title == "NEW LOCATION BOX ID") ||
                                    (controller.scanMode.value!.index == 6 &&
                                        title == "RACK"))) ...[
                              SizedBox(width: 8),
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(),
                              ),
                            ],
                        ],

                        // Text(
                        //   subtitle,
                        //   style: TextStyle(color: buttonColor),
                      ),
                    ),
            ),
          ],
        ),
        // Row(
        //   children: [
        //     Expanded(
        //       child: OutlinedButton(
        //         style: OutlinedButton.styleFrom(
        //           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadiusGeometry.circular(4),
        //           ),
        //           side: BorderSide(color: Colors.black.withAlpha(75), width: 1),
        //           // backgroundColor: containerColor,
        //         ),
        //         onPressed: onTap,
        //         child: Text(subtitle, style: TextStyle(color: buttonColor)),
        //       ),
        //     ),
        //   ],
        // ),
        Divider(),
      ],
    );
  }

  Widget _personField(
    String title,
    String value,
    String button,
    VoidCallback onChange,
  ) {
    var containerColor = button.contains(localize.cancel)
        ? Colors.orange
        : Colors.transparent;
    var contentColor = button.contains(localize.change)
        ? Colors.black
        : Colors.white;
    var borderColor = button.contains(localize.change)
        ? Colors.grey
        : Colors.white;
    var buttonColor = button.contains(localize.change)
        ? ThemeData.light().colorScheme.primary
        : Colors.white;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        Stack(
          alignment: .center,
          children: [
            if (button.contains(localize.cancel))
              Positioned.fill(
                child: Shimmer.fromColors(
                  baseColor: Colors.orange,
                  highlightColor: Colors.yellow,
                  child: Container(
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: containerColor,
                    ),
                    padding: EdgeInsets.all(4),
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                border: BoxBorder.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              padding: EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.person, size: 16, color: contentColor),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(value, style: TextStyle(color: contentColor)),
                  ),
                  OutlinedButton(
                    onPressed: onChange,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(4),
                      ),
                      side: BorderSide(color: borderColor),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(0),
                      child: Text(button, style: TextStyle(color: buttonColor)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Container(
        //   decoration: BoxDecoration(
        //     border: BoxBorder.all(color: Colors.grey, width: 1),
        //     borderRadius: BorderRadius.all(Radius.circular(4)),
        //     color: containerColor,
        //   ),
        //   padding: EdgeInsets.all(4),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: [
        //       Icon(Icons.person, size: 16, color: contentColor),
        //       SizedBox(width: 8),
        //       Expanded(
        //         child: Text(value, style: TextStyle(color: contentColor)),
        //       ),
        //       OutlinedButton(
        //         onPressed: onChange,
        //         style: OutlinedButton.styleFrom(
        //           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        //           minimumSize: Size.zero,
        //           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadiusGeometry.circular(4),
        //           ),
        //           side: BorderSide(color: borderColor),
        //         ),
        //         child: Container(
        //           margin: EdgeInsets.all(0),
        //           child: Text(button, style: TextStyle(color: buttonColor)),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Divider(),
      ],
    );
  }

  Widget _itemScanField(
    ScanMode type,
    String value,
    bool isEdit,
    VoidCallback onChange, {
    String? title,
  }) {
    IconData icon;
    switch (type) {
      case .item:
        icon = Icons.shopping_bag;
        break;
      case .box:
        icon = Icons.inventory_2;
        break;
      default:
        icon = Icons.view_headline;
        break;
    }
    var containerColor = isEdit ? Colors.orange : Colors.transparent;
    var contentColor = !isEdit ? Colors.black : Colors.white;
    var borderColor = !isEdit ? Colors.grey : Colors.white;
    var buttonColor = !isEdit
        ? ThemeData.light().colorScheme.primary
        : Colors.white;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title ?? type.name, style: TextStyle(fontWeight: FontWeight.bold)),
        Container(
          decoration: BoxDecoration(
            border: BoxBorder.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: containerColor,
          ),
          padding: EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, size: 16, color: contentColor),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: primaryTextStyle(size: 24, color: contentColor),
                ),
              ),
              OutlinedButton(
                onPressed: onChange,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(4),
                  ),
                  side: BorderSide(color: borderColor),
                ),
                child: Container(
                  margin: EdgeInsets.all(0),
                  child: Text(
                    isEdit ? localize.cancel : localize.change,
                    style: TextStyle(color: buttonColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _dropDownBuildingField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localize.department,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ObxValue((items) {
          return CustomDropdown<DepartmentModel>.search(
            closedHeaderPadding: EdgeInsets.all(8),
            items: items.value,
            canCloseOutsideBounds: true,
            excludeSelected: false,
            initialItem: controller.selectedDepartment.value,
            onChanged: (value) {
              controller.selectedDepartment.value = value;
              controller.activateSubmitButton();
              controller.activateCancelButton();
            },
            decoration: CustomDropdownDecoration(
              closedBorderRadius: BorderRadius.circular(4),
              expandedBorderRadius: BorderRadius.circular(4),
              prefixIcon: Icon(Icons.factory),
              closedFillColor: Colors.transparent,
              closedBorder: BoxBorder.all(color: Colors.black.withAlpha(75)),
            ),

            hintText: "${localize.search} ${localize.department}",
          );
        }, controller.departments),
        Divider(),
      ],
    );
  }

  Widget _dropDownReturnTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localize.returnType,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        CustomDropdown<String>.search(
          closedHeaderPadding: EdgeInsets.all(8),
          items: ReturnType.values
              .where((element) => element != .destroy)
              .map((e) => e.name)
              .toList(),
          initialItem: controller.returnType.value.name,
          canCloseOutsideBounds: true,
          excludeSelected: false,
          onChanged: (value) {
            controller.returnType.value = ReturnType.withName(value ?? "");
          },
          decoration: CustomDropdownDecoration(
            closedBorderRadius: BorderRadius.circular(4),
            expandedBorderRadius: BorderRadius.circular(4),
            prefixIcon: Icon(Icons.merge_type),
            closedFillColor: Colors.transparent,
            closedBorder: BoxBorder.all(color: Colors.black.withAlpha(75)),
          ),

          hintText: "${localize.select} ${localize.returnType}",
        ),
        Divider(),
      ],
    );
  }

  Widget _dropDownReasonField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localize.reason, style: TextStyle(fontWeight: FontWeight.bold)),
        ObxValue((items) {
          return CustomDropdown<ReasonModel>.search(
            closedHeaderPadding: EdgeInsets.all(8),
            items: items.value,
            canCloseOutsideBounds: true,
            excludeSelected: false,
            onChanged: (value) {
              if (value != null) {
                controller.setReason(value);
              }
            },
            decoration: CustomDropdownDecoration(
              closedBorderRadius: BorderRadius.circular(4),
              expandedBorderRadius: BorderRadius.circular(4),
              prefixIcon: Icon(Icons.note_alt_sharp),
              closedFillColor: Colors.transparent,
              closedBorder: BoxBorder.all(color: Colors.black.withAlpha(75)),
            ),
            initialItem: controller.selectedReason.value,
            hintText: "${localize.select} ${localize.reason}",
          );
        }, controller.reasons),
        Divider(),
      ],
    );
  }

  Widget _itemField({ScanMode type = .item, MoveType move = .departure}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.all(8),
      child: IntrinsicHeight(
        child: Column(
          children: [
            Obx(() {
              switch (type) {
                case .box || .boxDestination:
                  if ((move == .departure &&
                          controller.boxDeparture.value == null) ||
                      (move == .destination &&
                          controller.boxDestination.value == null)) {
                    return _scanField(
                      move == .destination
                          ? localize.newLocationBoxId.toUpperCase()
                          : type == .box &&
                                [
                                  MovingType.item2Box,
                                  MovingType.box2Rack,
                                ].contains(controller.moveType.value)
                          ? localize.box.toUpperCase()
                          : localize.oldLocationBoxId.toUpperCase(),
                      controller.isScanning.value &&
                              controller.scanMode.value == type
                          ? localize.cancelBoxId
                          : localize.scanBoxId,
                      () {
                        try {
                          controller.doScanAndGet(
                            scanMode: move == .departure
                                ? .box
                                : .boxDestination,
                          );
                        } catch (e) {
                          controller.showError(
                            MessageException(
                              message: e.toString(),
                              type: .warning,
                            ),
                          );
                        }
                      },
                    );
                  } else {
                    return _itemScanField(
                      type,
                      move == .departure
                          ? controller.boxDeparture.value?.packLabel ?? ""
                          : controller.boxDestination.value?.packLabel ?? "",
                      ((move == .departure &&
                                  controller.scanMode.value == .box) ||
                              (move == .destination &&
                                  controller.scanMode.value ==
                                      .boxDestination)) &&
                          controller.isScanning.value,
                      () {
                        try {
                          controller.doScanAndGet(
                            scanMode: move == .departure
                                ? .box
                                : .boxDestination,
                          );
                        } catch (e) {
                          controller.showError(
                            MessageException(
                              message: e.toString(),
                              type: .warning,
                            ),
                          );
                        }
                      },
                      title:
                          ((controller.moveType.value == .box2Box &&
                                      controller.selectedMenu.id == 2)
                                  ? move == .departure
                                        ? localize.oldLocationBoxId
                                        : localize.newLocationBoxId
                                  : localize.box)
                              .toUpperCase(),
                    );
                  }
                case .rack:
                  if (controller.rack.value == null) {
                    return _scanField(
                      localize.rack.toUpperCase(),
                      controller.isScanning.value &&
                              controller.scanMode.value == .rack
                          ? localize.cancelRackId
                          : localize.scanRackId,
                      () {
                        try {
                          controller.doScanAndGet(scanMode: ScanMode.rack);
                        } catch (e) {
                          controller.showError(
                            MessageException(
                              message: e.toString(),
                              type: .warning,
                            ),
                          );
                        }
                      },
                    );
                  } else {
                    return _itemScanField(
                      type,
                      controller.rack.value?.rackLabel ?? "",
                      controller.scanMode.value == .rack &&
                          controller.isScanning.value,
                      () {
                        try {
                          controller.doScanAndGet(scanMode: ScanMode.rack);
                        } catch (e) {
                          controller.showError(
                            MessageException(
                              message: e.toString(),
                              type: .warning,
                            ),
                          );
                        }
                      },
                    );
                  }
                default:
                  if (controller.item.value == null) {
                    return _scanField(
                      localize.item.toUpperCase(),
                      localize.scanItemId,
                      () {
                        try {
                          controller.doScanAndGet(scanMode: ScanMode.item);
                        } catch (e) {
                          controller.showError(
                            MessageException(
                              message: e.toString(),
                              type: .warning,
                            ),
                          );
                        }
                      },
                    );
                  } else {
                    return _itemScanField(
                      type,
                      controller.item.value?.labelID ?? "",
                      controller.scanMode.value == .item &&
                          controller.isScanning.value,
                      () {
                        try {
                          controller.doScanAndGet(scanMode: ScanMode.item);
                        } catch (e) {
                          controller.showError(
                            MessageException(
                              message: e.toString(),
                              type: .warning,
                            ),
                          );
                        }
                      },
                    );
                  }
              }
            }),
            Obx(() {
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (type == ScanMode.box ||
                            type == ScanMode.boxDestination) ...[
                          infoField(
                            Icons.shopping_bag,
                            localize.boxName,
                            type == ScanMode.box
                                ? controller.boxDeparture.value?.packName ?? "-"
                                : controller.boxDestination.value?.packName ??
                                      "-",
                            secondaryTextStyle(size: 12),
                          ),
                          infoField(
                            Icons.type_specimen,
                            localize.type,
                            type == ScanMode.box
                                ? controller.boxDeparture.value?.packType ?? "-"
                                : controller.boxDestination.value?.packType ??
                                      "-",
                            secondaryTextStyle(size: 12),
                          ),
                          infoField(
                            Icons.location_on,
                            localize.location,
                            type == ScanMode.box
                                ? controller.boxDeparture.value?.rackLocation ??
                                      "-"
                                : controller
                                          .boxDestination
                                          .value
                                          ?.rackLocation ??
                                      "-",
                            secondaryTextStyle(size: 12),
                          ),
                        ] else if (type == ScanMode.rack) ...[
                          infoField(
                            Icons.storage,
                            localize.rackName,
                            controller.rack.value?.rackName ?? "-",
                            secondaryTextStyle(size: 12),
                          ),
                          infoField(
                            Icons.group_work,
                            localize.group,
                            controller.rack.value?.rackGroup ?? "-",
                            secondaryTextStyle(size: 12),
                          ),
                          infoField(
                            Icons.select_all,
                            localize.area,
                            controller.rack.value?.area ?? "-",
                            secondaryTextStyle(size: 12),
                          ),
                          infoField(
                            Icons.view_headline,
                            localize.cell,
                            controller.rack.value?.cell ?? "-",
                            secondaryTextStyle(size: 12),
                          ),
                          infoField(
                            Icons.format_list_numbered,
                            localize.cellNo,
                            controller.rack.value?.cellNo ?? "-",
                            secondaryTextStyle(size: 12),
                          ),
                        ] else
                          ...[],
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "${type == .rack
                                          ? controller.rack.value?.totalBox ?? "0"
                                          : type == ScanMode.box
                                          ? controller.boxDeparture.value?.totalItem ?? "0"
                                          : controller.boxDestination.value?.totalItem ?? "0"} ",
                                  style: primaryTextStyle(
                                    size: 24,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: type == .rack
                                      ? localize.boxes
                                      : localize.items,
                                  style: secondaryTextStyle(size: 12),
                                ),
                                TextSpan(
                                  text:
                                      " / ${type == .rack
                                          ? controller.rack.value?.limitItem ?? "0"
                                          : type == ScanMode.box
                                          ? controller.boxDeparture.value?.limitItem ?? "0"
                                          : controller.boxDestination.value?.limitItem ?? "0"} ",
                                  style: primaryTextStyle(
                                    size: 24,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: type == .rack
                                      ? localize.maxBoxes
                                      : localize.maxItems,
                                  style: secondaryTextStyle(size: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _movingSegment() {
    return ObxValue((option) {
      return SegmentedButton<MovingType>(
        showSelectedIcon: false,
        segments: MovingType.values.map((e) {
          switch (e) {
            case MovingType.box2Box:
              return ButtonSegment<MovingType>(
                value: e,
                label: moveSegment(
                  Icons.inventory_2,
                  localize.box,
                  Icons.inventory_2,
                  localize.box,
                ),
              );
            case MovingType.box2Rack:
              return ButtonSegment<MovingType>(
                value: e,
                label: moveSegment(
                  Icons.inventory_2,
                  localize.box,
                  Icons.view_headline,
                  localize.rack,
                ),
              );
            default:
              return ButtonSegment<MovingType>(
                value: e,
                label: moveSegment(
                  Icons.shopping_bag,
                  localize.item,
                  Icons.inventory_2,
                  localize.box,
                ),
              );
          }
        }).toList(),
        selected: {option.value},
        onSelectionChanged: (Set<MovingType> newSelection) {
          controller.confirmChange(() {
            controller.setMoveType(newSelection.first);
          });
        },
        style: ButtonStyle(
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.all(Radius.circular(8)),
            ),
          ),
        ),
      );
    }, controller.moveType);
  }

  List<Widget> _movingField(bool isHorizontal, MovingType type) {
    return [
      isHorizontal
          ? Expanded(
              child: _itemField(
                type: type == .item2Box ? .box : type.departure,
              ),
            )
          : _itemField(type: type == .item2Box ? .box : type.departure),
      (type != .item2Box)
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                // Helper.isTablet(Get.context!) ||
                // Helper.getDeviceOrientation(Get.context!) ==
                // Orientation.landscape
                isHorizontal ? Icons.arrow_forward : Icons.arrow_downward,
              ),
            )
          : SizedBox(height: 16, width: 16),
      isHorizontal
          ? Expanded(
              child: type == .item2Box
                  ? _buildScanButton()
                  : _itemField(
                      type: type.destination,
                      move: type.destination == .boxDestination
                          ? .destination
                          : .departure,
                    ),
            )
          : type == .item2Box
          ? _buildScanButton()
          : _itemField(
              type: type.destination,
              move: type.destination == .boxDestination
                  ? .destination
                  : .departure,
            ),
      type == .item2Box ? _buildItemList() : SizedBox.shrink(),
    ];
  }

  Widget _waitingScanner() {
    return SizedBox(
      height: 65,
      child: Stack(
        alignment: .center,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.orange,
            highlightColor: Colors.yellow,
            child: Container(
              // height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                localize.waitScan,
                style: primaryTextStyle(color: Colors.white, size: 20),
              ),
              if (controller.selectedMenu.id == 10 &&
                  controller.helper.state.value.isLoading) ...[
                SizedBox(width: 8),
                SizedBox(
                  height: 20,
                  width: 20,
                  child: controller.helper.state.value.isLoading
                      ? CircularProgressIndicator()
                      : SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
