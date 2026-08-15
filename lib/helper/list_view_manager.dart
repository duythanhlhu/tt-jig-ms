import 'package:get/get.dart';

enum ListType { content, list }

class ListViewManager {
  static final ListViewManager _instance = ListViewManager._internal();

  factory ListViewManager() => _instance;

  ListViewManager._internal();

  final Rx<ListType> listType = ListType.list.obs;
}
