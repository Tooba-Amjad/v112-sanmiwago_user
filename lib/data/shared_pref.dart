import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSharedPrefDatabase {
  static SharedPreferences? pref;

  static const _emailKey = 'emailKey';
  static const _selectedBranchId = 'selectedBranchId';
  static const _selectedBranchAddress = 'selectedBranchAddress';
  static const _selectedBranchPhone = 'selectedBranchPhone';

  static Future init() async {
    pref = await SharedPreferences.getInstance();
    restaurantController.selectedRestaurantId.value = getSelectedBranchId() ?? "";
    restaurantController.selectedRestaurantAddress.value = getSelectedBranchAddress() ?? "";
    restaurantController.selectedRestaurantPhone.value = getSelectedBranchPhone() ?? "";
  }

  static Future setUserEmail(String email) async {
    await pref!.setString(_emailKey, email);
  }

  static String? getUserEmail() {
    return pref!.getString(_emailKey);
  }

  static Future setSelectedBranchId(String branchId) async {
    await pref!.setString(_selectedBranchId, branchId);
  }

  static String? getSelectedBranchId() {
    return pref!.getString(_selectedBranchId);
  }

  static Future setSelectedBranchAddress(String branchAddress) async {
    await pref!.setString(_selectedBranchAddress, branchAddress);
  }

  static String? getSelectedBranchAddress() {
    return pref!.getString(_selectedBranchAddress);
  }

  static Future setSelectedBranchPhone(String branchPhone) async {
    await pref!.setString(_selectedBranchPhone, branchPhone);
  }

  static String? getSelectedBranchPhone() {
    return pref!.getString(_selectedBranchPhone);
  }

  static logout() {
    // pref!.clear();
    pref!.remove(_emailKey);
  }
}
