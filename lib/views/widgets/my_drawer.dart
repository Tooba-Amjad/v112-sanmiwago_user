import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_images.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/data/shared_pref.dart';
import 'package:sanmiwago_user/generated/assets.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/views/pages/about/about_page.dart';
import 'package:sanmiwago_user/views/pages/contact/contact_us.dart';
import 'package:sanmiwago_user/views/pages/giftcard/giftcard_page.dart';
import 'package:sanmiwago_user/views/pages/home/home_menu_page.dart';
import 'package:sanmiwago_user/views/pages/login/login_page.dart';
import 'package:sanmiwago_user/views/pages/restaurants_list/restaurants_list_page.dart';
import 'package:sanmiwago_user/views/pages/subscriptions/my_subscriptions_page.dart';
import 'package:sanmiwago_user/views/pages/subscriptions/subscription_offers_page.dart';
import 'package:sanmiwago_user/views/pages/terms_and_privacy/privacy_policy.dart';
import 'package:sanmiwago_user/views/pages/terms_and_privacy/terms_of_use.dart';
import 'package:sanmiwago_user/views/widgets/image_related_builders.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.kLogoBasedColor),
            child: authController.userData.value.userId.isNotEmpty
                ? ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CircleAvatar(
                          radius: 30,
                          // backgroundImage: const AssetImage(AppImages.userIcon),
                          child: authController.userData.value.photo.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    height: 55,
                                    width: 55,
                                    imageUrl: authController.userData.value.photo,
                                    progressIndicatorBuilder: (context, url, progress) {
                                      return MyCachedImageLoadingBuilder(
                                        height: 30,
                                        width: 30,
                                        loadingProgress: progress.progress ?? 0,
                                      );
                                    },
                                    errorWidget: (context, url, error) => MyImageErrorBuilder(
                                      height: 20,
                                      width: 20,
                                      widget: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          AppImages.userIcon,
                                        ),
                                      ),
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : Image.asset(
                                  AppImages.userIcon,
                                  height: 40,
                                  width: 40,
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      authController.userData.value.firstName.isNotEmpty || authController.userData.value.lastName.isNotEmpty
                          ? MyText(
                              text: "${authController.userData.value.firstName} ${authController.userData.value.lastName}",
                              color: Colors.white,
                              fontSize: 18,
                            )
                          : const SizedBox(),
                      authController.userData.value.email.isNotEmpty
                          ? MyText(
                              text: authController.userData.value.email,
                              color: Colors.white70,
                              fontSize: 14,
                            )
                          : const SizedBox(),
                    ],
                  )
                : const SizedBox(),
          ),
          /* + Home + */
          // authController.isLoggedIn.value
          //     ? SizedBox()
          //     : ListTile(
          //         leading: const Icon(Icons.home),
          //         title: const MyText(text: 'Menu'),
          //         onTap: () {
          //           // Handle home navigation
          //           drawerController.closeDrawer();
          //           if (Get.currentRoute != "/HomeMenuPage") {
          //             navigate(
          //               type: PageType.offAll,
          //               page: const HomeMenuPage(),
          //             );
          //           }
          //         },
          //       ),
          /* + My Account + */
          // authController.isLoggedIn.value
          //     ? ListTile(
          //         leading: const Icon(Icons.perm_identity_rounded),
          //         title: const MyText(text: 'My Account'),
          //         onTap: () {
          //           drawerController.closeDrawer();
          //           // Handle settings navigation
          //           // Get.to(() => const ProfileMenuPage());
          //           navigate(type: PageType.to, page: const ProfileMenuPage());
          //         },
          //       )
          //     : const SizedBox(),
          ListTile(
            leading: const Icon(Icons.card_giftcard_rounded),
            title: const MyText(text: 'Gift Card'),
            onTap: () {
              drawerController.closeDrawer();
              // Handle settings navigation
              giftCardController.getGiftCards();
              navigate(type: PageType.to, page: const GiftCardPage());
            },
          ),
          /* + Offers + */
          // !authController.isLoggedIn.value
          //     ? ListTile(
          //         leading: const Icon(Icons.subtitles_sharp),
          //         title: const MyText(text: 'Offers'),
          //         onTap: () {
          //           drawerController.closeDrawer();
          //           // subscriptionsController.getSubscriptionOffers();
          //           navigate(type: PageType.to, page: const SubscriptionsPage());
          //         },
          //       )
          //     : const SizedBox(),
          // authController.isLoggedIn.value
          //     ? ListTile(
          //         leading: const Icon(
          //           FontAwesomeIcons.dropbox,
          //         ),
          //         title: const MyText(text: 'My Orders'),
          //         onTap: () {
          //           drawerController.closeDrawer();
          //           // Handle settings navigation
          //           navigate(type: PageType.to, page: const MyOrdersPage());
          //         },
          //       )
          //     : const SizedBox(),
          authController.isLoggedIn.value
              ? ListTile(
                  leading: const Icon(
                    Icons.subtitles_sharp,
                  ),
                  title: const MyText(text: 'My Subscriptions'),
                  onTap: () {
                    drawerController.closeDrawer();
                    // Handle settings navigation
                    navigate(type: PageType.to, page: const MySubscriptionsPage());
                  },
                )
              : const SizedBox(),
          // authController.isLoggedIn.value
          //     ? ListTile(
          //         leading: const Icon(
          //           Icons.account_balance_wallet_rounded,
          //         ),
          //         title: const MyText(text: 'My Points'),
          //         onTap: () {
          //           drawerController.closeDrawer();
          //           // Handle settings navigation
          //           navigate(type: PageType.to, page: const MyPointsPage());
          //         },
          //       )
          //     : const SizedBox(),

          /* ! Commented for moving to production ! */
          /* + Locations + */
          // !authController.isLoggedIn.value
          //     ? ListTile(
          //         leading: const Icon(
          //           Icons.store_mall_directory_outlined,
          //         ),
          //         title: const MyText(text: 'Locations'),
          //         onTap: () {
          //           drawerController.closeDrawer();
          //           // Handle settings navigation
          //           navigate(type: PageType.to, page: const RestaurantsListPage());
          //         },
          //       )
          //     : SizedBox(),
          ListTile(
            leading: const Icon(
              Icons.contact_support_outlined,
            ),
            title: const MyText(text: 'Contact Us'),
            onTap: () {
              drawerController.closeDrawer();
              // Handle settings navigation
              navigate(type: PageType.to, page: const ContactUsPage());
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.info_outline_rounded,
            ),
            title: const MyText(text: 'About'),
            onTap: () {
              drawerController.closeDrawer();
              // Handle settings navigation
              navigate(type: PageType.to, page: const AboutPage());
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.privacy_tip_outlined,
            ),
            title: const MyText(text: 'Privacy Policy'),
            onTap: () {
              drawerController.closeDrawer();
              // Handle settings navigation
              navigate(type: PageType.to, page: const PrivacyPolicyPage());
            },
          ),
          ListTile(
            leading: const ImageIcon(
              AssetImage(
                Assets.iconsTerms,
              ),
              // FontAwesomeIcons.fileContract,
            ),
            title: const MyText(text: 'Terms & Conditions'),
            onTap: () {
              drawerController.closeDrawer();
              // Handle settings navigation
              navigate(type: PageType.to, page: const TermsOfUsePage());
            },
          ),
          Obx(() {
            if (authController.userData.value.email.isNotEmpty) {
              return ListTile(
                leading: const Icon(Icons.logout),
                title: const MyText(text: 'Logout'),
                onTap: () {
                  // Handle logout
                  LocalSharedPrefDatabase.logout();
                  authController.logout();
                  drawerController.closeDrawer();
                },
              );
            }
            return ListTile(
              leading: const Icon(Icons.login_outlined),
              title: const MyText(text: 'Login'),
              onTap: () {
                // Handle login
                navigate(
                  type: PageType.offAll,
                  page: const LoginPage(),
                );
              },
            );
          }),

          // ListTile(
          //   leading: const Icon(
          //     Icons.store_mall_directory_outlined,
          //   ),
          //   title: const MyText(text: 'Locations'),
          //   onTap: () {
          //     drawerController.closeDrawer();
          //     // Handle settings navigation
          //     navigate(type: PageType.to, page: const AutoScrollListView());
          //   },
          // )
        ],
      ),
    );
  }
}
