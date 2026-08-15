import 'dart:async';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide FormData;
import 'package:json_annotation/json_annotation.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sprintf/sprintf.dart';
import 'package:tt_jig_ms/constant/app_constant.dart';
import 'package:tt_jig_ms/core/network/exception/api_exception.dart';
import 'package:tt_jig_ms/core/network/network_manager.dart';
import 'package:tt_jig_ms/data/local/department_provider.dart';
import 'package:tt_jig_ms/data/local/reason_provider.dart';
import 'package:tt_jig_ms/data/local/user_provider.dart';
import 'package:tt_jig_ms/data/model/api_response_model.dart';
import 'package:tt_jig_ms/data/model/box_model.dart';
import 'package:tt_jig_ms/data/model/department_model.dart';
import 'package:tt_jig_ms/data/model/employee_model.dart';
import 'package:tt_jig_ms/data/model/item_model.dart';
import 'package:tt_jig_ms/data/model/menu_model.dart';
import 'package:tt_jig_ms/data/model/rack_model.dart';
import 'package:tt_jig_ms/data/model/reason_model.dart';
import 'package:tt_jig_ms/data/model/transaction_model.dart';
import 'package:tt_jig_ms/helper/bluetooth_scanner_manager.dart';
import 'package:tt_jig_ms/helper/get_controller_ext.dart';
import 'package:tt_jig_ms/helper/helper.dart';
import 'package:tt_jig_ms/helper/sound_helper.dart';
import 'package:tt_jig_ms/modules/transaction_list/transaction_list_controller.dart';

@JsonEnum(valueField: 'value')
enum ScanMode {
  @JsonValue("SENDER")
  sender,
  @JsonValue("RECEIVER")
  receiver,
  @JsonValue("ITEM")
  item,
  @JsonValue("ITEM_IN_BOX")
  boxItem,
  @JsonValue("BOX")
  box,
  @JsonValue("BOX_DESTINATION")
  boxDestination,
  @JsonValue("RACK")
  rack;

  static List<ScanMode> get moves {
    return [item, box, rack];
  }

  static List<ScanMode> get outgoing {
    return [item, boxItem];
  }

  static List<ScanMode> get info {
    return [item, box, rack];
  }

  String? get message {
    switch (this) {
      case sender:
        return "Scanning Sender ID";
      case receiver:
        return "Scanning Receiver ID";
      case item:
        return "Scanning Item ID";
      case box || boxItem || boxDestination:
        return "Scanning Box ID";
      case rack:
        return "Scanning Rack ID";
    }
  }

  IconData? get icon {
    switch (this) {
      case item:
        return Icons.shopping_bag;
      case box || boxItem:
        return Icons.inventory_2;
      case rack:
        return Icons.view_headline;
      default:
        return null;
    }
  }

  String get name {
    switch (this) {
      case box || boxItem:
        return "BOX";
      case rack:
        return "RACK";
      case .boxDestination:
        return "BOX DESTINATION";
      default:
        return "ITEM";
    }
  }
}

enum ReturnType {
  returnBroken,
  returnReturn,
  returnFixed,
  destroy;

  String get name {
    switch (this) {
      case returnBroken:
        return "Broken";
      case returnFixed:
        return "Fixed";
      case destroy:
        return "Destroy";
      default:
        return "Return";
    }
  }

  factory ReturnType.withName(String name) {
    switch (name) {
      case "Broken":
        return returnBroken;
      case "Fixed":
        return returnFixed;
      default:
        return returnReturn;
    }
  }
}

enum MovingType {
  item2Box,
  box2Rack,
  box2Box;

  ScanMode get departure {
    switch (this) {
      case item2Box:
        return .item;
      case box2Rack || box2Box:
        return .box;
    }
  }

  ScanMode get destination {
    switch (this) {
      case item2Box:
        return .box;
      case box2Box:
        return .boxDestination;
      case box2Rack:
        return .rack;
    }
  }

  String get asName {
    switch (this) {
      case .item2Box:
        return "Item to Box";
      case .box2Box:
        return "Box to Box";
      case .box2Rack:
        return "Box to Rack";
    }
  }

  DestType get asDestType {
    switch (this) {
      case .item2Box:
        return .t01;
      case .box2Rack:
        return .t02;
      case .box2Box:
        return .t03;
    }
  }
}

enum DetailListType {
  items,
  box,
  history;

  static List<DetailListType> get rack => [.box, .history];
  static List<DetailListType> get nonRack => [.items, .history];
}

enum MoveType { departure, destination }

class CreateTransactionController extends GetxController {
  final networkManager = NetworkManager();
  final bluetoothManager = BluetoothScannerManager();
  final userProvider = UserProvider();
  final departmentProvider = DepartmentProvider();
  final reasonProvider = ReasonProvider();
  final scrollController = ScrollController();
  final returnDateField = TextEditingController();
  final helper = Helper();
  final transactionListController = Get.find<TransactionListController>();

  late final MenuModel selectedMenu;
  late Worker _blueWorker, dateWorker, stateWorker, _savingWorker;

  final RxList<DepartmentModel> departments = RxList.empty(growable: true);
  final RxList<ReasonModel> reasons = RxList.empty(growable: true);
  final Rxn<ScanMode> scanMode = Rxn(.sender); //ScanMode.sender.obs;
  final Rx<ScanMode> goodsType = ScanMode.item.obs;
  final Rx<ReturnType> returnType = ReturnType.returnReturn.obs;
  final Rx<MovingType> moveType = MovingType.item2Box.obs;
  final Rx<DetailListType> listType = DetailListType.history.obs;
  final Rxn<EmployeeModel> sender = Rxn();
  final Rxn<EmployeeModel> receiver = Rxn();
  final RxList<ItemModel> allItem = RxList.empty(growable: true);
  final RxList<BoxModel> allBox = RxList.empty(growable: true);
  final RxList<RackModel> allRack = RxList.empty(growable: true);
  final RxList<ItemHistoryModel> itemDetail = RxList.empty(growable: true);
  final Rxn<ItemModel> item = Rxn();
  final Rxn<BoxModel> boxDeparture = Rxn();
  final Rxn<BoxModel> boxDestination = Rxn();
  final Rxn<RackModel> rack = Rxn();
  final Rxn<DepartmentModel> selectedDepartment = Rxn();
  final Rxn<ReasonModel> selectedReason = Rxn();
  final RxString remark = "".obs;
  final RxString woNumber = "".obs;
  final Rxn<DateTime> selectedDate = Rxn();
  final RxBool submitButton = false.obs;
  final RxBool cancelButton = false.obs;
  final RxBool isScanning = false.obs;
  final Rx<ViewState> savingState = ViewState.idle().obs;

