import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tt_jig_ms/constant/app_constant.dart';
import 'package:tt_jig_ms/helper/get_controller_ext.dart';
import 'package:tt_jig_ms/helper/get_view_ext.dart';
import 'package:tt_jig_ms/helper/helper.dart';
import 'package:tt_jig_ms/modules/login/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.stateWorker = ever(controller.helper.state, (current) {
      // if (current.isLoading) {
      //   showLoading();
      // } else {
      //   hideLoading();

      if (current.exception != null) {
        controller.showError(current.exception!);
        controller.helper.state.value = .idle();
      }
      // }
    });

    return OrientationBuilder(
      builder: (context, orientation) {
        switch (orientation) {
          case .landscape:
            return loginTablet();

          default:
            return loginPhone();
        }
      },
    );

    // Helper.isTablet ? loginTablet() : loginPhone();
  }

  Widget loginPhone() {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape =
              MediaQuery.of(context).orientation == Orientation.landscape;

          return SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: controller.formKeys[0], //.potraitFormKey,
                  child: Column(
                    children: [
                      // Text(localize.welcome),
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: Image.asset(
                            AssetHelper.getImagePath("highrack_logo.png"),
                          ),
                        ),
                      ),
                      10.height,
                      Text(localize.loginState),
                      16.height,
                      ObxValue((value) {
                        return AppTextField(
                          textFieldType: TextFieldType.NAME,
                          textCapitalization: TextCapitalization.characters,
                          initialValue: controller.cacheUserID.value,
                          decoration: InputDecoration(
                            labelText: localize.employeeId,
                            hintText: 'TTYYMMXXXX',
                            labelStyle: secondaryTextStyle(size: 16),
                            prefixIcon: const Icon(Icons.person, color: black),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColor.colorLightGrey.withValues(
                                  alpha: 0.5,
                                ),
                                width: 1,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localize.fieldRequired;
                            } else if (value.length != 10) {
                              return localize.invalidLength;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            controller.userID = value;
                          },
                        );
                      }, controller.cacheUserID),

                      16.height,
                      AppTextField(
                        textFieldType: TextFieldType.PASSWORD,
                        decoration: InputDecoration(
                          labelText: localize.password,
                          hintText: '********',
                          labelStyle: secondaryTextStyle(size: 16),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: black,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColor.colorLightGrey.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                        ),
                        errorThisFieldRequired: localize.fieldRequired,
                        onChanged: (value) {
                          controller.password = value;
                        },
                      ),
                      Row(
                        children: [
                          ObxValue((value) {
                            return Checkbox(
                              value: value.value,
                              onChanged: (value) {
                                controller.setRememberMe(value ?? false);
                              },
                            );
                          }, controller.rememberMe),

                          Text(
                            localize.rememberMe,
                            style: secondaryTextStyle(size: 14),
                          ),
                        ],
                      ),
                      75.height,
                      AppButton(
                        color: AppColor.tkgColor,
                        width: double.infinity,
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ObxValue((current) {
                              return current.value.isLoading
                                  ? Row(
                                      children: [
                                        CircularProgressIndicator(color: white),
                                        SizedBox(width: 16),
                                      ],
                                    )
                                  : SizedBox.shrink();
                            }, controller.helper.state),

                            Text(
                              localize.login,
                              style: boldTextStyle(color: white),
                            ),
                          ],
                        ),
                        onTap: () async {
                          if (controller /*.potraitFormKey*/
                                      .formKeys[0]!
                                      .currentState !=
                                  null &&
                              controller /*.potraitFormKey*/
                                  .formKeys[0]!
                                  .currentState!
                                  .validate()) {
                            controller.doLogin();
                          }
                        },
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(localize.noAccount, style: primaryTextStyle()),
                          8.width,
                        ],
                      ),
                      if (!isLandscape) Spacer(),
                      Container(
                        width: double.infinity,
                        height: 35,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              AssetHelper.getImagePath("logo.png"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget loginTablet() {
    final context = Get.context!;
    final screenWidth = MediaQuery.of(context).size.width;

    // Tentukan skala berdasarkan lebar layar
    double scale = screenWidth > 1920
        ? 1.5 // Untuk desktop atau layar besar
        : screenWidth > 1300
        ? 1
        : screenWidth > 1000
        ? 0.9
        : screenWidth > 800
        ? 0.7 // Untuk tablet
        : 0.6;
    final Color scaffoldBackgroundColor = Theme.of(
      context,
    ).scaffoldBackgroundColor;

    // Form(
    // key: controller.formKey,
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Row(
          children: [
            // Kolom Kiri: Gambar
            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AssetHelper.getImagePath('highrack_logo.png'),
                      width: 400 * scale,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.image_not_supported,
                        size: 100 * scale,
                        color: Colors.grey,
                      ),
                    ),
                    // const SizedBox(height: 10),
                    Text(
                      controller.configService.appName.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Kolom Kanan: Input Login
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Image.asset(
                                  AssetHelper.getImagePath("logo_2.png"),
                                  width: 300 * scale,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        Icons.image_not_supported,
                                        size: 100 * scale,
                                        color: Colors.grey,
                                      ),
                                ),
                              ),
                              Form(
                                key:
                                    controller.formKeys[1], //.landscapeFormKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      localize.login,
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      localize.loginState,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 20),
                                    ObxValue((value) {
                                      return AppTextField(
                                        textFieldType: TextFieldType.NAME,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        initialValue:
                                            controller.cacheUserID.value,
                                        decoration: InputDecoration(
                                          labelText: localize.employeeId,
                                          hintText: 'TTYYMMXXXX',
                                          labelStyle: secondaryTextStyle(
                                            size: 16,
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.person,
                                            color: black,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColor.colorLightGrey
                                                  .withValues(alpha: 0.5),
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return localize.fieldRequired;
                                          } else if (value.length != 10) {
                                            return localize.invalidLength;
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          controller.userID = value;
                                        },
                                      );
                                    }, controller.cacheUserID),
                                    const SizedBox(height: 20),
                                    AppTextField(
                                      textFieldType: TextFieldType.PASSWORD,
                                      decoration: InputDecoration(
                                        labelText: localize.password,
                                        hintText: '********',
                                        labelStyle: secondaryTextStyle(
                                          size: 16,
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.lock_outline,
                                          color: black,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColor.colorLightGrey
                                                .withValues(alpha: 0.5),
                                          ),
                                        ),
                                      ),
                                      errorThisFieldRequired:
                                          localize.fieldRequired,
                                      onChanged: (value) {
                                        controller.password = value;
                                      },
                                    ),
                                    Row(
                                      children: [
                                        ObxValue((value) {
                                          return Checkbox(
                                            value: value.value,
                                            onChanged: (value) {
                                              controller.setRememberMe(
                                                value ?? false,
                                              );
                                            },
                                          );
                                        }, controller.rememberMe),

                                        Text(
                                          localize.rememberMe,
                                          style: secondaryTextStyle(size: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 40),
                                    AppButton(
                                      color: AppColor.tkgColor,
                                      width: double.infinity,
                                      height: 60,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ObxValue((current) {
                                            return current.value.isLoading
                                                ? Row(
                                                    children: [
                                                      CircularProgressIndicator(
                                                        color: white,
                                                      ),
                                                      SizedBox(width: 16),
                                                    ],
                                                  )
                                                : SizedBox.shrink();
                                          }, controller.helper.state),
                                          Text(
                                            localize.login,
                                            style: boldTextStyle(color: white),
                                          ),
                                        ],
                                      ),
                                      onTap: () async {
                                        if (controller
                                                    /*.landscapeFormKey*/
                                                    .formKeys[1]!
                                                    .currentState !=
                                                null &&
                                            controller
                                                /*.landscapeFormKey*/
                                                .formKeys[1]!
                                                .currentState!
                                                .validate()) {
                                          controller.doLogin();
                                        }
                                      },
                                    ),
                                    // SizedBox(
                                    //   width: double.infinity,
                                    //   // height: 50,
                                    //   child:
                                    // ),
                                  ],
                                ),
                              ),

                              // : Column(
                              //     mainAxisSize: MainAxisSize.min,
                              //     children: [
                              //       const SizedBox(height: 20),
                              //       Center(
                              //         child: Text(
                              //           "Register your ip address, Contact IT Team!" +
                              //               " [" +
                              //               _ip +
                              //               "] " +
                              //               "\n" +
                              //               "Version : ${ConstHelper.appVersion}$appsMode",
                              //           style: const TextStyle(
                              //             fontSize: 16,
                              //             color: Colors.grey,
                              //           ),
                              //           textAlign: TextAlign.center,
                              //         ),
                              //       ),
                              //       const SizedBox(height: 20),
                              //       Row(
                              //         children: [
                              //           const Spacer(),
                              //           AppButton(
                              //             type: AppButtonType.icon,
                              //             onPressed: restartApp,
                              //             icon: Icons.refresh,
                              //           ),
                              //           AppButton(
                              //             type: AppButtonType.icon,
                              //             onPressed: _showLoginForm,
                              //             icon: Icons.settings,
                              //           ),
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
