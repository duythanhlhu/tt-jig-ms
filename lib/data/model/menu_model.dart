import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:tt_jig_ms/constant/app_constant.dart';
import 'package:tt_jig_ms/helper/helper.dart';

enum DestType {
  t01, // item2box
  t02, // box2rack
  t03, // box2box
  t04, // outgoing
  t05, // incoming
  t06, // return
  t07; // destroy

  static List<DestType> get moving => [t01, t02, t03];
}

class MenuModel {
  int id;
  String? image;
  String title;
  String group;
  WebUri? url;
  bool active;
  List<DestType>? destType;

  MenuModel({
    required this.id,
    this.image,
    required this.title,
    required this.group,
    this.url,
    this.active = true,
    this.destType,
  });

  static Map<String, List<MenuModel>> get groupedMenuList {
    return groupBy(menuList(), (item) => item.group);
  }

  static List<MenuModel> menuList() {
    List<MenuModel> list = [
      MenuModel(
        id: 0,
        image: AssetHelper.getImagePath("freepick_safamily_WHIn.png"),
        title: "incomingItem",
        group: "building",
        destType: [.t05],
      ),
      MenuModel(
        id: 1,
        image: AssetHelper.getImagePath("freepick_safamily_WHOut.png"),
        title: "outgoingItem",
        group: "building",
        destType: [.t04],
      ),
      MenuModel(
        id: 2,
        image: AssetHelper.getImagePath("freepick_ppangman_Move.png"),
        title: "move",
        group: "rack",
        destType: DestType.moving,
      ),
      MenuModel(
        id: 3,
        image: AssetHelper.getImagePath("freepick_safamily_OnHand.png"),
        title: "stockOnHand",
        group: "inventory",
        url: WebUri(AppConstant.onHandURL),
      ),
      MenuModel(
        id: 4,
        image: AssetHelper.getImagePath("freepick_safamily_RackMon.png"),
        title: "rackMonitoring",
        group: "monitoring",
        url: WebUri(AppConstant.rackURL),
      ),
      // MenuModel(
      //   id: 5,
      //   image: AssetHelper.getImagePath("machine.png"),
      //   title: "kukdong",
      //   group: "monitoring",
      //   url: WebUri(AppConstant.kukdongURL),
      // ),
      // MenuModel(
      //   id: 6,
      //   image: AssetHelper.getImagePath("pack.png"),
      //   title: "onHand",
      //   group: "monitoring",
      //   url: WebUri(AppConstant.jigURL),
      // ),
      // MenuModel(
      //   id: 7,
      //   image: AssetHelper.getImagePath("rack.png"),
      //   title: "rack",
      //   group: "monitoring",
      //   url: WebUri(AppConstant.jigWarehouseURL),
      //   active: false,
      // ),
      // MenuModel(
      //   id: 8,
      //   image: AssetHelper.getImagePath("sewing.png"),
      //   title: "sewing",
      //   group: "monitoring",
      //   url: WebUri(AppConstant.sewingURL),
      // ),
      MenuModel(
        id: 9,
        image: AssetHelper.getImagePath("freepick_toempong_Return.png"),
        title: "returnItem",
        group: "items",
        destType: [.t06],
      ),
      MenuModel(
        id: 10,
        image: AssetHelper.getImagePath("freepick_freepik_barcode.png"),
        title: "barcodeInfo",
        group: "items",
      ),
      MenuModel(
        id: 11,
        image: AssetHelper.getImagePath("freepick_surang_Destroy.png"),
        title: "destroyItem",
        group: "items",
        destType: [.t07],
      ),
      MenuModel(
        id: 12,
        image: AssetHelper.getImagePath("freepick_ppangman_SO.png"),
        title: "stockOpname",
        group: "items",
        active: false,
      ),
    ];
    return list;
  }

  Color getColor() {
    switch (title) {
      case "move":
        return AppColor.tkgColorYellow;
      case "outgoingItem":
        return AppColor.tkgColorPink;
      case "incomingItem":
        return AppColor.tkgColorGreen;
      case "returnItem":
        return AppColor.tkgColorGrey;
      case "destroyItem":
        return AppColor.tkgColorOrange;
      default:
        return AppColor.tkgColor2;
    }
  }
}