  // List<ItemHistoryModel> itemInside = List.empty(growable: true);
  // List<ItemHistoryModel> itemHistory = List.empty(growable: true);
  final RxList<ItemHistoryModel> itemInside = <ItemHistoryModel>[].obs;
  final RxList<ItemHistoryModel> itemHistory = <ItemHistoryModel>[].obs;

  bool isEdit = false;

  @override
  void onInit() {
    super.onInit();

    selectedMenu = Get.arguments;

    startWorker();
  }

  @override
  void onReady() {
    super.onReady();
    _getDepartments();
    _getReasons();
    _handleBluetoothListener();
    if (bluetoothManager.scannerPriority.value == .bluetooth) {
      doScanAndGet(scanMode: autoSelectField(), isEdit: isEdit);
    }
  }

  @override
  void dispose() {
    super.dispose();
    stopWorker();
    bluetoothManager.dispose();
    doResetForm();
    helper.state.value = .idle();
    scanMode.value = null;
  }

  @override
  void onClose() {
    stopWorker();
    bluetoothManager.dispose();
    super.onClose();
    doResetForm();
    helper.state.value = .idle();
    scanMode.value = null;
  }

  // MARK: API
  void _getDepartments() {
    try {
      departments.value = departmentProvider.departments ?? [];
    } catch (e) {
      // state.value = ViewState.error(
      //   MessageException(message: e.toString(), type: .error),
      // );
    }
  }

  void _getReasons() async {
    try {
      reasons.value = reasonProvider.reasons ?? [];
    } catch (e) {
      // state.value = ViewState.error(
      //   MessageException(message: e.toString(), type: .error),
      // );
    }
  }

  Future<EmployeeModel?> _getUserInfo(String employeeID) async {
    if (employeeID.isEmpty) {
      return null;
    }

    try {
      if (!helper.state.value.isLoading && !(Get.isDialogOpen ?? false)) {
        helper.state.value = ViewState.loading();
      }
      var result = await networkManager
          .post<ApiResponseModel<List<EmployeeModel>>>(
            '${Env.apiBaseUrl}/${APIRoute.userInfo}',
            body: FormData.fromMap({"EMPID": employeeID}),
            parser: (json) {
              return ApiResponseModel.fromJson(json, (employeeList) {
                List<EmployeeModel> results = [];
                if (employeeList is List) {
                  var data = employeeList
                      .whereType<Map<String, dynamic>>()
                      .toList();
                  results = data.map((e) {
                    return EmployeeModel.fromJson(e);
                  }).toList();
                }
                return results;
              });
            },
          );
      var data = result.data ?? [];
      if (data.isEmpty) {
        throw (localize.employeeNotFound);
      } else {
        helper.state.value = ViewState.success(data);
        await SoundHelper.success();
        return data.first;
      }
    } catch (e) {
      var message = "";
      if (e is DioException && e.error is ApiException) {
        message = (e.error as ApiException).message;
      } else if (e is String) {
        message = e.toString();
      } else {
        message = localize.somethingWrong;
      }
      helper.state.value = ViewState.error(
        MessageException(message: message, type: .error),
      );
      await SoundHelper.fail();
      return null;
    } finally {}
  }

  Future<ApiResponseModel<List<ItemModel>>> _getItems({
    required String labelID,
    bool withLoading = false,
  }) async {
    try {
      if (withLoading &&
          !helper.state.value.isLoading &&
          !(Get.isDialogOpen ?? false)) {
        helper.state.value = ViewState.loading();
      }
      var parameter = RequestItemModel(
        labelID: labelID,
        labelType: scanMode.value!,
      );
      FormData formData = FormData.fromMap(parameter.toJson());
      var result = await networkManager.post<ApiResponseModel<List<ItemModel>>>(
        '${Env.apiBaseUrl}/${APIRoute.itemInfo}',
        body: formData,
        parser: (json) {
          return ApiResponseModel.fromJson(json, (itemsJson) {
            List<ItemModel> results = [];
            if (itemsJson is List) {
              var data = itemsJson.whereType<Map<String, dynamic>>().toList();
              results = data.map((e) {
                return ItemModel.fromJson(e);
              }).toList();
            }
            return results;
          });
        },
      );
      if (withLoading) helper.state.value = ViewState.success(result);
      return result;
    } catch (e) {
      var message = "";
      if (e is DioException && e.error is ApiException) {
        message = (e.error as ApiException).message;
      } else if (e is String) {
        message = e.toString();
      } else {
        message = localize.somethingWrong;
      }
      await SoundHelper.fail();
      helper.state.value = ViewState.error(
        MessageException(message: message, type: .error),
      );
      return ApiResponseModel(
        success: false,
        message: message,
        count: 0,
        data: [],
      );
    }
  }

  Future<ApiResponseModel<List<ItemHistoryModel>>> _getItemInside({
    required String labelID,
    bool withLoading = false,
  }) async {
    try {
      if (withLoading &&
          !helper.state.value.isLoading &&
          !(Get.isDialogOpen ?? false)) {
        helper.state.value = ViewState.loading();
      }
      var parameter = RequestItemModel(
        labelID: labelID,
        labelType: scanMode.value!,
      );
      FormData formData = FormData.fromMap(parameter.toJson());
      var result = await networkManager
          .post<ApiResponseModel<List<ItemHistoryModel>>>(
            '${Env.apiBaseUrl}/${APIRoute.itemInsideInfo}',
            body: formData,
            parser: (json) {
              return ApiResponseModel.fromJson(json, (itemsJson) {
                List<ItemHistoryModel> results = [];
                if (itemsJson is List) {
                  var data = itemsJson
                      .whereType<Map<String, dynamic>>()
                      .toList();
                  results = data.map((e) {
                    return ItemHistoryModel.fromJson(e);
                  }).toList();
                }
                return results;
              });
            },
          );
      if (withLoading) helper.state.value = ViewState.success(result);
      return result;
    } catch (e) {
      var message = "";
      if (e is DioException && e.error is ApiException) {
        message = (e.error as ApiException).message;
      } else if (e is String) {
        message = e.toString();
      } else {
        message = localize.somethingWrong;
      }
      // state.value = ViewState.error(
      //   MessageException(message: message, type: .error),
      // );
      return ApiResponseModel(
        success: false,
        message: message,
        count: 0,
        data: [],
      );
    }
  }

