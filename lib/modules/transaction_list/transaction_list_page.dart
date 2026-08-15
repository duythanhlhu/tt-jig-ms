import 'dart:core';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tt_jig_ms/data/model/transaction_model.dart';
import 'package:tt_jig_ms/helper/get_view_ext.dart';
import 'package:tt_jig_ms/helper/helper.dart';
import 'package:tt_jig_ms/l10n/app_localizations.dart';
import 'package:tt_jig_ms/modules/create_transaction/create_transaction_controller.dart';
import 'package:tt_jig_ms/modules/filter/filter_controller.dart';
import 'package:tt_jig_ms/modules/transaction_list/transaction_list_controller.dart';

class TransactionListPage extends GetView<TransactionListController> {
  TransactionListPage({super.key});

  late AppLocalizations localize;

  @override
  Widget build(BuildContext context) {
    localize = context.localize;

    // controller.stateWorker = ever(controller.helper.state, (current) {
    // if (value != null) {
    //   showError(value);
    // }

    // if (current.isLoading) {
    //   showLoading();
    // } else {
    //   hideLoading();

    //   if (current.exception != null) {
    //     showError(current.exception!);
    //   }
    // }
    // });
    return Scaffold(
      appBar: appBarWidget(
        localize.transactions,
        actions: [
          ObxValue((value) {
            return listViewSelector(value.value, (value) {
              controller.setListType(value);
            });
          }, controller.listViewManager.listType),
          ObxValue((date) {
            return (date.value != null)
                ? IconButton(
                    onPressed: () {
                      date.value = null;
                      controller.pagingController.refresh();
                      // controller.getTransactions(page: 1);
                    },
                    icon: Icon(Icons.restore),
                  )
                : SizedBox();
          }, controller.filterController.selectedDate),
          if (controller.selectedMenu.id != 0)
            IconButton(
              onPressed: () {
                controller.goToNewTransaction();
              },
              icon: Icon(Icons.add_outlined),
            ),
        ],
      ),
      body: SafeArea(
        child: GetBuilder<TransactionListController>(
          id: 'transaction_list',
          builder: (controller) {
            return RefreshIndicator(
              onRefresh: () {
                return Future.sync(() => controller.pagingController.refresh());
              },
              child: PagingListener(
                controller: controller.pagingController,
                builder: (context, state, fetchNextPage) {
                  return PagedListView(
                    state: state,
                    fetchNextPage: fetchNextPage,
                    builderDelegate:
                        PagedChildBuilderDelegate<TransactionModel>(
                          itemBuilder: (context, item, index) {
                            return controller.listViewManager.listType.value ==
                                    .content
                                ? transactionCard(item)
                                : transactionListCard(item);
                          },
                          firstPageProgressIndicatorBuilder: (_) =>
                              const Center(child: CircularProgressIndicator()),
                          newPageProgressIndicatorBuilder: (_) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (controller.selectedMenu.id == 2) {
            showFilterPopup();
          } else {
            controller.goToDatePicker();
          }
        },
        label: Text(localize.filter, style: primaryTextStyle(size: 12)),
        icon: Icon(Icons.filter_list_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget transactionCard(TransactionModel transaction) {
    return Container(
      margin: const EdgeInsets.only(top: 0, bottom: 5, left: 8, right: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 7),
      decoration: BoxDecoration(
        color: controller.selectedMenu.getColor(),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    transaction.transactionsTypeIDs.first,
                    style: secondaryTextStyle(
                      color: Colors.black87,
                      weight: FontWeight.bold,
                      size: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  transaction.getIcon,
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  infoField(
                    Icons.receipt,
                    [0, 1].contains(controller.selectedMenu.id)
                        ? localize.requestId
                        : localize.transactionType,
                    transaction.transactionType,
                    secondaryTextStyle(
                      weight: FontWeight.bold,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                  infoField(
                    Icons.numbers,
                    localize.transactionId,
                    transaction.transactionCode ?? "-",
                    secondaryTextStyle(weight: FontWeight.bold, size: 12),
                  ),
                  infoField(
                    Icons.source,
                    localize.from,
                    transaction.from ?? "-",
                    secondaryTextStyle(weight: FontWeight.bold, size: 12),
                  ),
                  infoField(
                    Icons.location_pin,
                    localize.newLocation,
                    transaction.newLocation ?? "-",
                    secondaryTextStyle(weight: FontWeight.normal, size: 11),
                  ),
                  infoField(
                    Icons.label,
                    localize.labelId,
                    transaction.labelCode ?? "-",
                    secondaryTextStyle(weight: FontWeight.bold, size: 12),
                  ),
                  infoField(
                    Icons.fiber_manual_record,
                    localize.itemCode,
                    transaction.itemCode ?? "-",
                    secondaryTextStyle(weight: FontWeight.bold, size: 12),
                  ),
                  infoField(
                    Icons.dock,
                    localize.container,
                    transaction.box ?? "-",
                    secondaryTextStyle(weight: FontWeight.bold, size: 12),
                  ),

                  // {"RN":"13","TRANS_ID":"13#T2512160205-(DESKTOP APP)","CREATED_BY":"TT23090004","CREATION_DATE":"2025-12-16 14:01:21","DATA_SOURCE":"DESKTOP APP","LABEL_ID":"L251216-0205 (TBJ06-02549)[-]","LABEL_TYPE":"ITEM","LOCATION":"-","LOCATION_NEW":"[ITEM LABEL]","TRANS_ID2":"#T2512160205-(DESKTOP APP)","TRANS_TYPE_ID":"IN_M25120007","DEV_ITEM_CODE":"TBJ06-02549_250307100","SIZE_CD":"14M","ALIAS_TOOLING":"CNC CUTTING","ALIAS_MODEL":"EYESTAY MIDDLE MEDIAL LATERIAL","STYLE":"NIKE AL 8 MS","ALIAS_PART":"050T","NK_CODE":null}
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  infoField(
                    Icons.style,
                    localize.style,
                    transaction.style ?? "-",
                    secondaryTextStyle(weight: FontWeight.normal, size: 11),
                  ),
                  infoField(
                    Icons.brush,
                    localize.model,
                    transaction.modelAlias ?? "-",
                    secondaryTextStyle(weight: FontWeight.normal, size: 11),
                  ),
                  infoField(
                    Icons.settings_suggest,
                    localize.part,
                    transaction.partAlias ?? "-",
                    secondaryTextStyle(weight: FontWeight.normal, size: 11),
                  ),
                  infoField(
                    Icons.construction,
                    localize.tools,
                    transaction.toolingAlias ?? "-",
                    secondaryTextStyle(weight: FontWeight.normal, size: 11),
                  ),
                  infoField(
                    Icons.person,
                    localize.createdBy,
                    transaction.createdBy ?? "-",
                    secondaryTextStyle(weight: FontWeight.normal, size: 11),
                  ),
                  infoField(
                    Icons.date_range,
                    localize.createdAt,
                    transaction.createdAt ?? "-",
                    secondaryTextStyle(weight: FontWeight.normal, size: 11),
                  ),
                  infoField(
                    Icons.format_size,
                    localize.size,
                    transaction.sizeCD ?? "-",
                    secondaryTextStyle(weight: FontWeight.bold, size: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget transactionListCard(TransactionModel transaction) {
    return Container(
      margin: const EdgeInsets.only(top: 0, bottom: 5, left: 8, right: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 7),
      decoration: BoxDecoration(
        color: controller.selectedMenu.getColor(),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          spacing: 0,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    transaction.transactionsTypeIDs.first,
                    style: secondaryTextStyle(
                      color: Colors.black87,
                      weight: FontWeight.bold,
                      size: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  transaction.getIcon,
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    transaction.transactionID ?? "-",
                    style: secondaryTextStyle(
                      weight: FontWeight.bold,
                      size: 12,
                    ),
                  ),
                  Text(
                    "${transaction.createdAt ?? "-"} (${transaction.createdBy ?? "-"})",
                    style: secondaryTextStyle(size: 11),
                  ),
                  Text(
                    transaction.newLocation ?? "-",
                    style: secondaryTextStyle(size: 11),
                  ),
                  Text(
                    transaction.labelID ?? "-",
                    style: secondaryTextStyle(
                      weight: FontWeight.bold,
                      size: 12,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    transaction.transactionType,
                    style: secondaryTextStyle(
                      weight: FontWeight.bold,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    transaction.modelAlias ?? "-",
                    style: secondaryTextStyle(size: 11),
                    textAlign: .end,
                  ),
                  Text(
                    transaction.partAlias ?? "-",
                    style: secondaryTextStyle(size: 11),
                    textAlign: .end,
                  ),
                  Text(
                    transaction.toolingAlias ?? "-",
                    style: secondaryTextStyle(size: 11),
                    textAlign: .end,
                  ),
                  Text(
                    transaction.sizeCD ?? "-",
                    style: secondaryTextStyle(
                      weight: FontWeight.bold,
                      size: 16,
                    ),
                    textAlign: .end,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showFilterPopup() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  localize.filterOptions,
                  style: primaryTextStyle(size: 24),
                ),
              ),
              Divider(),
              // Date Selector
              ObxValue((value) {
                return ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: Text(localize.date),
                  subtitle: Text(
                    value.value?.reformatTo("dd MMMM yyy") ??
                        localize.selectDate,
                  ),
                  onTap: () => controller.goToDatePicker(),
                );
              }, controller.filterController.selectedDate),

              const Divider(),
              Text(
                localize.selectCategory,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GetBuilder<FilterController>(
                id: 'category_list',
                builder: (filterController) {
                  return Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: MovingType.values.length,
                      itemBuilder: (context, index) {
                        final type = MovingType.values[index];
                        return CheckboxListTile(
                          title: Text(context.translate(type.asName)),
                          value: filterController.selectedCategories.contains(
                            type,
                          ),
                          onChanged: (bool? value) {
                            filterController.toggleCategory(type);
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          dense: true,
                        );
                      },
                    ),
                  );
                },
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        controller.resetFilter();
                        controller.applyFilter();
                        Get.back();
                      },
                      child: Text(
                        localize.reset,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        controller.applyFilter();
                        Get.back();
                      },
                      child: Text(localize.apply),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    // Get.defaultDialog(
    //   title: localize.filterOptions,
    //   content: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       // Date Selector
    //       ObxValue((value) {
    //         return ListTile(
    //           leading: const Icon(Icons.calendar_month),
    //           title: Text(localize.date),
    //           subtitle: Text(
    //             value.value?.reformatTo("dd MMMM yyy") ?? localize.selectDate,
    //           ),
    //           onTap: () => controller.goToDatePicker(),
    //         );
    //       }, controller.filterController.selectedDate),

    //       const Divider(),
    //       Text(
    //         localize.selectCategory,
    //         style: TextStyle(fontWeight: FontWeight.bold),
    //       ),
    //       const SizedBox(height: 10),
    //       GetBuilder<FilterController>(
    //         id: 'category_list',
    //         builder: (filterController) {
    //           return Flexible(
    //             child: ListView.builder(
    //               shrinkWrap: true,
    //               itemCount: MovingType.values.length,
    //               itemBuilder: (context, index) {
    //                 final type = MovingType.values[index];
    //                 return CheckboxListTile(
    //                   title: Text(context.translate(type.asName)),
    //                   value: filterController.selectedCategories.contains(type),
    //                   onChanged: (bool? value) {
    //                     filterController.toggleCategory(type);
    //                   },
    //                   controlAffinity: ListTileControlAffinity.leading,
    //                   dense: true,
    //                 );
    //               },
    //             ),
    //           );
    //         },
    //       ),
    //     ],
    //   ),

    //   confirm: TextButton(
    //     onPressed: () {
    //       controller.applyFilter();
    //       Get.back();
    //     },
    //     child: Text(localize.apply),
    //   ),
    //   cancel: TextButton(
    //     onPressed: () {
    //       controller.resetFilter();
    //       controller.applyFilter();
    //       Get.back();
    //     },
    //     child: Text(localize.reset, style: const TextStyle(color: Colors.red)),
    //   ),
    // );
  }
}
