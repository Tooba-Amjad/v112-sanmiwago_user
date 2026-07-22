import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/constants/my_logger.dart';
import 'package:sanmiwago_user/models/my_orders_model.dart';
import 'package:sanmiwago_user/models/user_model/user_promotions_model.dart';
import 'package:sanmiwago_user/views/pages/profile/my_orders_pages/my_order_container.dart';
import 'package:sanmiwago_user/views/pages/promotions/user_promotions_item_widget.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class UserPromotionsPage extends StatefulWidget {
  const UserPromotionsPage({Key? key}) : super(key: key);

  @override
  State<UserPromotionsPage> createState() => _UserPromotionsPageState();
}

class _UserPromotionsPageState extends State<UserPromotionsPage> {
  @override
  void initState() {
    super.initState();

    apiController.isLoadingUserPromos.value = true;
    userPromoController.myUserPromosList.clear();
    userPromoController.getPromotions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: "My Promotions",
        haveBackIcon: true,
      ),
      body: Obx(() {
        return userPromoController.myUserPromosList.isNotEmpty
            ? EasyRefresh(
                onRefresh: () {
                  apiController.isLoadingUserPromos.value = true;
                  userPromoController.myUserPromosList.clear();
                  userPromoController.getPromotions();
                },
                child: ListView.builder(
                  itemCount: userPromoController.myUserPromosList.length,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemBuilder: (BuildContext context, int index) {
                    UserPromotion promoItem = userPromoController.myUserPromosList[index];
                    return UserPromotionsItemWidget(index: index, promoItem: promoItem);
                    //   MyOrderContainer(
                    //   id: order.orderId,
                    //   status: order.status,
                    //   price: order.totalCost,
                    //   paymentType: order.paymentType,
                    //   isPointRedeemed: order.isPointsRedeemed,
                    //   dateTime: order.dateCreated,
                    //   order: order,
                    // );
                  },
                ),
              )
            : apiController.isLoadingUserPromos.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kLogoBasedColor,
                    ),
                  )
                : const Center(
                    child: MyText(
                      text: "No promotions to show for now",
                      fontSize: 16,
                    ),
                  );
      }),
    );
  }
}