  Future<ApiResponseModel<List<ItemHistoryModel>>> _getItemHistory({
    required String labelID,
    bool withLoading = false,
  }) async {
    try {
      if (withLoading &&
          !helper.state.value.isLoading &&
          !(Get.isDialogOpen ?? false)) {
        helper.state.value = ViewState.loading();
      }
      var parameter = RequestItemModel(
        labelID: labelID,
        labelType: scanMode.value!,
      );
      FormData formData = FormData.fromMap(parameter.toJson());
      var result = await networkManager
          .post<ApiResponseModel<List<ItemHistoryModel>>>(
            '${Env.apiBaseUrl}/${APIRoute.itemHistoryInfo}',
            body: formData,
            parser: (json) {
              return ApiResponseModel.fromJson(json, (itemsJson) {
                List<ItemHistoryModel> results = [];
                if (itemsJson is List) {
                  var data = itemsJson
                      .whereType<Map<String, dynamic>>()
                      .toList();
                  results = data.map((e) {
                    return ItemHistoryModel.fromJson(e);
                  }).toList();
                }
                return results;
              });
            },
          );
      if (withLoading) helper.state.value = ViewState.success(result);
      return result;
    } catch (e) {
      var message = "";
      if (e is DioException && e.error is ApiException) {
        message = (e.error as ApiException).message;
      } else if (e is String) {
        message = e.toString();
      } else {
        message = localize.somethingWrong;
      }
      // state.value = ViewState.error(
      //   MessageException(message: message, type: .error),
      // );
      return ApiResponseModel(
        success: false,
        message: message,
        count: 0,
        data: [],
      );
    }
  }

  Future<ApiResponseModel<List<BoxModel>>> _getBox({
    required String labelID,
    bool withLoading = false,
  }) async {
    try {
      if (withLoading &&
          !helper.state.value.isLoading &&
          !(Get.isDialogOpen ?? false)) {
        helper.state.value = ViewState.loading();
      }
      var parameter = RequestItemModel(
        labelID: labelID,
        labelType: scanMode.value! == .boxDestination ? .box : scanMode.value!,
      );
      FormData formData = FormData.fromMap(parameter.toJson());
      var result = await networkManager.post<ApiResponseModel<List<BoxModel>>>(
        '${Env.apiBaseUrl}/${APIRoute.itemInfo}',
        body: formData,
        parser: (json) {
          return ApiResponseModel.fromJson(json, (itemsJson) {
            List<BoxModel> results = [];
            if (itemsJson is List) {
              var data = itemsJson.whereType<Map<String, dynamic>>().toList();
              results = data.map((e) {
                return BoxModel.fromJson(e);
              }).toList();
            }
            return results;
          });
        },
      );
      if (withLoading) helper.state.value = ViewState.success(result);
      return result;
    } catch (e) {
      var message = "";
      if (e is DioException && e.error is ApiException) {
        message = (e.error as ApiException).message;
      } else if (e is String) {
        message = e.toString();
      } else {
        message = localize.somethingWrong;
      }
      helper.state.value = ViewState.error(
        MessageException(message: message, type: .error),
      );
      await SoundHelper.fail();
      return ApiResponseModel(
        success: false,
        message: message,
        count: 0,
        data: [],
      );
    }
  }

  Future<ApiResponseModel<List<RackModel>>> _getRack({
    required String labelID,
    bool withLoading = false,
  }) async {
    try {
      if (withLoading &&
          !helper.state.value.isLoading &&
          !(Get.isDialogOpen ?? false)) {
        helper.state.value = ViewState.loading();
      }
      var parameter = RequestItemModel(
        labelID: labelID,
        labelType: scanMode.value!,
      );
      FormData formData = FormData.fromMap(parameter.toJson());
      var result = await networkManager.post<ApiResponseModel<List<RackModel>>>(
        '${Env.apiBaseUrl}/${APIRoute.itemInfo}',
        body: formData,
        parser: (json) {
          return ApiResponseModel.fromJson(json, (itemsJson) {
            List<RackModel> results = [];
            if (itemsJson is List) {
              var data = itemsJson.whereType<Map<String, dynamic>>().toList();
              results = data.map((e) {
                return RackModel.fromJson(e);
              }).toList();
            }
            return results;
          });
        },
      );
      if (withLoading) helper.state.value = ViewState.success(result);
      return result;
    } catch (e) {
      var message = "";
      if (e is DioException && e.error is ApiException) {
        message = (e.error as ApiException).message;
      } else if (e is String) {
        message = e.toString();
      } else {
        message = localize.somethingWrong;
      }
      helper.state.value = ViewState.error(
        MessageException(message: message, type: .error),
      );
      await SoundHelper.fail();
      return ApiResponseModel(
        success: false,
        message: message,
        count: 0,
        data: [],
      );
    }
  }

  Future<ApiResponseModel> _createTransaction(
    CreateTransactionRequestModel request,
    String path,
  ) async {
    try {
      // if (!helper.state.value.isLoading && !(Get.isDialogOpen ?? false)) {
      //   helper.state.value = ViewState.loading();
      // }
      var result = await networkManager.post<ApiResponseModel>(
        '${Env.apiBaseUrl}/$path',
        body: FormData.fromMap(request.toJson()),
        parser: (json) {
          return ApiResponseModel.fromJson(json, (json) {});
        },
      );
      if (result.success) {
        // helper.state.value = ViewState.success(result);
        return result;
      }
      throw (result.message ?? localize.somethingWrong);
    } catch (e) {
      var message = "";
      if (e is DioException && e.error is ApiException) {
        message = (e.error as ApiException).message;
      } else if (e is String) {
        message = e.toString();
      } else {
        message = localize.somethingWrong;
      }
      return ApiResponseModel(
        success: false,
        message: message,
        count: 0,
        data: null,
      );
    }
  }

  // MARK: Setter
  void setScanType(ScanMode type) {
    helper.state.value = ViewState.idle();
    if (selectedMenu.id == 10 && scanMode.value != type) {
      item.value = null;
      boxDeparture.value = null;
      rack.value = null;
      itemHistory.value = [];
      itemInside.value = [];
      itemDetail.value = [];
    }
    scanMode.value = type;
    if ((selectedMenu.id == 10 && ScanMode.info.contains(type)) ||
        (selectedMenu.id == 1 && ScanMode.outgoing.contains(type)) &&
            scanMode.value != goodsType.value) {
      goodsType.value = type;
      // allItem.value = [];
      listType.value = type == .item
          ? .history
          : type == .rack
          ? .box
          : .items;
      isScanning.value = false;
      if (bluetoothManager.scannerPriority.value == .bluetooth) {
        doScanAndGet(scanMode: autoSelectField(), isEdit: isEdit);
      }
    }
  }

  void setMoveType(MovingType type) {
    helper.state.value = ViewState.idle();
    moveType.value = type;
    item.value = null;
    boxDeparture.value = null;
    boxDestination.value = null;
    rack.value = null;
    isScanning.value = false;
    allItem.clear();
    activateSubmitButton();
    activateCancelButton();
    if (bluetoothManager.scannerPriority.value == .bluetooth) {
      doScanAndGet(scanMode: autoSelectField(), isEdit: isEdit);
    } else {
      scanMode.value = null;
    }
  }

