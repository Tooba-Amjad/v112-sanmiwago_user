// import 'dart:developer';

// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:get/get.dart';

class DynamicLinkHandler {

  // static Future<void> initDynamicLink() async {
  //   log("init dynamic link");
  //   FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
  //     log("in link capture");
  //     final Uri deepLink = dynamicLinkData.link;
  //     bool isMenu = deepLink.pathSegments.contains("menu");
  //     bool isRegister = deepLink.pathSegments.contains("register");
  //     log("pathSegments: ${deepLink.pathSegments}");
  //     log("isRegister: $isRegister");
  //
  //     if (isMenu) {
  //       String? id = deepLink.queryParameters['id'];
  //       log("id in isMenu: $id");
  //       try {
  //         if (id != "") {
  //           // await ffstore.collection(vehiclesCollection).doc(id).get().then((value) {
  //           //   Get.to(() => VehicleDetails(publishingModel: PublishingModel.fromJson(value.data() ?? {}), vehicleId: ''));
  //           // });
  //         } else {
  //           log("id was empty");
  //         }
  //       } catch (e) {
  //         log("Error in fetching the post model and going to post doc: $e");
  //       }
  //     } else if (isRegister) {
  //       String? groupId = deepLink.queryParameters['id'];
  //       log("groupId in isRegister: $groupId");
  //
  //       try {
  //         if (groupId != "") {
  //           // loading();
  //           //+ change collection name
  //           // await ffstore.collection(userCollection).doc(groupId).update({
  //           //   "notDeletedFor": FieldValue.arrayUnion([auth.currentUser?.uid]),
  //           //   "users": FieldValue.arrayUnion([auth.currentUser?.uid]),
  //           // });
  //           //+/change collection name
  //
  //           // await groupChatController.getAGroupChatRoomInfo(groupId!).then((value) {
  //           //   Get.back();
  //           //   Get.to(() => GroupChat(docs: value.data()));
  //           // });
  //
  //         } else {
  //           log("groupId was empty");
  //         }
  //       } catch (e) {
  //         log("Error in fetching the Group chat info and going to Group chat page is doc: $e");
  //       }
  //     }
  //   }).onError((error) {
  //     log("Error in listening to onLink is: ${error.toString()}");
  //     // Handle errors
  //   });
  //
  //   final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
  //
  //   if (initialLink != null) {
  //     final Uri deepLink = initialLink.link;
  //     bool isPost = deepLink.pathSegments.contains("posts");
  //     bool isGroupInvite = deepLink.pathSegments.contains("groupInvite");
  //     log("pathSegments: ${deepLink.pathSegments}");
  //     log("isRegister: ${isGroupInvite}");
  //
  //     if (isPost) {
  //       String? id = deepLink.queryParameters['id'];
  //       log("id in isMenu: $id");
  //
  //       try {
  //         if (id != "") {
  //           //+/change collection name
  //
  //           // await ffstore.collection(postsCollection).doc(id).get().then((value) {
  //           //   Get.to(() => PostDetails(postDocModel: AddPostModel.fromJson(value.data() ?? {})));
  //           // });
  //           ///yahan TAK
  //         } else {
  //           log("id was empty");
  //         }
  //       } catch (e) {
  //         log("Error in fetching the post model and going to post doc: $e");
  //       }
  //     } else if (isGroupInvite) {
  //       String? groupId = deepLink.queryParameters['id'];
  //       log("groupId in isRegister: $groupId");
  //
  //       try {
  //         if (groupId != "") {
  //           // loading();
  //           //+/change collection name
  //
  //           // await ffstore.collection(groupChatCollection).doc(groupId).update({
  //           //   "notDeletedFor": FieldValue.arrayUnion([auth.currentUser?.uid]),
  //           //   "users": FieldValue.arrayUnion([auth.currentUser?.uid]),
  //           // });
  //           // await groupChatController.getAGroupChatRoomInfo(groupId!).then((value) {
  //           //   Get.back();
  //           //   Get.to(() => GroupChat(docs: value.data()));
  //           // });
  //
  //           ///YAHAN TAK
  //         } else {
  //           log("groupId was empty");
  //         }
  //       } catch (e) {
  //         log("Error in fetching the Group chat info and going to Group chat page is doc: $e");
  //       }
  //     }
  //   }
  // }
  /* */
  //+ unused for now
  // static Future<String> buildDynamicLinkForPost(
//   //     {required String postTitle, required String postImageUrl, required String postId, bool short = false}) async {
//   //   String url = "https://carpeak.page.link";
//   //   final DynamicLinkParameters parameters = DynamicLinkParameters(
//   //     uriPrefix: url,
//   //     link: Uri.parse('$url/posts?id=$postId'),
//   //     androidParameters: AndroidParameters(
//   //       packageName: "com.carpeak.car_peak",
//   //       minimumVersion: 0,
//   //     ),
//   //     iosParameters: IOSParameters(
//   //       bundleId: "com.carpeak.carPeak",
//   //       minimumVersion: '0',
//   //     ),
//   //     socialMetaTagParameters: SocialMetaTagParameters(
//   //       description: '',
//   //       imageUrl: Uri.parse("$postImageUrl"),
//   //       title: postTitle,
//   //     ),
//   //   );
//   //
//   //   String finalUrl = "";
//   //   if (short) {
//   //     final ShortDynamicLink dynamicUrl = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
//   //     finalUrl = dynamicUrl.shortUrl.toString();
//   //     log("generated short-url is: $finalUrl");
//   //   } else {
//   //     final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(parameters);
//   //     finalUrl = dynamicLink.toString();
//   //     log("generated long-url is: $finalUrl");
//   //   }
//   //   log("generated url before return is: $finalUrl");
//   //   return finalUrl;
//   // }
//   //
//   // static Future<String> buildDynamicLinkGroupInvite({
//   //   required String groupName,
//   //   required String groupInviteMessage,
//   //   required String groupImage,
//   //   required String groupId,
//   //   bool short = false,
//   // }) async {
//   //   String url = "https://vippicnicsharing.page.link";
//   //   final DynamicLinkParameters parameters = DynamicLinkParameters(
//   //     uriPrefix: url,
//   //     link: Uri.parse('$url/groupInvite?id=$groupId'),
//   //     androidParameters: AndroidParameters(
//   //       packageName: "com.vippicnic.vip_picnic",
//   //       minimumVersion: 0,
//   //     ),
//   //     iosParameters: IOSParameters(
//   //       bundleId: "com.vippicnic.vipPicnic",
//   //       minimumVersion: '0',
//   //     ),
//   //     socialMetaTagParameters: SocialMetaTagParameters(
//   //       description: groupInviteMessage,
//   //       imageUrl: Uri.parse("$groupImage"),
//   //       title: groupName,
//   //     ),
//   //   );
//   //
//   //   String finalUrl = "";
//   //   if (short) {
//   //     final ShortDynamicLink dynamicUrl = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
//   //     finalUrl = dynamicUrl.shortUrl.toString();
//   //     log("generated short-url for group invite is: $finalUrl");
//   //   } else {
//   //     final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(parameters);
//   //     finalUrl = dynamicLink.toString();
//   //     log("generated long-url  for group invite is: $finalUrl");
//   //   }
//   //   log("generated url before return  for group invite is: $finalUrl");
//   //   return finalUrl;
//   // }
}
