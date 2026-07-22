import 'package:isar_community/isar.dart';

import 'package:sanmiwago_user/models/item_models/item_addons_model.dart';
import 'package:sanmiwago_user/models/item_models/item_model.dart';
import 'package:sanmiwago_user/models/item_models/item_options_model.dart';

part 'cart_item.g.dart';

@embedded
class CartItem {
  late String itemId;
  late String sortBy;
  late String menuId;
  late String itemCategory;
  late String itemName;
  late String itemCost;
  late int itemCount;
  late double totalPrice;
  late String itemPoints;
  late String pointsToPurchase;
  late String itemTypeId;
  late String itemImageName;
  late String itemDescription;
  late String status;
  late String isMostSellingItem;
  late String productId;
  late String note;
  late List<CartItemOption> options;
  late List<CartItemOption> offerOptions;
  late List<CartItemAddon> addons;

  MenuItem toMenuItem() => MenuItem(
        itemId: itemId,
        sortBy: sortBy,
        menuId: menuId,
        itemCategory: itemCategory,
        itemName: itemName,
        itemCost: itemCost,
        itemCount: itemCount,
        totalPrice: totalPrice,
        itemPoints: itemPoints,
        pointsToPurchase: pointsToPurchase,
        itemTypeId: itemTypeId,
        itemImageName: itemImageName,
        itemDescription: itemDescription,
        status: status,
        isMostSellingItem: isMostSellingItem,
        productId: productId,
        note: note,
        options: options.map((e) => e.toMenuItemOption()).toList(),
        offerOptions: offerOptions.map((e) => e.toMenuItemOption()).toList(),
        addons: addons.map((e) => e.toMenuItemAddon()).toList(),
      );
}

@embedded
class CartItemOption {
  late String optionId;
  late String optionName;
  late String status;
  late String itemOptionId;
  late String itemId;
  late String price;

  MenuItemOption toMenuItemOption() => MenuItemOption(
        optionId: optionId,
        optionName: optionName,
        status: status,
        itemOptionId: itemOptionId,
        itemId: itemId,
        price: price,
      );
}

@embedded
class CartItemAddon {
  late String addonId;
  late String addonName;
  late String categoryName;
  late String price;
  late String description;
  late String addonImage;
  late String status;
  late String itemAddonId;
  late String itemId;
  late double finalCost;

  MenuItemAddon toMenuItemAddon() => MenuItemAddon(
        addonId: addonId,
        addonName: addonName,
        categoryName: categoryName,
        price: price,
        description: description,
        addonImage: addonImage,
        status: status,
        itemAddonId: itemAddonId,
        itemId: itemId,
        finalCost: finalCost,
      );
}
