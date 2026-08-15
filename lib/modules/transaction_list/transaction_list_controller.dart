import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tt_jig_ms/constant/app_constant.dart';
import 'package:tt_jig_ms/core/network/exception/api_exception.dart';
import 'package:tt_jig_ms/core/network/network_manager.dart';
import 'package:tt_jig_ms/core/routers/router.dart';
import 'package:tt_jig_ms/data/model/api_response_model.dart';
import 'package:tt_jig_ms/data/model/menu_model.dart';
import 'package:tt_jig_ms/data/model/transaction_model.dart';
import 'package:tt_jig_ms/helper/get_controller_ext.dart';
import 'package:tt_jig_ms/helper/helper.dart';
import 'package:tt_jig_ms/helper/list_view_manager.dart';
import 'package:tt_jig_ms/modules/create_transaction/create_transaction_controller.dart';
import 'package:tt_jig_ms/modules/filter/filter_controller.dart';

class TransactionListController extends GetxController {
  final networkManager = NetworkManager();
  final listViewManager = ListViewManager();
  final helper = Helper();
  late final MenuModel selectedMenu;
  // final selectedDate = Rxn<DateTime>();

  final FilterController filterController = Get.find<FilterController>();

  // late Worker stateWorker;

  late final pagingController = PagingController<int, TransactionModel>(
    getNextPageKey: (state) =>
        state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (pageKey) async {
      return await getTransactions(page: pageKey);
    },
  );

  @override
  void onInit() async {
    selectedMenu = Get.arguments;
    super.onInit();

    if (selectedMenu.id == 2) {
      resetFilter();
    }
  }

  @override
  void dispose() {
    super.dispose();
    // stateWorker.dispose();
    helper.state.value = .idle();
  }

  @override
  void onClose() {
    // stateWorker.dispose();
    super.onClose();
    helper.state.value = .idle();
  }

  // MARK: API
  Future<List<TransactionModel>> getTransactions({int page = 1}) async {
    try {
      var parameter = TransactionRequestModel(
        page: page,
        date: filterController.selectedDate.value?.reformatTo("yyMMdd") ?? "",
        menu: selectedMenu.id == 2 ? "RACK" : "TRANS",
        type:
            selectedMenu.destType?.map((e) => e.name.toUpperCase()).join(",") ??
            "",
      );
      FormData formData = FormData.fromMap(parameter.toJson());
      var response = await networkManager
          .post<ApiResponseModel<List<TransactionModel>>>(
            '${Env.apiBaseUrl}/${APIRoute.transactions}',
            body: formData,
            parser: (json) {
              return ApiResponseModel.fromJson(json, (transactionList) {
                List<TransactionModel> results = [];
                if (transactionList is List) {
                  var data = transactionList
                      .whereType<Map<String, dynamic>>()
                      .toList();
                  results = data.map((e) {
                    return TransactionModel.fromJson(e);
                  }).toList();
                }
                return results;
              });
            },
          );

      return response.data ?? [];
    } catch (e) {
      var message = "";
      if (e is DioException && e.error is ApiException) {
        message = (e.error as ApiException).message;
      } else if (e is String) {
        message = e.toString();
      } else {
        message = localize.somethingWrong;
      }
      showError(MessageException(message: message, type: .error));
      // helper.state.value = ViewState.error(
      //   MessageException(message: message, type: .error),
      // );
      return [];
    }
  }

  // MARK: Setter

  // void setDate(DateTime? date) {
  //   selectedDate.value = date;

  //   getTransactions(page: 1, selectedDate: date!.reformatTo("yyMMdd"));
  // }

  void setListType(ListType type) {
    listViewManager.listType.value = type;
    update(['transaction_list']);
    // transactions.refresh();
  }

  // MARK: Action
  void resetFilter() {
    filterController.selectedCategories.value = [
      MovingType.item2Box,
      MovingType.box2Rack,
      MovingType.box2Box,
    ];
    filterController.resetFilters();
    selectedMenu.destType = filterController.selectedCategories
        .map((element) => element.asDestType)
        .toList();
    pagingController.refresh();
    update(['category_list']);
  }

  void applyFilter() async {
    selectedMenu.destType = filterController.selectedCategories
        .map((element) => element.asDestType)
        .toList();
    // await getTransactions();
    pagingController.refresh();
  }

  // MARK: Route
  void goToNewTransaction() {
    Get.toNamed(RouteName.createTransactionScreen, arguments: selectedMenu);
    // Get.put(CreateTransactionController());
  }

  void goToDatePicker() async {
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: filterController.selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      cancelText: localize.cancel,
      confirmText: localize.select,
    );
    if (picked != null) {
      filterController.selectedDate.value = picked;
      update(['category_list']);
      if (selectedMenu.id != 2) {
        pagingController.refresh();
        // await getTransactions(page: 1);
      }
    }
  }
}
