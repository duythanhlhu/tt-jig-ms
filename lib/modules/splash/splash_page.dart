import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tt_jig_ms/constant/app_constant.dart';
import 'package:tt_jig_ms/helper/get_controller_ext.dart';
import 'package:tt_jig_ms/helper/helper.dart';
import 'package:tt_jig_ms/modules/splash/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // controller.stateWorker = ever(controller.helper.state, (current) {
    //   if (current.isLoading) {
    //     controller.showLoading();
    //   } else {
    //     controller.hideLoading();

    //     if (current.exception != null) {
    //       controller.showError(current.exception!);
    //       controller.helper.state.value = .idle();
    //     }
    //   }
    // });

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.only(top: 8),
              width: double.infinity,
              height: 35,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AssetHelper.getImagePath("logo.png")),
                ),
              ),
            ),
            const Spacer(),
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: Image.asset(
                  AssetHelper.getImagePath("highrack_logo.png"),
                ),
              ),
            ),
            Obx(() {
              return Text(
                '[ ${controller.configService.appName.value} ]',
                style: TextStyle(
                  color: AppColor.tkgColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              );
            }),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the row contents
              children: [
                ObxValue((value) {
                  if (value.value == 100) {
                    bool isError =
                        controller.helper.state.value.exception?.type == .error;
                    return Icon(
                      isError
                          ? Icons.cancel_outlined
                          : Icons.check_circle_outline,
                      color: isError ? Colors.red : Colors.greenAccent,
                    );
                  } else {
                    return CircularProgressIndicator(
                      value: value.value != null
                          ? (value.value ?? 0) / 100
                          : null,
                      color: Colors.black,
                      strokeWidth: 1,
                    );
                  }
                }, controller.progress),
                const SizedBox(
                  width: 10,
                ), // Add some space between the indicator and the text
                Flexible(
                  child: Obx(() {
                    bool isError =
                        controller.helper.state.value.exception?.type == .error;
                    return Text(
                      controller.stringStatus.value,
                      style: TextStyle(
                        color: isError
                            ? Colors.red
                            : Colors.black, // Set the text color
                        fontSize: 16, // Set the font size
                      ),
                      maxLines: null,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              AppConstant.appDesc,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Obx(() {
              return Text(
                "${DateTime.now().year} IT TEAM. All rights reserved.\nApp Version ${controller.configService.appVersion.value}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