  void setDetailListType(DetailListType type) {
    listType.value = type;

    itemDetail.value = type == .history ? itemHistory : itemInside;
  }

  void setReturnDate(DateTime date) {
    selectedDate.value = date;
  }

  void setReason(ReasonModel reason) {
    selectedReason.value = reason;
  }

  void doScanAndGet({ScanMode? scanMode, bool isEdit = false}) async {
    if (isScanning.value &&
        (scanMode == this.scanMode.value ||
            ([
                  ScanMode.item,
                  ScanMode.box,
                  ScanMode.boxItem,
                  ScanMode.boxDestination,
                  ScanMode.rack,
                ].contains(this.scanMode.value) &&
                scanMode == null)) &&
        bluetoothManager.scannerPriority.value == .bluetooth) {
      isScanning.value = false;
      if (isEdit) {
        doScanAndGet(scanMode: autoSelectField(), isEdit: !isEdit);
      }
      return;
    }

    if (scanMode != null) {
      setScanType(scanMode);
    } else {
      setScanType(goodsType.value);
    }

    if (bluetoothManager.scannerPriority.value == .camera) {
      FocusManager.instance.primaryFocus?.unfocus();
      var result = await goToCameraScanner();
      switch (result.type) {
        case .Barcode:
          _doGet(result.rawContent);
          break;
        case .Error:
          helper.state.value = ViewState.error(
            MessageException(message: result.rawContent, type: .error),
          );
        default:
          return;
      }
    } else {
      this.isEdit = isEdit;
      isScanning.value = true;
      // state.value = ViewState.loading();
    }
  }

  void confirmChange(VoidCallback confirm) {
    showDefaultDialog(
      title: localize.confirmation,
      message: localize.clearList,
      confirm: confirm,
    );
  }

