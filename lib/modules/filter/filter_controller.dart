import 'package:get/get.dart';
import 'package:tt_jig_ms/modules/create_transaction/create_transaction_controller.dart';

class FilterController extends GetxController {
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final RxList<MovingType> selectedCategories = RxList.empty(growable: true);

  void toggleCategory(MovingType type) {
    if (selectedCategories.contains(type)) {
      selectedCategories.remove(type);
    } else {
      selectedCategories.add(type);
    }
    update(['category_list']);
  }

  void resetFilters() {
    selectedDate.value = null;
  }
}
