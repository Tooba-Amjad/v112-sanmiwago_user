import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/views/pages/login/login_page.dart';
import 'package:sanmiwago_user/views/pages/profile/change_password_page.dart';
import 'package:sanmiwago_user/views/pages/profile/my_orders_pages/my_orders_page.dart';
import 'package:sanmiwago_user/views/pages/profile/my_orders_pages/my_referral_orders_page.dart';
import 'package:sanmiwago_user/views/pages/profile/my_points_page.dart';
import 'package:sanmiwago_user/views/pages/profile/my_referrals_pages/my_referrals_graph_page.dart';
import 'package:sanmiwago_user/views/pages/profile/my_referrals_pages/my_referrals_table_page.dart';
import 'package:sanmiwago_user/views/pages/profile/profile_page.dart';
import 'package:sanmiwago_user/views/pages/promotions/promotions_list_page.dart';
import 'package:sanmiwago_user/views/pages/signup/signup_page.dart';
import 'package:sanmiwago_user/views/pages/signup_referrals/signup_referral_offers.dart';
import 'package:sanmiwago_user/views/pages/subscriptions/my_subscription_orders_page.dart';
import 'package:sanmiwago_user/views/pages/subscriptions/my_subscriptions_page.dart';
import 'package:sanmiwago_user/views/widgets/common_widgets.dart';
import 'package:sanmiwago_user/views/widgets/members_only_chip_widget.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class ProfileMenuPage extends StatelessWidget {
  final bool? isFromBottomNavBar;

  const ProfileMenuPage({super.key, this.isFromBottomNavBar = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.kSkyLightDullColor,
      appBar: simpleAppBar(
        title: "Profile Menu",
        haveBackIcon: false,
        haveDrawerIcon: true,
        onBackPressed: () {
          Get.back();
        },
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(
              Icons.perm_identity_rounded,
              color: AppColors.kBlackColor,
            ),
            title: const MyText(text: "My Profile"),
            onTap: () {
              if (authController.isLoggedIn.value) navigate(type: PageType.to, page: MyProfilePage(preContext: context));
            },
            trailing: Obx(() {
              return !authController.isLoggedIn.value ? MembersOnlyChip() : SizedBox();
            }),
          ),
          dividerCommon(color: AppColors.kSkyLightDullColor),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.dropbox,
              color: AppColors.kBlackColor,
            ),
            title: const MyText(text: "My Orders"),
            onTap: () {
              if (authController.isLoggedIn.value) navigate(type: PageType.to, page: const MyOrdersPage());
            },
            trailing: Obx(() {
              return !authController.isLoggedIn.value ? MembersOnlyChip() : SizedBox();
            }),
          ),
          dividerCommon(color: AppColors.kSkyLightDullColor),
          ListTile(
            leading: const Icon(
              Icons.account_balance_wallet_rounded,
              color: AppColors.kBlackColor,
            ),
            title: const MyText(text: "My Points"),
            onTap: () {
              if (authController.isLoggedIn.value) navigate(type: PageType.to, page: const MyPointsPage(isFromProfilePage: true));
            },
            trailing: Obx(() {
              return !authController.isLoggedIn.value ? MembersOnlyChip() : SizedBox();
            }),
          ),
          dividerCommon(color: AppColors.kSkyLightDullColor),
          ListTile(
            leading: const Icon(
              Icons.subtitles_sharp,
              color: AppColors.kBlackColor,
            ),
            title: const MyText(text: "My Subscriptions"),
            onTap: () {
              if (authController.isLoggedIn.value) navigate(type: PageType.to, page: const MySubscriptionsPage());
            },
            trailing: Obx(() {
              return !authController.isLoggedIn.value ? MembersOnlyChip() : SizedBox();
            }),
          ),
          dividerCommon(color: AppColors.kSkyLightDullColor),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.dropbox,
              color: AppColors.kBlackColor,
            ),
            title: const MyText(text: "My Subscription Orders"),
            onTap: () {
              if (authController.isLoggedIn.value) navigate(type: PageType.to, page: const MySubscriptionOrdersPage());
            },
            trailing: Obx(() {
              return !authController.isLoggedIn.value ? MembersOnlyChip() : SizedBox();
            }),
          ),
          dividerCommon(color: AppColors.kSkyLightDullColor),

          ListTile(
            leading: const Icon(
              Icons.local_offer_outlined,
              color: AppColors.kBlackColor,
            ),
            title: const MyText(text: "Signup Referral Offers"),
            onTap: () {
              if (authController.isLoggedIn.value) navigate(type: PageType.to, page: const MySignupReferralOffersPage());
            },
            trailing: Obx(() {
              return !authController.isLoggedIn.value ? MembersOnlyChip() : SizedBox();
            }),
          ),
          dividerCommon(color: AppColors.kSkyLightDullColor),
          //+ COMMENTED BY ALLAN On 27 October 2024
          //+ UN-COMMENTED on 19-Jan-2025
          ListTile(
            leading: const Icon(
              Icons.share_rounded,
              color: AppColors.kBlackColor,
            ),
            title: const MyText(text: "My Referral Graphical"),
            onTap: () {
              if (authController.isLoggedIn.value) navigate(type: PageType.to, page: const MyReferralsGraphicalViewPage());
            },
            trailing: Obx(() {
              return !authController.isLoggedIn.value ? MembersOnlyChip() : SizedBox();
            }),
          ),
          dividerCommon(color: AppColors.kSkyLightDullColor),
          ListTile(
            leading: const Icon(
              Icons.share_rounded,
              color: AppColors.kBlackColor,
            ),
            title: const MyText(text: "My Referral Table"),
            onTap: () {
              if (authController.isLoggedIn.value) navigate(type: PageType.to, page: const MyReferralsTableViewPage());
            },
            trailing: Obx(() {
              return !authController.isLoggedIn.value ? MembersOnlyChip() : SizedBox();
            }),
          ),
          dividerCommon(color: AppColors.kSkyLightDullColor),
          ListTile(
            leading: const Icon(
              Icons.book_outlined,
              color: AppColors.kBlackColor,
            ),
            title: const MyText(text: "Referral Orders"),
            onTap: () {
              if (authController.isLoggedIn.value) navigate(type: PageType.to, page: const MyReferralOrdersPage());
            },
            trailing: Obx(() {
              return !authController.isLoggedIn.value ? MembersOnlyChip() : SizedBox();
            }),
          ),
          dividerCommon(color: AppColors.kSkyLightDullColor),
          ListTile(
            leading: const Icon(
              Icons.lock_open_rounded,
              color: AppColors.kBlackColor,
            ),
            title: const MyText(text: "Change Password"),
            onTap: () {
              if (authController.isLoggedIn.value) navigate(type: PageType.to, page: const ChangePasswordPage());
            },
            trailing: Obx(() {
              return !authController.isLoggedIn.value ? MembersOnlyChip() : SizedBox();
            }),
          ),
          // dividerCommon(color: AppColors.kSkyLightDullColor),
          /* +++ COMMENTING THIS PART TO GET A BUILD WITHOUT THESE SECTIONS +++ */
          /* + Membership Details Page Tile + */
          // ListTile(
          //   leading: const Icon(
          //     Icons.card_membership_rounded,
          //     color: AppColors.kBlackColor,
          //   ),
          //   title: const MyText(text: "Membership"),
          //   onTap: () {
          //     navigate(type: PageType.to, page: const MembershipInfoPage());
          //   },
          // ),
          dividerCommon(color: AppColors.kSkyLightDullColor),
          /* + Promotions Page Tile + */
          ListTile(
            leading: const Icon(
              Icons.chat_outlined,
              color: AppColors.kBlackColor,
            ),
            title: const MyText(text: "Promotions"),
            onTap: () {
              if (authController.isLoggedIn.value) navigate(type: PageType.to, page: const UserPromotionsPage());
            },
            trailing: Obx(() {
              return !authController.isLoggedIn.value ? MembersOnlyChip() : SizedBox();
            }),
          ),
          dividerCommon(color: AppColors.kSkyLightDullColor),

          Obx(() {
            if (!authController.isLoggedIn.value) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // MyText(
                  //   text: "Members Only Area",
                  //   fontWeight: FontWeight.bold,
                  //   fontSize: 22,
                  //   // paddingLeft: 20,
                  //   // paddingRight: 20,
                  //   paddingTop: 20,
                  //   // paddingBottom: 5,
                  //   align: TextAlign.center,
                  // ),
                  MyText(
                    text: "Members only pages are only accessible by our members",
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    paddingLeft: 50,
                    paddingRight: 50,
                    paddingTop: 25,
                    // paddingBottom: 15,
                    align: TextAlign.center,
                  ),

                  SizedBox(height: 24),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        navigate(
                          type: PageType.offAll,
                          page: const LoginPage(
                            allowBackIcon: true,
                          ),
                        ); // Navigate to login
                      },
                      icon: Icon(Icons.lock),
                      label: MyText(
                        text: 'Login Here',
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        backgroundColor: AppColors.kButtonRedColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Align(
                    alignment: Alignment.center,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        navigate(
                          type: PageType.to,
                          page: SignupPage(allowBack: true),
                        ); // Navigate to signup
                      },
                      icon: Icon(
                        Icons.edit,
                        color: AppColors.kButtonRedColor,
                      ),
                      label: MyText(
                        text: 'Sign Up Now',
                        color: AppColors.kButtonRedColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),

                  /* + 🔒 Already a member? Login here to access your account. + */
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5, top: 20),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Expanded(
                  //         child: RichText(
                  //           maxLines: 10,
                  //           textAlign: TextAlign.center,
                  //           text: TextSpan(
                  //             text: "🔒 Already a member? ",
                  //             style: TextStyle(
                  //               color: Colors.black,
                  //               fontWeight: FontWeight.bold,
                  //               fontSize: 18,
                  //               fontFamily: GoogleFonts.poppins().fontFamily,
                  //             ),
                  //             children: [
                  //               TextSpan(
                  //                 text: "Login here",
                  //                 recognizer: TapGestureRecognizer()
                  //                   ..onTap = () {
                  //                     navigate(
                  //                       type: PageType.offAll,
                  //                       page: const LoginPage(),
                  //                     );
                  //                   },
                  //                 style: TextStyle(
                  //                   color: Colors.blue,
                  //                   fontWeight: FontWeight.w600,
                  //                   decoration: TextDecoration.underline,
                  //                   fontSize: 18,
                  //                   fontFamily: GoogleFonts.poppins().fontFamily,
                  //                 ),
                  //               ),
                  //               TextSpan(
                  //                 text: " to access your account. ",
                  //                 style: TextStyle(
                  //                   color: Colors.black,
                  //                   fontWeight: FontWeight.normal,
                  //                   fontSize: 18,
                  //                   fontFamily: GoogleFonts.poppins().fontFamily,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  /* + 📝 New here? Sign up now and join our community! + */
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5, top: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Expanded(
                  //         child: RichText(
                  //           maxLines: 10,
                  //           textAlign: TextAlign.center,
                  //           text: TextSpan(
                  //             text: "📝 New here? ",
                  //             style: TextStyle(
                  //               color: Colors.black,
                  //               fontWeight: FontWeight.bold,
                  //               fontSize: 18,
                  //               fontFamily: GoogleFonts.poppins().fontFamily,
                  //             ),
                  //             children: [
                  //               TextSpan(
                  //                 text: "Sign up now",
                  //                 recognizer: TapGestureRecognizer()
                  //                   ..onTap = () {
                  //                     navigate(
                  //                       type: PageType.offAll,
                  //                       page: SignupPage(),
                  //                     );
                  //                   },
                  //                 style: TextStyle(
                  //                   color: Colors.blue,
                  //                   fontWeight: FontWeight.w600,
                  //                   decoration: TextDecoration.underline,
                  //                   fontSize: 18,
                  //                   fontFamily: GoogleFonts.poppins().fontFamily,
                  //                 ),
                  //               ),
                  //               TextSpan(
                  //                 text: " and join our community!",
                  //                 style: TextStyle(
                  //                   color: Colors.black,
                  //                   fontWeight: FontWeight.normal,
                  //                   fontSize: 18,
                  //                   fontFamily: GoogleFonts.poppins().fontFamily,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  /* */
                  // MyButton(
                  //   text: "Login",
                  //   width: Get.width * 0.7,
                  //   padding: 10,
                  //   marginBottom: 10,
                  //   color: AppColors.kButtonRedColor,
                  //   onPressed: () {
                  //     hideKeyboard(context);
                  //     navigate(
                  //       type: PageType.offAll,
                  //       page: const LoginPage(),
                  //     );
                  //   },
                  // ),
                  // MyText(
                  //   text: "Or sign-up!",
                  //   fontWeight: FontWeight.normal,
                  //   fontSize: 16,
                  //   paddingLeft: 20,
                  //   paddingRight: 20,
                  //   paddingTop: 20,
                  //   paddingBottom: 15,
                  //   align: TextAlign.center,
                  // ),
                  // MyButton(
                  //   text: "Sign up",
                  //   width: Get.width * 0.7,
                  //   padding: 10,
                  //   marginBottom: 10,
                  //   color: AppColors.kButtonRedColor,
                  //   onPressed: () {
                  //     hideKeyboard(context);
                  //     navigate(
                  //       type: PageType.offAll,
                  //       page: SignupPage(),
                  //     );
                  //   },
                  // ),
                ],
              );
            } else {
              return SizedBox();
            }
          }),
        ],
      ),
    );
  }
}
