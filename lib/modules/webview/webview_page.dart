import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tt_jig_ms/core/network/exception/api_exception.dart';
import 'package:tt_jig_ms/helper/get_view_ext.dart';
import 'package:tt_jig_ms/l10n/app_localizations.dart';
import 'package:tt_jig_ms/modules/webview/webview_controller.dart';

class WebviewPage extends GetView<WebviewController> {
  WebviewPage({super.key});

  late AppLocalizations localize;

  @override
  Widget build(BuildContext context) {
    // ever(controller.errorMessage, (value) {
    //   if (value.isNotEmpty) {
    //     showError(value);
    //   }
    // });

    localize = context.localize;

    return Scaffold(
      appBar: appBarWidget(context.translate(controller.selectedMenu.title)),
      body: SafeArea(
        child: Obx(() {
          var msg = controller.helper.state.value.exception?.message ?? "";
          if (msg.isNotEmpty) {
            return retry(context.translate(msg));
          } else if (controller.internetStatus.value ==
              InternetStatus.connected) {
            controller.helper.state.value = .idle();
            return _webview();
          } else {
            return retry(localize.connectionGone);
          }
        }),
        // ObxValue((status) {
        //   if (status.value == InternetStatus.connected) {
        //     return _webview();
        //   } else {
        //     return retry();
        //   }
        // }, controller.internetStatus),
      ),
    );
  }

  Widget _webview() {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: controller.webUri()),
      initialSettings: InAppWebViewSettings(
        useWideViewPort: true,
        loadWithOverviewMode: true,
        supportZoom: true,
        javaScriptEnabled: true,
        initialScale: 100,
      ),
      onWebViewCreated: (controller) {
        Get.find<WebviewController>().onWebViewCreated(controller);
      },
      onLoadStart: (controller, url) {},
      onLoadStop: (controller, url) async {
        this.controller.saveCookie();
        // this.controller.webError.value = "";
        await controller.evaluateJavascript(
          source: """
                  var meta = document.createElement('meta');
                  meta.name = 'viewport';
                  meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
                  document.getElementsByTagName('head')[0].appendChild(meta);
                """,
        );
      },
      onProgressChanged: (controller, progress) {},
      onReceivedServerTrustAuthRequest: (controller, challenge) async {
        return ServerTrustAuthResponse(
          action: ServerTrustAuthResponseAction.PROCEED,
        );
      },
      onPermissionRequest: (controller, permissionRequest) async {
        await this.controller.requestPermission();
        return PermissionResponse(
          resources: permissionRequest.resources,
          action: PermissionResponseAction.GRANT,
        );
      },
      onReceivedError: (controller, request, error) {
        if (error.description.contains("ERR_CLEARTEXT_NOT_PERMITTED")) {
          this.controller.helper.state.value = ViewState.error(
            MessageException(
              message: "ERR_CLEARTEXT_NOT_PERMITTED",
              type: .error,
            ),
          );
        }
        debugPrint(error.description);
      },
    );
  }

  Widget retry(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              controller.reloadWebView();
            },
            child: Text(localize.retry),
          ),
        ],
      ),
    );
  }
}