  // MARK: Action
  void _doGet(String id) async {
    FocusManager.instance.primaryFocus?.unfocus();
    var sample = id;
    switch (scanMode.value) {
      case .sender || .receiver:
        // sample = scanMode.value == .sender ? "TT26010026" : "TT20121052";
        if ((sender.value != null && sender.value?.employeeID == sample) ||
            (receiver.value != null && receiver.value?.employeeID == sample)) {
          helper.state.value = ViewState.error(
            MessageException(message: localize.sameID, type: .warning),
          );
        } else {
          var employee = await _getUserInfo(sample);
          if (employee == null) return;
          if (scanMode.value == .sender) {
            sender.value = employee;
          } else if (scanMode.value == .receiver) {
            receiver.value = employee;
          }
          if (bluetoothManager.scannerPriority.value == .bluetooth) {
            doScanAndGet(scanMode: autoSelectField(), isEdit: isEdit);
          }
        }
        break;
      case .item:
        if (allItem.where((item) => item.labelID == sample).isEmpty) {
          if (selectedMenu.id == 10) helper.state.value = ViewState.loading();
          if (selectedMenu.id == 2 && moveType.value == .item2Box) {
            var existing =
                boxDeparture.value?.totalItem.toInt(defaultValue: 0) ?? 0;
            var limit =
                boxDeparture.value?.limitItem.toInt(defaultValue: 0) ?? 0;
            if (existing + allItem.length >= limit) {
              await SoundHelper.fail();
              helper.state.value = ViewState.error(
                MessageException(message: localize.boxFull, type: .warning),
              );
              return;
            }
          }
          var result = await _getItems(
            labelID: sample,
            withLoading: selectedMenu.id != 10,
          );
          if (result.data == null || result.data!.isEmpty) {
            await SoundHelper.fail();
            helper.state.value = ViewState.error(
              MessageException(
                message: localize.labelItemNotFound,
                type: .warning,
              ),
            );
            return;
          } else if (!result.success) {
            await SoundHelper.fail();
            helper.state.value = ViewState.error(
              MessageException(message: result.message ?? "", type: .warning),
            );
            return;
          }

          var temp = result.data?.first;
          if (allItem.where((i) => i.labelID == sample).isNotEmpty) {
            await SoundHelper.fail();
            helper.state.value = ViewState.error(
              MessageException(
                message:
                    "${selectedMenu.id == 10 ? localize.barcodeAlreadyScan : localize.barcodeAlreadyIn} [$sample]",
                type: .warning,
              ),
            );
            return;
          } else if (temp?.status != "G") {
            await SoundHelper.fail();
            helper.state.value = ViewState.error(
              MessageException(message: localize.itemNotGood, type: .warning),
            );
            return;
          }
          switch (selectedMenu.id) {
            case 1 || 2:
              if (temp?.packLocation == "O") {
                await SoundHelper.fail();
                helper.state.value = ViewState.error(
                  MessageException(
                    message: localize.itemOutgoing,
                    type: .warning,
                  ),
                );
                return;
              }
              break;
            case 9:
              if (returnType.value.name.toUpperCase() != "FIXED" &&
                  temp?.packLocation != "O") {
                await SoundHelper.fail();
                helper.state.value = ViewState.error(
                  MessageException(
                    message: localize.itemInhouse,
                    type: .warning,
                  ),
                );
                return;
              } else if (returnType.value.name.toUpperCase() == "FIXED" &&
                  temp?.status == "G") {
                await SoundHelper.fail();
                helper.state.value = ViewState.error(
                  MessageException(message: localize.itemGood, type: .warning),
                );
                return;
              }
              break;
            case 10:
              var historyResult = await _getItemHistory(
                labelID: sample,
                withLoading: false,
              );
              itemHistory.assignAll(
                List<ItemHistoryModel>.from(historyResult.data ?? []),
              );
              itemDetail.assignAll(itemHistory);
              itemDetail.assignAll(List<ItemHistoryModel>.from(itemHistory));
              isScanning.value = false;
              if (bluetoothManager.scannerPriority.value == .bluetooth) {
                doScanAndGet(scanMode: autoSelectField(), isEdit: isEdit);
              }
              break;
            case 11:
              if (temp?.packLocation == "D") {
                await SoundHelper.fail();
                helper.state.value = ViewState.error(
                  MessageException(
                    message: localize.itemDestroy,
                    type: .warning,
                  ),
                );
                return;
              }
              break;
            default:
              break;
          }
          item.value = temp;
          allItem.add(temp!);
          await SoundHelper.success();
          helper.state.value = ViewState.success(null);
        } else {
          await SoundHelper.fail();
          helper.state.value = ViewState.error(
            MessageException(
              message:
                  "${selectedMenu.id == 10 ? localize.barcodeAlreadyScan : localize.barcodeAlreadyIn} [$sample]",
              type: .warning,
            ),
          );
          return;
        }
      case .boxItem:
        if (!allItem.map((element) => element.packLabel).contains(sample)) {
          if (selectedMenu.id == 10) helper.state.value = ViewState.loading();
          var result = await _getItems(
            labelID: sample,
            withLoading: selectedMenu.id != 10,
          );

          // if (selectedMenu.id == 10) {
          //   var historyResult = await _getItemHistory(
          //     labelID: sample,
          //     withLoading: false,
          //   );
          //   itemHistory.addAll(historyResult.data ?? []);
          //   isScanning.value = false;
          // }
          if (result.data == null || result.data!.isEmpty) {
            await SoundHelper.fail();
            helper.state.value = ViewState.error(
              MessageException(
                message: localize.labelItemNotFound,
                type: .warning,
              ),
            );
            return;
          } else if (!result.success) {
            await SoundHelper.fail();
            helper.state.value = ViewState.error(
              MessageException(message: result.message ?? "", type: .warning),
            );
            return;
          }
          allItem.addAll(result.data ?? []);
          await SoundHelper.success();
          helper.state.value = ViewState.success(null);
        } else {
          await SoundHelper.fail();
          helper.state.value = ViewState.error(
            MessageException(
              message: "${localize.barcodeAlreadyIn} [$sample]",
              type: .warning,
            ),
          );
          return;
        }
        break;
      case .box || .boxDestination:
        if (selectedMenu.id == 10) helper.state.value = ViewState.loading();
        if ([2, 10].contains(selectedMenu.id) &&
            ((boxDeparture.value != null &&
                    boxDeparture.value?.packLabel == sample) ||
                (boxDestination.value != null &&
                    boxDestination.value?.packLabel == sample))) {
          await SoundHelper.fail();
          helper.state.value = ViewState.error(
            MessageException(
              message:
                  "${selectedMenu.id == 10 ? localize.barcodeAlreadyScan : localize.barcodeAlreadyIn} [$sample]",
              type: .warning,
            ),
          );
          return;
        }
        var result = await _getBox(
          labelID: sample,
          withLoading: selectedMenu.id != 10,
        );

        if (result.data == null || result.data!.isEmpty) {
          await SoundHelper.fail();
          helper.state.value = ViewState.error(
            MessageException(
              message: localize.labelBoxNotFound,
              type: .warning,
            ),
          );
          return;
        } else if (!result.success) {
          await SoundHelper.fail();
          helper.state.value = ViewState.error(
            MessageException(message: result.message ?? "", type: .warning),
          );
          return;
        } else if (selectedMenu.id == 2 && moveType.value == .item2Box) {
          var box = result.data?.first;
          var existing = box?.totalItem.toInt(defaultValue: 0) ?? 0;
          var limit = box?.limitItem.toInt(defaultValue: 0) ?? 0;
          if (existing + allItem.length > limit) {
            await SoundHelper.fail();
            helper.state.value = ViewState.error(
              MessageException(message: localize.boxFull, type: .warning),
            );
            return;
          }
        }

        BoxModel? departure = boxDeparture.value;
        BoxModel? destination = boxDestination.value;
        if (scanMode.value == .box) {
          departure = result.data!.first;
        } else {
          destination = result.data!.first;
        }

        if (selectedMenu.id == 2) {
          if (moveType.value == .box2Box &&
              departure != null &&
              destination != null) {
            if (((departure.totalItem.toInt()) +
                    (destination.totalItem.toInt())) >
                (destination.limitItem.toInt())) {
              await SoundHelper.fail();
              helper.state.value = ViewState.error(
                MessageException(message: localize.boxOverload, type: .warning),
              );
              return;
            }
          }
          boxDeparture.value = departure;
          boxDestination.value = destination;
          if (boxDeparture.value != null && boxDestination.value != null) {
            scanMode.value = null;
            isScanning.value = false;
          } else {
            if (bluetoothManager.scannerPriority.value == .bluetooth) {
              doScanAndGet(scanMode: autoSelectField(), isEdit: isEdit);
            }
          }
        } else if (selectedMenu.id == 10) {
          final results = await Future.wait([
            _getItemInside(labelID: sample),
            _getItemHistory(labelID: sample),
          ]);

          final insideData = results[0].data ?? [];
          final historyData = results[1].data ?? [];

          itemInside.assignAll(List<ItemHistoryModel>.from(insideData));
          itemHistory.assignAll(List<ItemHistoryModel>.from(historyData));

          itemDetail.assignAll(
            List<ItemHistoryModel>.from(
              listType.value == .history ? itemHistory : itemInside,
            ),
          );
          boxDeparture.value = departure;
          await SoundHelper.success();
          helper.state.value = ViewState.success(null);
          return;
        }
        // allBox.addAll(result.data ?? []);
        await SoundHelper.success();
        helper.state.value = ViewState.success(null);
        break;
      case .rack:
        if (selectedMenu.id == 10) helper.state.value = ViewState.loading();
        if (rack.value?.rackLabel == sample) {
          await SoundHelper.fail();
          helper.state.value = ViewState.error(
            MessageException(
              message:
                  "${selectedMenu.id == 10 ? localize.barcodeAlreadyScan : localize.barcodeAlreadyIn} [$sample]",
              type: .warning,
            ),
          );
          return;
        }
        var result = await _getRack(
          labelID: sample,
          withLoading: selectedMenu.id != 10,
        );
        if (result.data == null || result.data!.isEmpty) {
          await SoundHelper.fail();
          helper.state.value = ViewState.error(
            MessageException(
              message: localize.labelRackNotFound,
              type: .warning,
            ),
          );
          return;
        } else if (!result.success) {
          await SoundHelper.fail();
          helper.state.value = ViewState.error(
            MessageException(message: result.message ?? "", type: .warning),
          );
          return;
        }
        if (moveType.value == .box2Rack) {
          if (result.data?.first.limitItem.toInt() ==
              result.data?.first.totalBox.toInt()) {
            await SoundHelper.fail();
            helper.state.value = ViewState.error(
              MessageException(message: localize.rackFull, type: .warning),
            );
            return;
          } else {
            if (bluetoothManager.scannerPriority.value == .bluetooth) {
              if (boxDeparture.value == null || rack.value == null) {
                if (bluetoothManager.scannerPriority.value == .bluetooth) {
                  doScanAndGet(scanMode: autoSelectField(), isEdit: isEdit);
                }
              } else {
                scanMode.value = .sender;
                isScanning.value = false;
              }
            }
          }
        }
        rack.value = result.data?.first;
        if (selectedMenu.id == 10) {
          final results = await Future.wait([
            _getItemInside(labelID: sample),
            _getItemHistory(labelID: sample),
          ]);

          final insideData = results[0].data ?? [];
          final historyData = results[1].data ?? [];

          itemInside.assignAll(List<ItemHistoryModel>.from(insideData));
          itemHistory.assignAll(List<ItemHistoryModel>.from(historyData));

          itemDetail.assignAll(
            List<ItemHistoryModel>.from(
              listType.value == .history ? itemHistory : itemInside,
            ),
          );
        }

        await SoundHelper.success();
        helper.state.value = ViewState.success(null);
        break;
      default:
        // switch (scanMode.value) {
        //   case .item:
        //     sample = "L250509-0023";
        //   case .box || .boxItem: // || .boxDestination:
        //     sample = "L-B0001";
        //   case .boxDestination:
        //     sample = "L-B0011";
        //   case .rack:
        //     sample = "JUP-01-A-001";
        //   default:
        // }

        if (ScanMode.outgoing.contains(scanMode.value)) {
          if ((scanMode.value == .item &&
                  allItem.where((item) => item.labelID == sample).isEmpty) ||
              (scanMode.value == .boxItem &&
                  !allItem
                      .map((element) => element.packLabel)
                      .contains(sample))) {
            List<ItemModel> items = List.empty(growable: true);
            if (selectedMenu.id == 10) helper.state.value = ViewState.loading();
            var result = await _getItems(
              labelID: sample,
              withLoading: selectedMenu.id != 10,
            );

            if (result.data == null || result.data!.isEmpty) {
              await SoundHelper.fail();
              helper.state.value = ViewState.error(
                MessageException(
                  message: localize.labelItemNotFound,
                  type: .warning,
                ),
              );
              return;
            } else if (!result.success) {
              await SoundHelper.fail();
              helper.state.value = ViewState.error(
                MessageException(message: result.message ?? "", type: .warning),
              );
              return;
            } else {
              items = result.data ?? [];
            }

            if (selectedMenu.id == 10) {
              var historyResult = await _getItemHistory(
                labelID: sample,
                withLoading: false,
              );
              itemHistory.assignAll(
                List<ItemHistoryModel>.from(historyResult.data ?? []),
              );
              isScanning.value = false;
            }
            if (selectedMenu.id == 10) {
              helper.state.value = ViewState.success(null);
            }

            if (scanMode.value == .item) {
              var item = items.first;
              if ([1, 2].contains(selectedMenu.id) &&
                  item.packLocation == "O") {
                await SoundHelper.fail();
                helper.state.value = ViewState.error(
                  MessageException(
                    message: localize.itemOutgoing,
                    type: .warning,
                  ),
                );
                return;
              } else if (selectedMenu.id == 9 &&
                  returnType.value.name.toUpperCase() != "FIXED" &&
                  item.packLocation != "O") {
                await SoundHelper.fail();
                helper.state.value = ViewState.error(
                  MessageException(
                    message: localize.itemInhouse,
                    type: .warning,
                  ),
                );
                return;
              } else if (selectedMenu.id == 9 &&
                  returnType.value.name.toUpperCase() == "FIXED" &&
                  item.status == "G") {
                await SoundHelper.fail();
                helper.state.value = ViewState.error(
                  MessageException(message: localize.itemGood, type: .warning),
                );
                return;
              } else if (selectedMenu.id == 11 && item.packLocation == "D") {
                await SoundHelper.fail();
                helper.state.value = ViewState.error(
                  MessageException(
                    message: localize.itemDestroy,
                    type: .warning,
                  ),
                );
                return;
              } else if (item.status != "G") {
                await SoundHelper.fail();
                helper.state.value = ViewState.error(
                  MessageException(
                    message: localize.itemNotGood,
                    type: .warning,
                  ),
                );
                return;
              } else {
                if ([1, 2, 9, 11].contains(selectedMenu.id)) {
                  allItem.add(item);
                } else {
                  itemDetail.value = itemHistory;
                  this.item.value = item;
                }
              }
            } else if (scanMode.value == .boxItem) {
              allItem.addAll(items);
            }
            await SoundHelper.success();
            helper.state.value = ViewState.success(null);
          } else {
            await SoundHelper.fail();
            helper.state.value = ViewState.error(
              MessageException(
                message: "${localize.barcodeAlreadyIn} [$sample]",
                type: .warning,
              ),
            );
            return;
          }
        } else if (scanMode.value == .box ||
            scanMode.value == .boxDestination) {
          if (selectedMenu.id == 10) helper.state.value = ViewState.loading();
          if (selectedMenu.id == 2 &&
              ((boxDeparture.value != null &&
                      boxDeparture.value?.packLabel == sample) ||
                  (boxDestination.value != null &&
                      boxDestination.value?.packLabel == sample))) {
            await SoundHelper.fail();
            helper.state.value = ViewState.error(
              MessageException(
                message: "${localize.barcodeAlreadyIn} [$sample]",
                type: .warning,
              ),
            );
            return;
          }
          var result = await _getBox(
            labelID: sample,
            withLoading: selectedMenu.id != 10,
          );
          if (selectedMenu.id == 10) {
            final results = await Future.wait([
              _getItemInside(labelID: sample),
              _getItemHistory(labelID: sample),
            ]);

            final insideData = results[0].data ?? [];
            final historyData = results[1].data ?? [];

            itemInside.assignAll(List<ItemHistoryModel>.from(insideData));
            itemHistory.assignAll(List<ItemHistoryModel>.from(historyData));

            isScanning.value = false;
          }
          if (selectedMenu.id == 10) {
            helper.state.value = ViewState.success(null);
          }
          if (result.data == null || result.data!.isEmpty) {
            await SoundHelper.fail();
            helper.state.value = ViewState.error(
              MessageException(
                message: localize.labelBoxNotFound,
                type: .warning,
              ),
            );
            return;
          } else if (!result.success) {
            await SoundHelper.fail();
            helper.state.value = ViewState.error(
              MessageException(message: result.message ?? "", type: .warning),
            );
            return;
          } else {
            if (selectedMenu.id != 1) {
              BoxModel? departure = boxDeparture.value;
              BoxModel? destination = boxDestination.value;
              if (scanMode.value == .box) {
                departure = result.data!.first;
              } else {
                destination = result.data!.first;
              }
              if (selectedMenu.id == 2) {
                if (moveType.value == .box2Box &&
                    departure != null &&
                    destination != null) {
                  if (((departure.totalItem.toInt()) +
                          (destination.totalItem.toInt())) >
                      (destination.limitItem.toInt())) {
                    await SoundHelper.fail();
                    helper.state.value = ViewState.error(
                      MessageException(
                        message: localize.boxOverload,
                        type: .warning,
                      ),
                    );
                    return;
                  } else {
                    scanMode.value = .sender;
                    isScanning.value = false;
                  }
                }
                boxDeparture.value = departure;
                boxDestination.value = destination;
                if (bluetoothManager.scannerPriority.value == .bluetooth) {
                  doScanAndGet(scanMode: autoSelectField(), isEdit: isEdit);
                }
              }
              if (selectedMenu.id == 10) {
                itemDetail.value = listType.value == .history
                    ? itemHistory
                    : itemInside;
              }
            }
            allBox.addAll(result.data ?? []);
            await SoundHelper.success();
            helper.state.value = ViewState.success(null);
          }
        } else if (scanMode.value == .rack) {
          if (selectedMenu.id == 10) helper.state.value = ViewState.loading();
          if (rack.value?.rackLabel == sample) {
            await SoundHelper.fail();
            helper.state.value = ViewState.error(
              MessageException(
                message: "${localize.barcodeAlreadyIn} [$sample]",
                type: .warning,
              ),
            );
            return;
          }
          var result = await _getRack(
            labelID: sample,
            withLoading: selectedMenu.id != 10,
          );
          if (selectedMenu.id == 10) {
            final results = await Future.wait([
              _getItemInside(labelID: sample),
              _getItemHistory(labelID: sample),
            ]);

            final insideData = results[0].data ?? [];
            final historyData = results[1].data ?? [];

            itemInside.assignAll(List<ItemHistoryModel>.from(insideData));
            itemHistory.assignAll(List<ItemHistoryModel>.from(historyData));

            isScanning.value = false;
          }
          if (selectedMenu.id == 10) {
            helper.state.value = ViewState.success(null);
          }
          // var rack = result.data?.first;
          if (result.data == null || result.data!.isEmpty) {
            await SoundHelper.fail();
            helper.state.value = ViewState.error(
              MessageException(
                message: localize.labelRackNotFound,
                type: .warning,
              ),
            );
            return;
          } else if (selectedMenu.id == 2 &&
              (result.data?.first.limitItem == result.data?.first.totalBox)) {
            await SoundHelper.fail();
            helper.state.value = ViewState.error(
              MessageException(message: localize.rackFull, type: .warning),
            );
            return;
          } else if (!result.success) {
            await SoundHelper.fail();
            helper.state.value = ViewState.error(
              MessageException(message: result.message ?? "", type: .warning),
            );
            return;
          } else {
            allRack.addAll(result.data ?? []);
            if (selectedMenu.id != 1) {
              rack.value = allRack.first;
            }
            if (selectedMenu.id == 10) {
              itemDetail.value = listType.value == .history
                  ? itemHistory
                  : itemInside;
            }
            if (selectedMenu.id == 2 &&
                bluetoothManager.scannerPriority.value == .bluetooth) {
              if (boxDeparture.value == null || rack.value == null) {
                if (bluetoothManager.scannerPriority.value == .bluetooth) {
                  doScanAndGet(scanMode: autoSelectField(), isEdit: isEdit);
                }
              } else {
                scanMode.value = .sender;
                isScanning.value = false;
              }
            }
            await SoundHelper.success();
            helper.state.value = ViewState.success(null);
          }
        }
    }
    activateSubmitButton();
    activateCancelButton();
  }

