import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/category_model.dart';
import 'package:sanmiwago_user/models/item_models/item_addons_model.dart';
import 'package:sanmiwago_user/models/item_models/item_model.dart';
import 'package:sanmiwago_user/models/item_models/item_options_model.dart';

class CategoryItemController extends GetxController {
  static CategoryItemController instance = Get.find<CategoryItemController>();

  RxString selectedCategory = "BUBBLE TEA".obs;
  String selectedMenuId = "";
  RxString selectedMenuIdObx = "".obs;
  RxList<MenuCategory> categories = RxList<MenuCategory>.from([]);
  RxList<MenuItem> currentCategoryItems = RxList<MenuItem>.from([]);

  //+ selected item data before cart
  RxInt itemCount = 1.obs;
  RxString selectedOptionId = "".obs;
  final TextEditingController noteController = TextEditingController();
  RxList<String> selectedAddonIds = RxList<String>.from([]);
  final RxDouble itemTotal = 0.0.obs;
  Rx<MenuItem> selectedItem = MenuItem().obs;

  /// Calls apiController's method to get the list of categories here
  getCategoryList() {
    apiController.getCategories();
  }

  selectFirstCategory() {
    if (categories.isNotEmpty) {
      selectedCategory.value = categories.first.menuName;
      selectedMenuId = categories.first.menuId;
      selectedMenuIdObx.value = categories.first.menuId;
      apiController.getItems(showNoItemsMsg: false);
    }
  }

  selectACategory(String menuId) {
    selectedCategory.value = categories
        .firstWhere(
          (element) => element.menuId == menuId,
          orElse: () => MenuCategory(),
        )
        .menuName;
    selectedMenuId = menuId;
    selectedMenuIdObx.value = menuId;
    apiController.getItems();
  }

  selectItem(MenuItem item) {
    selectedItem.value = item;
    itemTotal.value += (double.tryParse(item.itemCost) ?? 0);
  }

  getItemDetails() async {
    await Future.wait([
      apiController.getItemOptions(),
      apiController.getItemAddons(),
    ]);
  }

  increaseItemCount() {
    itemCount++;
    itemTotal.value += (double.tryParse(selectedItem.value.itemCost) ?? 0);

    List<MenuItemAddon> addonsNewList = [];
    for (String addonId in catItemController.selectedAddonIds) {
      addonsNewList.add(
        catItemController.selectedItem.value.addons.firstWhere(
          (element) => element.addonId == addonId,
        ),
      );
    }
    double currentAddonsPrice = addonsNewList.fold(0.0, (previousValue, element) => previousValue + (double.tryParse(element.price) ?? 0.0));
    itemTotal.value += currentAddonsPrice;
    if (selectedOptionId.value.isNotEmpty) {
      MenuItemOption selectedOption = selectedItem.value.options.firstWhere((element) => element.optionId == selectedOptionId.value, orElse: () => MenuItemOption());
      itemTotal.value += (double.tryParse(selectedOption.price) ?? 0.0);
    }
  }

  decreaseItemCount() {
    if (itemCount > 1) {
      itemCount--;
      itemTotal.value -= (double.tryParse(selectedItem.value.itemCost) ?? 0);
      //+ also go through addons list and get all costs, add them up and multiply by quantity
      List<MenuItemAddon> addonsNewList = [];
      for (String addonId in catItemController.selectedAddonIds) {
        addonsNewList.add(
          catItemController.selectedItem.value.addons.firstWhere(
            (element) => element.addonId == addonId,
          ),
        );
      }
      double currentAddonsPrice = addonsNewList.fold(0.0, (previousValue, element) => previousValue + (double.tryParse(element.price) ?? 0.0));
      itemTotal.value -= currentAddonsPrice;
      if (selectedOptionId.value.isNotEmpty) {
        MenuItemOption selectedOption = selectedItem.value.options.firstWhere((element) => element.optionId == selectedOptionId.value, orElse: () => MenuItemOption());
        itemTotal.value -= (double.tryParse(selectedOption.price) ?? 0.0);
      }
    }
  }

  selectAddon(String addonId) {
    MenuItemAddon addon = selectedItem.value.addons.firstWhere((element) => element.addonId == addonId, orElse: () => MenuItemAddon());
    if (selectedAddonIds.contains(addonId)) {
      selectedAddonIds.remove(addonId);
      itemTotal.value -= (itemCount * (double.tryParse(addon.price) ?? 0));
    } else {
      selectedAddonIds.add(addonId);
      itemTotal.value += (itemCount * (double.tryParse(addon.price) ?? 0));
    }
  }

  selectOption(String optionId) {
    MenuItemOption alreadySelectedOption = selectedItem.value.options.firstWhere((element) => element.optionId == selectedOptionId.value, orElse: () => MenuItemOption());
    MenuItemOption option = selectedItem.value.options.firstWhere((element) => element.optionId == optionId, orElse: () => MenuItemOption());
    if (selectedOptionId.value.isEmpty) {
      selectedOptionId.value = optionId;
      itemTotal.value += (itemCount * (double.tryParse(option.price) ?? 0));
    } else if (selectedOptionId.value.isNotEmpty && selectedOptionId.value != optionId) {
      selectedOptionId.value = optionId;
      itemTotal.value -= (itemCount * (double.tryParse(alreadySelectedOption.price) ?? 0));
      itemTotal.value += (itemCount * (double.tryParse(option.price) ?? 0));
    } else {
      selectedOptionId.value = "";
      itemTotal.value -= (itemCount * (double.tryParse(option.price) ?? 0));
    }
  }

  clearItemVariables() {
    selectedItem.value = MenuItem();
    selectedOptionId.value = "";
    selectedAddonIds.clear();
    catItemController.noteController.clear();
    itemCount.value = 1;
    itemTotal.value = 0;
  }
}
