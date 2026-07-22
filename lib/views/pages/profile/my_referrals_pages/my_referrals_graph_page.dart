import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/my_referral_models/my_referred_user_model.dart';
import 'package:sanmiwago_user/views/pages/profile/my_referrals_pages/components/child_graphical_node.dart';
import 'package:sanmiwago_user/views/pages/profile/my_referrals_pages/components/graphical_node.dart';
import 'package:sanmiwago_user/views/widgets/common_widgets.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class MyReferralsGraphicalViewPage extends StatefulWidget {
  const MyReferralsGraphicalViewPage({Key? key}) : super(key: key);

  @override
  State<MyReferralsGraphicalViewPage> createState() => _MyReferralsGraphicalViewPageState();
}

class _MyReferralsGraphicalViewPageState extends State<MyReferralsGraphicalViewPage> {
  @override
  void initState() {
    myReferralsController.getMyReferredUsersList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: "My Referrals Graphical View",
        haveBackIcon: true,
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GraphicalNode(
                name: "${authController.userData.value.firstName} ${authController.userData.value.lastName}",
                isParent: true,
              ),
            ),
            Obx(() {
              return !apiController.isLoadingMyReferredUsers.value && myReferralsController.myReferredUsersList.isNotEmpty
                  ? SizedBox(
                      height: (70 * myReferralsController.myReferredUsersList.length).toDouble(),
                      child: Row(
                        children: [
                          Container(
                            // elevation: 20,
                            margin: const EdgeInsets.only(left: 40),
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 15.0,
                                  offset: Offset(-10.0, 0),
                                ),
                              ],
                            ),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: dividerCommon(
                                color: AppColors.kGreyColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Get.width * .7,
                            child: ListView.builder(
                              itemCount: myReferralsController.myReferredUsersList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                MyReferredUser mru = myReferralsController.myReferredUsersList[index];
                                return ChildGraphicalNode(
                                  name: mru.username,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : apiController.isLoadingMyReferredUsers.value
                      ? SizedBox(
                          height: Get.height * .8,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.kLogoBasedColor,
                            ),
                          ),
                        )
                      : const Center(
                          child: MyText(
                            text: "No users referred yet. copy your referral code "
                                "from your profile and share with the food lovers you know 😋",
                            align: TextAlign.center,
                            fontSize: 22,
                            paddingTop: 20,
                            paddingLeft: 10,
                            paddingRight: 10,
                          ),
                        );
            }),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
