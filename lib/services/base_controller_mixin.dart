import 'dart:developer';

import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';

import 'app_exceptions.dart';

mixin class BaseController {
  void handleError(error, {Function()? onError}) {
    dismissLoading();
    if (error is BadRequestException) {
      var message = error.message;
      log("inside error is BadRequestException");
      log("message: $message");
    } else if (error is FetchDataException) {
      log("inside error is FetchDataException");
      // var message = error.message;
      // showMsg(msg: "No internet please try again".tr + (message ?? ""));
    } else if (error is ApiNotRespondingException) {
      log("inside error is ApiNotRespondingException");
      // showMsg(msg: "Oops! It took longer to respond.");
    } else if (error is FormatException) {
      log("inside error is FormatException and ${error.message}");
      // DialogHelper.showErroDialog(description: 'Oops! It took longer to respond.');
      // showMsg(msg: "Something went wrong please try again");
    } else {
      log("inside error is $error");
    }

    if(onError != null) onError.call();
  }
}