  void doRemoveItem({required ItemModel item}) {
    allItem.removeWhere((element) => element.labelID == item.labelID);
    activateSubmitButton();
    activateCancelButton();
  }

  void doClearList() {
    helper.state.value = ViewState.idle();
    stopWorker();
    allItem.clear();
    activateSubmitButton();
    activateCancelButton();
    startWorker();
    helper.state.value = .idle();
  }

  void doResetForm() {
    helper.state.value = ViewState.idle();
    stopWorker();
    allItem.clear();
    allBox.clear();
    allRack.clear();
    sender.value = null;
    receiver.value = null;
    item.value = null;
    boxDeparture.value = null;
    boxDestination.value = null;
    selectedDepartment.value = null;
    selectedReason.value = null;
    goodsType.value = ScanMode.item;
    returnType.value = ReturnType.returnReturn;
    rack.value = null;
    remark.value = "";
    woNumber.value = "";
    selectedDate.value = null;
    itemDetail.clear();
    itemHistory.clear();
    itemInside.clear();
    submitButton.value = false;
    isScanning.value = false;
    isEdit = false;
    if (bluetoothManager.scannerPriority.value == .bluetooth) {
      doScanAndGet(scanMode: autoSelectField(), isEdit: isEdit);
    }
    startWorker();
    activateSubmitButton();
    activateCancelButton();
  }

