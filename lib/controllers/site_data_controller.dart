import 'package:get/get.dart';
import 'package:sanmiwago_user/models/site_model.dart';

class SiteDataController extends GetxController{
  static SiteDataController instance = Get.find<SiteDataController>();

  RxDouble salesTax = 0.0.obs;
  SiteInfo siteData = SiteInfo();
}