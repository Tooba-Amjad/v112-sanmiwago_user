import 'package:sanmiwago_user/models/cart_item.dart';
import 'package:sanmiwago_user/models/item_models/item_addons_model.dart';
import 'package:sanmiwago_user/models/item_models/item_model.dart';
import 'package:sanmiwago_user/models/item_models/item_options_model.dart';

extension MenuItemExtension on MenuItem {
  CartItem toCartItem() => CartItem()
    ..itemId = itemId
    ..sortBy = sortBy
    ..menuId = menuId
    ..itemCategory = itemCategory
    ..itemName = itemName
    ..itemCost = itemCost
    ..itemCount = itemCount
    ..totalPrice = totalPrice
    ..itemPoints = itemPoints
    ..pointsToPurchase = pointsToPurchase
    ..itemTypeId = itemTypeId
    ..itemImageName = itemImageName
    ..itemDescription = itemDescription
    ..status = status
    ..isMostSellingItem = isMostSellingItem
    ..productId = productId
    ..note = note
    ..options = options.map((e) => e.toCartItemOption()).toList()
    ..offerOptions = offerOptions.map((e) => e.toCartItemOption()).toList()
    ..addons = addons.map((e) => e.toCartItemAddon()).toList();
}

extension MenuItemOptionExtension on MenuItemOption {
  CartItemOption toCartItemOption() => CartItemOption()
    ..optionId = optionId
    ..optionName = optionName
    ..status = status
    ..itemOptionId = itemOptionId
    ..itemId = itemId
    ..price = price;
}

extension MenuItemAddonExtension on MenuItemAddon {
  CartItemAddon toCartItemAddon() => CartItemAddon()
    ..addonId = addonId
    ..addonName = addonName
    ..categoryName = categoryName
    ..price = price
    ..description = description
    ..addonImage = addonImage
    ..status = status
    ..itemAddonId = itemAddonId
    ..itemId = itemId
    ..finalCost = finalCost;
}
