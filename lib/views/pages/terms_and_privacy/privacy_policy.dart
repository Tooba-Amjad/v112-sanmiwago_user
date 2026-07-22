import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/views/pages/terms_and_privacy/terms_of_use.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  WebViewController controller = WebViewController();

  RxInt loadingProgress = 0.obs;

  String loadedHtml = "";

  @override
  void initState() {
    super.initState();

    apiController.getPrivacyHtml().then((html) {
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
    //   ..loadRequest(Uri.parse('https://sanmiwagomeals.com/api/page/show?slug=privacy-policy'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSkyLightDullColor,
      appBar: simpleAppBar(
        title: "Privacy Policy",
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
                      key: ValueKey("Privacy-Html"),
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
                      onTapUrl: (url) async {
                        log("url: $url");
                        if (url.contains("/api/page/show?slug=terms-conditions")) {
                          log("inside if it's terms of use link");
                          navigate(type: PageType.to, page: TermsOfUsePage());
                          return true;
                        } else {
                          return false;
                        }
                      },
                    ),
                  )
                //     ? ScrollConfiguration(
                //   behavior: MyCustomScrollBehavior(),
                //   child: ListView(
                //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                //     children: [
                //       HtmlWidget(
                //         loadedHtml,
                //         onLoadingBuilder: (context, element, loadingProgress) {
                //           return SizedBox(
                //             height: Get.height,
                //             width: Get.width,
                //             child: const Center(
                //               child: CircularProgressIndicator(
                //                 color: AppColors.kLogoBasedColor,
                //               ),
                //             ),
                //           );
                //         },
                //         onTapUrl: (url) async {
                //           log("url: $url");
                //           if (url.contains("/api/page/show?slug=terms-conditions")) {
                //             log("inside if it's terms of use link");
                //             navigate(type: PageType.to, page: TermsOfUsePage());
                //             return false;
                //           } else {
                //             return true;
                //           }
                //         },
                //       ),
                //     ],
                //   ),
                // )
                : const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kLogoBasedColor,
                    ),
                  ),
            //     : ListView(
            //   children: [
            //     SizedBox(
            //       height: Get.height,
            //       width: Get.width,
            //       child: const Center(
            //         child: CircularProgressIndicator(
            //           color: AppColors.kLogoBasedColor,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ),
        ],
      ),
    );
  }
}
