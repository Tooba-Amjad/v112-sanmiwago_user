import 'package:isar_community/isar.dart';
import 'package:sanmiwago_user/models/cart_item.dart';

part 'cart.g.dart';

@collection
class Cart {
  Id isarId = 1; // Use a fixed ID for the singleton cart

  String localCartId = "";
  String orderId = "";
  List<CartItem> items = [];
}
