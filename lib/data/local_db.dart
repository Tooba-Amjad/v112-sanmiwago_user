import 'dart:developer';

import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/cart.dart';
import 'package:sanmiwago_user/models/user_model/user_model.dart';

class LocalDatabase {
  static User user = User()..isarId = 1;
  static Isar? isar;

  /// initializes isar
  static Future<void> initialize({bool doFurtherInitializations = true}) async {
    final dir = await getApplicationDocumentsDirectory();
    if (isar == null || !isar!.isOpen) isar = await Isar.open([UserSchema, CartSchema], directory: dir.path, inspector: true);
    log("Isar initialized");
    if (doFurtherInitializations) {
      authController.authInitialization();
    }
  }

  /// saves user data in User Table in isar
  static Future<void> saveUser(User newUser) async {
    if (isar?.isOpen ?? false) {
      user = newUser;
      await isar?.writeTxn(() async => await isar?.users.put(user));
    }
  }

  /// gets user data from User Table in isar
  static Future<User> getUser() async {
    if (isar?.isOpen ?? false) {
      final existingUser = await isar?.users.get(user.isarId); // get
      return existingUser ?? User();
    } else {
      return User();
    }
  }

  /// delete user data from User Table in isar
  static Future<void> deleteUser() async {
    if (isar?.isOpen ?? false) {
      await isar?.writeTxn(() async => await isar?.users.delete(1)); // delete
    }
  }

  /// saves cart data in Cart Table in isar
  static Future<void> saveCart(Cart newCart) async {
    if (isar?.isOpen ?? false) {
      await isar?.writeTxn(() async => await isar?.carts.put(newCart));
    }
  }

  /// saves cart data in Cart Table in isar
  static Future<void> updateCartOrderId(String orderId) async {
    if (isar?.isOpen ?? false) {
      final existingCart = await isar?.carts.get(1); // get
      if (existingCart != null) {
        await isar?.writeTxn(() async => await isar?.carts.put(existingCart!..orderId = orderId));
      }
    }
  }

  /// gets cart data from Cart Table in isar
  static Future<Cart?> getCart() async {
    if (isar?.isOpen ?? false) {
      final existingCart = await isar?.carts.get(1); // get
      return existingCart;
    } else {
      return null;
    }
  }

  /// delete cart data from Cart Table in isar
  static Future<void> deleteCart() async {
    if (isar?.isOpen ?? false) {
      await isar?.writeTxn(() async => await isar?.carts.delete(1)); // delete
    } else {
      log("NOT OPEN");
    }
  }
}
