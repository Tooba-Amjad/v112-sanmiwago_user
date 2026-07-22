import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/my_referral_models/my_referred_user_model.dart';
import 'package:sanmiwago_user/views/widgets/common_widgets.dart';
import 'package:sanmiwago_user/views/widgets/fields_container.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class MyReferralsTableViewPage extends StatefulWidget {
  const MyReferralsTableViewPage({Key? key}) : super(key: key);

  @override
  State<MyReferralsTableViewPage> createState() => _MyReferralsTableViewPageState();
}

class _MyReferralsTableViewPageState extends State<MyReferralsTableViewPage> {
  @override
  void initState() {
    myReferralsController.getMyReferredUsersList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: "My Referrals Table View",
        haveBackIcon: true,
      ),
      body: FieldsContainer(
        horizontalPadding: 20,
        children: [
          SizedBox(
            height: 30,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisExtent: 30,
                mainAxisSpacing: 0,
              ),
              itemCount: 2,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const MyText(
                    text: "User Name",
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // VerticalDivider(color: AppColors.kLightGreyColor),
                      Container(
                        width: 2,
                        color: AppColors.kLightGreyColor,
                      ),
                      const Expanded(
                        child: MyText(
                          text: "Joining Date & Time",
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          paddingLeft: 5,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          dividerCommon(color: AppColors.kLightGreyColor),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              return !apiController.isLoadingMyReferredUsers.value && myReferralsController.myReferredUsersList.isNotEmpty
                  ? GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 0,
                        mainAxisExtent: 30,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: myReferralsController.myReferredUsersList.length * 2,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        MyReferredUser mru = myReferralsController.myReferredUsersList[(index / 2).floor()];
                        if (index % 2 != 0) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(border: Border.all(color: AppColors.kSkyLightColor)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: MyText(
                                    text: mru.createdDatetime,
                                    paddingLeft: 3,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(border: Border.all(color: AppColors.kSkyLightColor)),
                          child: Row(
                            children: [
                              Expanded(
                                child: MyText(
                                  text: mru.username,
                                  paddingLeft: 3,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : apiController.isLoadingMyReferredUsers.value
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.kLogoBasedColor,
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
          ),
        ],
      ),
    );
  }
}
