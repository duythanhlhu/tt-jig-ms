import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tt_jig_ms/constant/app_constant.dart';
import 'package:tt_jig_ms/data/model/menu_model.dart';
import 'package:tt_jig_ms/helper/get_controller_ext.dart';
import 'package:tt_jig_ms/helper/get_view_ext.dart';
import 'package:tt_jig_ms/l10n/app_localizations.dart';
import 'package:tt_jig_ms/modules/menu/menu_controller.dart';

class MenuPage extends GetView<MainMenuController> {
  MenuPage({super.key});

  late AppLocalizations localize;
  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    controller.stateWorker = ever(controller.helper.state, (current) {
      if (current.isLoading) {
        controller.showLoading();
      } else {
        controller.hideLoading();

        if (current.exception != null) {
          controller.showError(current.exception!);
          controller.helper.state.value = .idle();
        }
      }
    });

    buildContext = context;
    localize = buildContext.localize;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: width * 0.75,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.userProvider.currentUser?.employeeName ?? "",
                overflow: .ellipsis,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          controller.userProvider.currentUser?.employeeID ?? "",
                      style: secondaryTextStyle(
                        size: 12,
                        color: AppColor.tkgColor,
                      ),
                    ),
                    TextSpan(text: " - "),
                    TextSpan(
                      text: controller.userProvider.currentUser?.area ?? "",
                      style: secondaryTextStyle(
                        size: 12,
                        color: AppColor.redtkgColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          connectionIndicator(),
          languageSelector(),
          IconButton(
            onPressed: () {
              controller.confirmLogout(() {
                controller.doLogout();
              });
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),

      body: RefreshIndicator(
        child: Obx(() {
          return ListView.separated(
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildSummarySection();
              }
              String key = controller.groupedMenu.keys.elementAt(index - 1);
              return _categoryCard(key, controller.groupedMenu[key] ?? []);
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 4);
            },
            itemCount: controller.groupedMenu.length + 1,
          );
        }),
        onRefresh: () async {
          controller.getReport();
        },
      ),
    );
  }

  Widget _categoryCard(String key, List<MenuModel> menus) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.9)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                child: Text(
                  buildContext.translate(key),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.tkgColor.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
          HorizontalList(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            wrapAlignment: WrapAlignment.spaceEvenly,
            itemCount: menus.length,
            itemBuilder: (BuildContext context, int index) {
              MenuModel menu = menus[index];
              return _itemCard(menu, () {
                controller.handleAction(menu);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _itemCard(MenuModel menuItem, void Function()? action) {
    return Tooltip(
      message: !menuItem.active ? localize.notAvailable : "",
      child: GestureDetector(
        onTap: menuItem.active == true ? action : null,
        child: Column(
          children: [
            Image.asset(
              menuItem.image!,
              fit: BoxFit.fill,
              width: 60,
              height: 60,
              color: menuItem.active
                  ? null
                  : Colors.grey.withValues(alpha: 0.25),
              colorBlendMode: BlendMode.modulate,
            ),
            const SizedBox(height: 4),
            120.width,
            Text(
              "[${buildContext.translate(menuItem.title)}]",
              style: primaryTextStyle(
                size: 14,
                color: menuItem.active == true ? Colors.black : Colors.grey,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return ObxValue((items) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: items.map((element) {
            IconData icon = Icons.abc;
            Color color = Colors.transparent;
            String name = "";
            switch (element.reportType) {
              case "OH":
                icon = Icons.front_hand;
                color = Colors.blue;
                name = localize.onHand;
                break;
              case "IN":
                icon = Icons.move_to_inbox;
                color = Colors.green;
                name = localize.moveIn;
                break;
              case "OUT":
                icon = Icons.outbox;
                color = Colors.orange;
                name = localize.moveOut;
                break;
            }

            return _summaryCard(
              title: name,
              value: (element.qty ?? "").removeAllWhitespace,
              icon: icon,
              color: color,
            );
          }).toList(),
        ),
      );
    }, controller.reports);
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black.withValues(alpha: 0.05),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.grey)),
            SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
