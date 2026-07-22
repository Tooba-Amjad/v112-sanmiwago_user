import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/views/pages/terms_and_privacy/privacy_policy.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsOfUsePage extends StatefulWidget {
  const TermsOfUsePage({super.key});

  @override
  State<TermsOfUsePage> createState() => _TermsOfUsePageState();
}

class _TermsOfUsePageState extends State<TermsOfUsePage> {
  WebViewController controller = WebViewController();

  RxInt loadingProgress = 0.obs;

  String loadedHtml = '';

  @override
  void initState() {
    super.initState();

    apiController.getTermsHtml().then((html) {
      log("html: ${html.runtimeType}");
      // log("html: $html");
      setState(() {
        loadedHtml = html;
      });
    });

    // controller = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..setNavigationDelegate(
    //     NavigationDelegate(
    //       onProgress: (int progress) {
    //         // Update loading bar.
    //         loadingProgress.value = progress;
    //       },
    //       onPageStarted: (String url) {},
    //       onPageFinished: (String url) {},
    //       onHttpError: (HttpResponseError error) {},
    //       onWebResourceError: (WebResourceError error) {},
    //       onNavigationRequest: (NavigationRequest request) {
    //         if (request.url.startsWith('https://www.youtube.com/')) {
    //           return NavigationDecision.prevent;
    //         }
    //         return NavigationDecision.navigate;
    //       },
    //     ),
    //   )
    //   // ..loadRequest(Uri.parse('https://sanmiwagomeals.com/terms-conditions'));
    //   ..loadRequest(Uri.parse('https://sanmiwagomeals.com/api/page/show?slug=terms-conditions'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSkyLightDullColor,
      appBar: simpleAppBar(
        title: "Terms & Conditions",
        haveBackIcon: true,
        onBackPressed: () async {
          if (await controller.canGoBack()) {
            controller.goBack();
          } else {
            Get.back();
          }
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Obx(() {
          //   return loadingProgress.value != 100
          //       ? SizedBox(
          //           height: 7,
          //           width: MediaQuery.of(context).size.width,
          //           child: LinearProgressIndicator(
          //             minHeight: 5,
          //             backgroundColor: Colors.white,
          //             // color: Color(0xffff7101),
          //             valueColor: AlwaysStoppedAnimation<Color>(AppColors.kBlackColor),
          //             value: loadingProgress / 100,
          //             // color: Colors.white,
          //           ),
          //         )
          //       : const SizedBox();
          // }),
          Expanded(
            // child: WebViewWidget(controller: controller),
            child: loadedHtml.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: HtmlWidget(
                      loadedHtml,
                      key: ValueKey("Terms-Html"),
                      renderMode: RenderMode.listView,
                      onLoadingBuilder: (context, element, loadingProgress) {
                        return SizedBox(
                          height: Get.height,
                          width: Get.width,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.kLogoBasedColor,
                            ),
                          ),
                        );
                      },
                      onTapUrl: (url) {
                        log("url: $url");
                        if (url.contains("/api/page/show?slug=privacy-policy")) {
                          log("inside if it's privacy policy link");
                          navigate(type: PageType.to, page: PrivacyPolicyPage());
                          return true;
                        } else {
                          return false;
                        }
                      },
                    ),
                  )
                // ? ScrollConfiguration(
                //     behavior: MyCustomScrollBehavior(),
                //     child: ListView(
                //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                //       children: [
                //         HtmlWidget(
                //           loadedHtml,
                //           renderMode: RenderMode.listView,
                //           onLoadingBuilder: (context, element, loadingProgress) {
                //             return SizedBox(
                //               height: Get.height,
                //               width: Get.width,
                //               child: const Center(
                //                 child: CircularProgressIndicator(
                //                   color: AppColors.kLogoBasedColor,
                //                 ),
                //               ),
                //             );
                //           },
                //           onTapUrl: (url) {
                //             log("url: $url");
                //             if (url.contains("/api/page/show?slug=privacy-policy")) {
                //               log("inside if it's privacy policy link");
                //               navigate(type: PageType.to, page: PrivacyPolicyPage());
                //               return false;
                //             } else {
                //               return false;
                //             }
                //           },
                //         ),
                //       ],
                //     ),
                //   )
                /* */
                : const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kLogoBasedColor,
                    ),
                  ),
            // : ListView(
            //     children: [
            //       SizedBox(
            //         height: Get.height,
            //         width: Get.width,
            //         child: const Center(
            //           child: CircularProgressIndicator(
            //             color: AppColors.kLogoBasedColor,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
          ),
        ],
      ),
    );
  }
}
