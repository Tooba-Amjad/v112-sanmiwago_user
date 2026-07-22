import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_constants.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/views/widgets/my_listtile.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

class MyPointsContainer extends StatelessWidget {
  const MyPointsContainer({
    super.key,
    required this.orderId,
    required this.invoiceId,
    required this.dateTime,
    required this.type,
    required this.amount,
    required this.description,
  });

  final String orderId;
  final String invoiceId;
  final String dateTime;
  final String type;
  final String description;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: AppColors.kSkyLightDullColor, width: 2)),
      child: MyListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        title: RichText(
          text: TextSpan(
            text: type,
            style: TextStyle(
              color: getColour(type),
              fontSize: 16,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            children: [
              TextSpan(
                text: description.contains("registration") ? "" : " (${invoiceId.isNotEmpty ? "Invoice #: $invoiceId" : "Order #: $orderId"})",
                // text: description.contains("registration") ? "" : " (Order #: $id)",
                style: TextStyle(
                  color: AppColors.kGreyColor2,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
            ],
          ),
        ),
        subtitle: MyText(
          text: "$description ${description.contains("registration") ? "" : "(${invoiceId.isNotEmpty ? "Invoice #: $invoiceId" : "Order #: $orderId"})"} On ${AppConstants.dateFormatWithTime.format(DateTime.parse(dateTime))}",
          // text: "$description ${description.contains("registration") ? "" : "(Order #: $id)"} On ${AppConstants.dateFormatWithTime.format(DateTime.parse(dateTime))}",
          fontSize: 13,
        ),
        trailing: MyText(
          text: "${type == "Redeem" || type == "Reversed" ? "-" : "+"}$amount",
          color: getColour(type),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        trailingTopPadding: 20,
      ),
    );
  }
}