  void doCreateTransaction() async {
    var path = "";
    var request = CreateTransactionRequestModel();
    switch (selectedMenu.id) {
      case 1:
        request = CreateTransactionRequestModel(
          department:
              "${selectedDepartment.value?.name ?? ""} [${remark.value}]",
          receiverID: receiver.value?.employeeID ?? "",
          senderID: sender.value?.employeeID ?? "",
          transactionDate: DateTime.now().reformatTo("OyyyyMMddHHmmss"),
          workingNumber: woNumber.value.isEmpty ? "-" : woNumber.value,
          transactionDetail: allItem
              .map((element) => element.labelID)
              .join(","),
          userID: userProvider.currentUser?.employeeID ?? "",
        );
        path = APIRoute.outTransaction;
        break;
      case 2:
        String from = "";
        String to = "";
        switch (moveType.value) {
          case .box2Box:
            path = APIRoute.moveBoxTransaction;
            from = boxDeparture.value?.packLabel ?? "";
            to = boxDestination.value?.packLabel ?? "";
            break;
          case .box2Rack:
            path = APIRoute.moveBoxRackTransaction;
            from = boxDeparture.value?.packLabel ?? "";
            to = rack.value?.rackLabel ?? "";
            break;
          default:
            path = APIRoute.moveItemBoxTransaction;
            from = boxDeparture.value?.packLabel ?? "";
            to = allItem.map((element) => element.labelID).join(",");
            break;
        }
        request = CreateTransactionRequestModel(
          labelID: from,
          transactionDetail: to,
          userID: userProvider.currentUser?.employeeID ?? "",
        );
        break;
      case 9 || 11:
        request = CreateTransactionRequestModel(
          department: selectedMenu.id == 11
              ? ""
              : "${selectedDepartment.value?.name ?? ""} [${remark.value}]",
          receiverID: receiver.value?.employeeID ?? "",
          senderID: sender.value?.employeeID ?? "",
          transactionDate: DateTime.now().reformatTo("OyyyyMMddHHmmss"),
          userID: userProvider.currentUser?.employeeID ?? "",
          reason: selectedReason.value?.code.toUpperCase(),
          returnType: selectedMenu.id == 11
              ? ReturnType.destroy.name.toUpperCase()
              : returnType.value.name.toUpperCase(),
          brokenDate: (selectedDate.value ?? DateTime.now()).reformatTo(
            "yyyy-MM-dd",
          ),
        );
        path = (selectedMenu.id == 9)
            ? APIRoute.returnTransaction
            : APIRoute.destroyTransaction;
        break;
      default:
    }

    try {
      savingState.value = ViewState.loading();
      var response = await _createTransaction(request, path);
      if (response.success) {
        // helper.state.value = ViewState.success(
        //   MessageException(message: localize.allItemSaved, type: .success),
        // );
        // await transactionListController.getTransactions();
        Future.sync(() => transactionListController.pagingController.refresh());
        savingState.value = ViewState.error(
          MessageException(message: localize.allItemSaved, type: .success),
        );
        await Future.delayed(const Duration(milliseconds: 2000));
        // update(['transaction_list']);
        Get.back();
      }
    } catch (e) {
      savingState.value = ViewState.error(
        MessageException(message: e.toString(), type: .error),
      );
    } finally {
      savingState.value = .idle();
      hideLoading();
    }
  }

