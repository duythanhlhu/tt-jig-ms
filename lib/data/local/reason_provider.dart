import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:tt_jig_ms/data/model/reason_model.dart';

class ReasonProvider {
  static final ReasonProvider _instance = ReasonProvider._internal();

  factory ReasonProvider() => _instance;

  ReasonProvider._internal() {
    init();
  }

  late Box<ReasonModel> reasonBox;

  void init() async {
    if (Hive.isBoxOpen('reasons')) {
      reasonBox = Hive.box<ReasonModel>('reasons');
    } else {
      reasonBox = await Hive.openBox<ReasonModel>('reasons');
    }
  }

  List<ReasonModel>? get reasons {
    if (reasonBox.isNotEmpty) {
      return reasonBox.values.toList();
    } else {
      return null;
    }
  }

  void setReason({required ReasonModel reason}) async {
    try {
      bool alreadyExists = reasonBox.values.contains(reason);

      if (!alreadyExists) {
        await reasonBox.add(reason);
        debugPrint("Reason saved.");
      } else {
        debugPrint("Reason already in Hive");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void setReasons({required List<ReasonModel> reasons}) async {
    try {
      bool alreadyExists = reasonBox.values.any((element) {
        return listEquals(element as List?, reasons);
      });

      if (!alreadyExists) {
        await reasonBox.addAll(reasons);
        debugPrint("Reasons saved.");
      } else {
        debugPrint("Reasons already in Hive");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
