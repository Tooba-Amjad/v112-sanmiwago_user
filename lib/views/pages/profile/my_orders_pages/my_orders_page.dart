import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/constants/my_logger.dart';
import 'package:sanmiwago_user/models/my_orders_model.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/views/pages/login/login_page.dart';
import 'package:sanmiwago_user/views/pages/profile/my_orders_pages/my_order_container.dart';
import 'package:sanmiwago_user/views/pages/signup/signup_page.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class MyOrdersPage extends StatefulWidget {
  final bool isFromBottomNavBar;

  const MyOrdersPage({super.key, this.isFromBottomNavBar = false});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  ScrollController myOrdersListScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      myOrdersListScrollController.addListener(() {
        if (myOrdersListScrollController.position.maxScrollExtent == myOrdersListScrollController.offset) {
          apiController.getMyOrdersList();
        }
      });

      // if (myOrdersController.myOrdersList.isEmpty) {
      apiController.isLoadingMyOrders.value = true;
      myOrdersController.myOrdersList.clear();
      apiController.getMyOrdersList(enforceOffset: true);

      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: "My Orders",
        haveBackIcon: widget.isFromBottomNavBar == true ? false : true,
        haveDrawerIcon: widget.isFromBottomNavBar ? true : false,
      ),
      body: Obx(() {
        if (authController.isLoggedIn.value) {
          if (myOrdersController.myOrdersList.isNotEmpty) {
            return EasyRefresh(
              onRefresh: () {
                apiController.isLoadingMyOrders.value = true;
                myOrdersController.myOrdersList.clear();
                apiController.getMyOrdersList(enforceOffset: true);
              },
              child: ListView.builder(
                itemCount: myOrdersController.myOrdersList.length + 1,
                controller: myOrdersListScrollController,
                itemBuilder: (BuildContext context, int index) {
                  if (index < myOrdersController.myOrdersList.length) {
                    MyOrder order = myOrdersController.myOrdersList[index];
                    return MyOrderContainer(
                      id: order.orderId,
                      status: order.status,
                      price: order.totalCost,
                      paymentType: order.paymentType,
                      isPointRedeemed: order.isPointsRedeemed,
                      dateTime: order.dateCreated,
                      order: order,
                    );
                  } else {
                    if (myOrdersController.myOrdersList.length < 10) {
                      return const SizedBox();
                    } else {
                      return Obx(() {
                        if (!apiController.isLoadingMyOrders.value) {
                          infoLog("My order page ${apiController.isLoadingMyOrders.value}");
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(child: MyText(text: "No more data to show".tr)),
                          );
                        }
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                color: AppColors.kLogoBasedColor,
                              ),
                            ),
                          ),
                        );
                      });
                    }
                  }
                },
              ),
            );
          } else if (apiController.isLoadingMyOrders.value) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.kLogoBasedColor,
              ),
            );
          } else {
            return const Center(
              child: MyText(
                text: "No data to show",
                fontSize: 16,
              ),
            );
          }
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              MyText(
                text: "Members Only Area",
                fontWeight: FontWeight.bold,
                fontSize: 22,
                // paddingLeft: 20,
                // paddingRight: 20,
                // paddingTop: 20,
                // paddingBottom: 5,
                align: TextAlign.center,
              ),
              MyText(
                text: "Oops! It looks like this page is for members only.",
                fontWeight: FontWeight.w500,
                fontSize: 18,
                paddingLeft: 50,
                paddingRight: 50,
                paddingTop: 5,
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
        }
      }),
    );
  }
}
