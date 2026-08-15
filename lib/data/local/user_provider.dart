import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:tt_jig_ms/data/model/user_model.dart';

class UserProvider {
  static final UserProvider _instance = UserProvider._internal();

  factory UserProvider() => _instance;

  UserProvider._internal() {
    init();
  }

  late Box<UserModel> userBox;

  void init() async {
    if (Hive.isBoxOpen('loginLogs')) {
      userBox = Hive.box<UserModel>('loginLogs');
    } else {
      userBox = await Hive.openBox<UserModel>('loginLogs');
    }
  }

  UserModel? get currentUser {
    if (userBox.isNotEmpty) {
      return userBox.values.last;
    } else {
      return null;
    }
  }

  void setLogin({required UserModel user}) async {
    try {
      await userBox.add(user);
      debugPrint("User logged in.");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void setLogOut() async {
    currentUser?.loggedOutAt = DateTime.now();
    await currentUser?.save();
    await userBox.flush();
    debugPrint("User logged out.");
  }

  Future<List<UserModel>> _getUserLogs() async {
    List<UserModel> logs = userBox.values.toList();

    return logs;
  }
}