  void activateSubmitButton() {
    switch (selectedMenu.id) {
      case 1 || 9:
        submitButton.value =
            sender.value != null &&
            receiver.value != null &&
            selectedDepartment.value != null &&
            allItem.isNotEmpty;
      case 2:
        switch (moveType.value) {
          case .item2Box:
            submitButton.value =
                allItem.isNotEmpty && boxDeparture.value != null;
          case .box2Rack:
            submitButton.value =
                boxDeparture.value != null && rack.value != null;
          case .box2Box:
            submitButton.value =
                boxDeparture.value != null && boxDestination.value != null;
        }
      case 11:
        submitButton.value =
            sender.value != null &&
            receiver.value != null &&
            allItem.isNotEmpty;
      default:
        submitButton.value = false;
    }
  }

  void activateCancelButton() {
    cancelButton.value =
        sender.value != null ||
        receiver.value != null ||
        selectedDepartment.value != null ||
        allItem.isNotEmpty ||
        allItem.isNotEmpty ||
        boxDeparture.value != null ||
        rack.value != null ||
        boxDestination.value != null;
  }

  void confirmRemoveItem({required ItemModel item, VoidCallback? confirm}) {
    showDefaultDialog(
      title: localize.remove,
      message: sprintf(localize.confirmRemove, [item.labelID]),
      confirm: confirm,
    );
  }

  void clearItems(VoidCallback? confirm) {
    showDefaultDialog(
      title: localize.remove,
      message: localize.clearList,
      confirm: confirm,
    );
  }

  void resetForm(VoidCallback confirm) {
    showDefaultDialog(
      title: localize.reset,
      message: localize.cancelSubmit,
      confirm: confirm,
    );
  }

  void confirmSubmitTransaction({VoidCallback? confirm}) {
    showDefaultDialog(
      title: localize.submit,
      message: localize.confirmSubmit,
      confirm: confirm,
    );
  }

  VoidCallback? get submitButtonAction {
    if (submitButton.value) {
      return () {
        confirmSubmitTransaction(
          confirm: () {
            doCreateTransaction();
          },
        );
      };
    } else {
      return null;
    }
  }

  ScanMode? autoSelectField() {
    if (bluetoothManager.scannerPriority.value == .camera) {
      return scanMode.value;
    }
    ScanMode? mode;

    switch (selectedMenu.id) {
      case 1 || 9 || 11:
        if (sender.value == null) {
          mode = .sender;
        } else if (receiver.value == null) {
          mode = .receiver;
        } else {
          mode = goodsType.value;
        }
        break;
      case 2:
        switch (moveType.value) {
          case .item2Box:
            mode = boxDeparture.value == null ? .box : .item;
            break;
          case .box2Rack:
            mode = boxDeparture.value == null ? .box : .rack;
            break;
          case .box2Box:
            mode = boxDeparture.value == null
                ? .box
                : boxDestination.value == null
                ? .boxDestination
                : null;
            break;
        }
        break;
      case 10:
        mode = goodsType.value;
        break;
      default:
        break;
    }

    return mode;
  }

  void startWorker() {
    // stateWorker = debounce(helper.state, (current) {
    //   if (current.exception != null) {
    //     showError(current.exception!);
    //   }
    // }, time: const Duration(milliseconds: 500));
    _blueWorker = ever(bluetoothManager.isConnected, (value) {
      if (!value) {
        helper.state.value = ViewState.success(null);
        bluetoothManager.scannerPriority.value = .camera;
        isScanning.value = false;
      } else {
        doScanAndGet(scanMode: autoSelectField(), isEdit: isEdit);
      }
    });

    _savingWorker = ever(savingState, (callback) async {
      if (callback.isLoading) {
        showLoading();
      } else {
        hideLoading();

        if (callback.exception != null) {
          if (callback.exception?.type == .success) {
            showLoading(message: callback.exception?.message);
          } else {
            showError(callback.exception!);
          }
        }
      }
    });
  }

  void stopWorker() {
    // stateWorker.dispose(); // Mark it as dead
    _blueWorker.dispose();
    dateWorker.dispose();
    _savingWorker.dispose();
  }

  void scrollToBottom() async {
    // await Future.delayed(const Duration(milliseconds: 50));
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // MARK: Listener
  void _handleBluetoothListener() {
    bluetoothManager.dataSub?.listen(
      (bytes) {
        debugPrint('DATA RECEIVED: ${bytes.length} bytes');
        // Optionally display the data as text if it's printable
        try {
          // Visualize control characters
          final text = String.fromCharCodes(bytes).cleanBarcode;
          if (text.length < 100) {
            debugPrint('  Content: $text');
            if (isScanning.value) {
              _doGet(text);
              if (![
                    ScanMode.sender,
                    ScanMode.receiver,
                  ].contains(scanMode.value) &&
                  selectedMenu.id != 10) {
                scrollToBottom();
              }
            }
          }
          // state.value = ViewState.success(text);
        } catch (_) {
          // Not valid UTF-8, skip text display

          // state.value = ViewState.success(null);
        }
      },
      onError: (error) {
        debugPrint('DATA STREAM ERROR: $error');
        helper.state.value = ViewState.error(
          MessageException(message: error, type: .error),
        );
      },
    );
  }

  // MARK: Route
  Future<ScanResult> goToCameraScanner() async {
    final possibleFormats = BarcodeFormat.values.toList()
      ..removeWhere((e) => e == BarcodeFormat.unknown);

    List<BarcodeFormat> selectedFormats = [...possibleFormats];

    ScanResult? scanResult;
    try {
      scanResult = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': localize.cancel,
            'flash_on': localize.flashOn,
            'flash_off': localize.flashOff,
          },
          restrictFormat: selectedFormats,
          android: AndroidOptions(aspectTolerance: 0.00, useAutoFocus: true),
        ),
      );

      debugPrint(scanResult.type.toString());
      // if (scanResult.type)

      return scanResult;
    } on PlatformException catch (e) {
      scanResult = ScanResult(
        rawContent: e.code == BarcodeScanner.cameraAccessDenied
            ? localize.cameraNotGrant
            : 'Unknown error: $e',
      );
      return scanResult;
    }
  }
}
