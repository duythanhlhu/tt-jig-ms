import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tt_jig_ms/constant/app_constant.dart';
import 'package:tt_jig_ms/core/network/exception/api_exception.dart';
import 'package:tt_jig_ms/helper/get_view_ext.dart';
import 'package:tt_jig_ms/l10n/app_localizations.dart';

extension GetControllerExt on GetxController {
  AppLocalizations get localize => AppLocalizations.of(Get.context!)!;

  // Method to show a default styled dialog
  void showDefaultDialog({
    String title = "",
    String message = "",
    String? confirmButton,
    String? cancelButton,
    VoidCallback? confirm,
    VoidCallback? cancel,
  }) async {
    confirmButton ??= localize.confirm;
    cancelButton ??= localize.cancel;
    await Future.delayed(const Duration(milliseconds: 50));
    Get.defaultDialog(
      title: title,
      middleText: message,
      confirm: GestureDetector(
        onTap: () {
          if (Get.isDialogOpen == true) {
            Get.back();
            if (confirm != null) {
              confirm();
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.tkgColor, width: 2),
            borderRadius: BorderRadius.circular(100),
            color: AppColor.tkgColor,
          ),
          padding: EdgeInsets.all(8),
          child: Text(
            confirmButton,
            style: primaryTextStyle(color: Colors.white),
          ),
        ),
      ),
      cancel: GestureDetector(
        onTap: () {
          if (Get.isDialogOpen == true) {
            Get.back();
            if (cancel != null) {
              cancel();
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.redtkgColor, width: 2),
            borderRadius: BorderRadius.circular(100),
            color: AppColor.redtkgColor,
          ),
          padding: EdgeInsets.all(8),
          child: Text(
            cancelButton,
            style: primaryTextStyle(color: Colors.white),
          ),
        ),
      ),
      // onConfirm: () {
      //   if (confirm != null) {
      //     confirm();
      //   }
      //   if (Get.isDialogOpen == true) {
      //     Get.back();
      //   }
      // },
      // onCancel: () {
      //   if (cancel != null) {
      //     cancel();
      //   }
      // },
    );
  }

  // Helper untuk menampilkan loading overlay global
  void showLoading({String? message}) async {
    Get.dialog(
      Center(
        child: message == null
            ? CircularProgressIndicator()
            : Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(radiusCircular(8)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_rounded, color: AppColor.tkgColor),
                    SizedBox(height: 8),
                    Text(
                      message,
                      style: secondaryTextStyle(
                        size: 14,
                        color: AppColor.tkgColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
      ),
      barrierDismissible: false,
    );

    if (message != null) {
      await Future.delayed(const Duration(milliseconds: 2000));
      hideLoading();
    }
  }

  // Helper untuk menyembunyikan dialog/loading
  void hideLoading() {
    // if (Get.isDialogOpen ?? false) Get.back();
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars(); // Specifically for snackbars
    }
    // OR
    if (Get.isDialogOpen ?? false) {
      Get.until((route) => !Get.isDialogOpen!);
    }
  }

  // Helper untuk snackbar cepat
  void showError(MessageException message) {
    Get.rawSnackbar(
      title: Get.context?.translate(message.type.name.toLowerCase()) ?? "",
      message: message.message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: message.type.color,
      instantInit: true,
      duration: Duration(seconds: 2),
    );
  }
}
