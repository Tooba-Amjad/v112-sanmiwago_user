import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_constants.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/services/pusher/order_wait_helper.dart';
import 'package:sanmiwago_user/services/pusher/pusher_service.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class WaitingPage extends StatefulWidget {
  final String orderId;
  final OrderWaitFlow flow;
  final String invoiceNumber;
  final String offerId;
  final String offerRestaurantId;

  const WaitingPage({
    Key? key,
    required this.orderId,
    required this.flow,
    this.invoiceNumber = '',
    this.offerId = '',
    this.offerRestaurantId = '',
  }) : super(key: key);

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  StreamSubscription<String>? _pusherSubscription;
  Timer? _timeoutTimer;
  Timer? _autoLeaveTimer;
  bool _showTimeoutMessage = false;
  bool _isHandlingExit = false;

  Duration get _waitTimeout => AppConstants.missedOrderTimeLimit + const Duration(minutes: 1);

  @override
  void initState() {
    super.initState();
    _startListening();
    _startTimeoutTimer();
  }

  void _startListening() {
    final buffered = PusherService.instance.terminalStatusFor(widget.orderId);
    if (buffered != null && OrderWaitHelper.isTerminalStatus(buffered)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_handleTerminalStatus(buffered));
      });
      return;
    }

    _pusherSubscription = PusherService.instance.statusStream.listen((status) {
      if (!mounted || _isHandlingExit) return;
      if (OrderWaitHelper.isTerminalStatus(status)) {
        unawaited(_handleTerminalStatus(status));
      }
    });
  }

  void _startTimeoutTimer() {
    _timeoutTimer = Timer(_waitTimeout, () {
      unawaited(_onWaitTimeout());
    });
  }

  Future<void> _onWaitTimeout() async {
    if (!mounted || _isHandlingExit) return;
    _isHandlingExit = true;
    _timeoutTimer?.cancel();
    _pusherSubscription?.cancel();

    await PusherService.instance.disconnect();

    try {
      final value = await apiController.getOrderViewData(widget.orderId);
      if (!mounted) return;

      final status = value?.order.status.toString() ?? '';
      if (OrderWaitHelper.isTerminalStatus(status)) {
        await _handleTerminalStatus(status, disconnectFirst: false);
        return;
      }
    } catch (e, st) {
      log('WaitingPage: timeout order-view failed: $e', stackTrace: st);
    }

    if (!mounted) return;
    setState(() {
      _showTimeoutMessage = true;
    });

    _autoLeaveTimer = Timer(const Duration(seconds: 15), () {
      if (mounted) {
        _leaveAfterTimeout();
      }
    });
  }

  Future<void> _handleTerminalStatus(String status, {bool disconnectFirst = true}) async {
    if (_isHandlingExit && disconnectFirst) return;
    _isHandlingExit = true;
    _timeoutTimer?.cancel();
    _autoLeaveTimer?.cancel();
    _pusherSubscription?.cancel();

    if (disconnectFirst) {
      await PusherService.instance.disconnect();
    }

    // Hydrate order details (invoice, etc.) before navigating to result pages.
    try {
      await apiController.getOrderViewData(widget.orderId);
    } catch (e, st) {
      log('WaitingPage: getOrderViewData before navigate failed: $e', stackTrace: st);
    }

    if (!mounted) return;

    final invoice = widget.invoiceNumber.isNotEmpty
        ? widget.invoiceNumber
        : orderController.selectedOrderData.value.order.invoiceNumber;
    final orderId = widget.orderId.isNotEmpty
        ? widget.orderId
        : orderController.selectedOrderData.value.order.orderId;

    await OrderWaitHelper.navigateForStatus(
      status: status,
      flow: widget.flow,
      orderId: orderId,
      invoiceNumber: invoice,
      offerId: widget.offerId,
      offerRestaurantId: widget.offerRestaurantId,
    );
  }

  void _leaveAfterTimeout() {
    if (!mounted) return;
    _autoLeaveTimer?.cancel();
    OrderWaitHelper.navigateAfterTimeout(flow: widget.flow);
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _autoLeaveTimer?.cancel();
    _pusherSubscription?.cancel();
    if (!_isHandlingExit) {
      unawaited(PusherService.instance.disconnect());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.kSkyLightDullColor,
        appBar: simpleAppBar(
          title: _showTimeoutMessage ? 'Confirmation timed out' : 'Waiting...',
          haveBackIcon: false,
        ),
        body: _showTimeoutMessage ? _buildTimeoutBody() : _buildWaitingBody(),
      ),
    );
  }

  Widget _buildWaitingBody() {
    return MyFormPage(
      pageTopPadding: Get.height * 0.23,
      children: const [
        Center(
          child: MyText(
            text: 'Waiting for order confirmation',
            align: TextAlign.center,
            fontSize: 24,
            paddingTop: 40,
            paddingBottom: 20,
            paddingLeft: 10,
            paddingRight: 10,
          ),
        ),
        Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: AppColors.kLogoBasedColor,
          ),
        ),
        Center(
          child: MyText(
            text: 'Please do not leave this page. You will be redirected when we receive confirmation',
            align: TextAlign.center,
            fontSize: 14,
            paddingTop: 20,
            paddingBottom: 40,
            paddingLeft: 10,
            paddingRight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeoutBody() {
    final message = widget.flow == OrderWaitFlow.subscription
        ? "We couldn't confirm your order in time. Please check with staff or try again from Subscriptions."
        : "We couldn't confirm your order in time. Please check your orders or try again.";

    return MyFormPage(
      pageTopPadding: Get.height * 0.18,
      children: [
        Center(
          child: MyText(
            text: message,
            align: TextAlign.center,
            fontSize: 18,
            paddingTop: 40,
            paddingBottom: 30,
            paddingLeft: 16,
            paddingRight: 16,
          ),
        ),
        Center(
          child: MyButton(
            text: 'Go Back',
            width: Get.width - 48,
            onPressed: _leaveAfterTimeout,
          ),
        ),
      ],
    );
  }
}
