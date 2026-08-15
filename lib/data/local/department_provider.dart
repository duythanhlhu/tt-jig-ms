import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:tt_jig_ms/data/model/department_model.dart';

class DepartmentProvider {
  static final DepartmentProvider _instance = DepartmentProvider._internal();

  factory DepartmentProvider() => _instance;

  DepartmentProvider._internal() {
    init();
  }

  late Box<DepartmentModel> departmentBox;

  void init() async {
    if (Hive.isBoxOpen('departments')) {
      departmentBox = Hive.box<DepartmentModel>('departments');
    } else {
      departmentBox = await Hive.openBox<DepartmentModel>('departments');
    }
  }

  List<DepartmentModel>? get departments {
    if (departmentBox.isNotEmpty) {
      return departmentBox.values.toList();
    } else {
      return null;
    }
  }

  void setDepartment({required DepartmentModel department}) async {
    try {
      bool alreadyExists = departmentBox.values.contains(department);

      if (!alreadyExists) {
        await departmentBox.add(department);
        debugPrint("Department saved.");
      } else {
        debugPrint("Department already in Hive");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void setDepartments({required List<DepartmentModel> departments}) async {
    try {
      bool alreadyExists = departmentBox.values.any((element) {
        return listEquals(element as List?, departments);
      });

      if (!alreadyExists) {
        await departmentBox.addAll(departments);
        debugPrint("Departments saved.");
      } else {
        debugPrint("Departments already in Hive");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
