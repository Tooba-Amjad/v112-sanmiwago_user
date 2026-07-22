import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/order_view_model.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

class MyOrderDetailsItemWidget extends StatelessWidget {
  const MyOrderDetailsItemWidget({
    Key? key,
    required this.index,
    required this.orderItem,
    required this.totalItemPrice,
  }) : super(key: key);

  final int index;
  final OrderItem orderItem;
  final double totalItemPrice;

  @override
  Widget build(BuildContext context) {
    // print('GOT REBUILT and ${cartItem.toJson()} in ${ cartItem.itemName}');
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //+ title and price
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: MyText(
                                      text: orderItem.itemName,
                                      color: AppColors.kBlackColor,
                                      fontSize: 20,
                                    ),
                                    // RichText(
                                    //   maxLines: 100,
                                    //   overflow: TextOverflow.ellipsis,
                                    //   text: TextSpan(
                                    //     text: cartItem.itemName,
                                    //     // style: DefaultTextStyle.of(context).style,
                                    //     style: const TextStyle(
                                    //       color: AppColors.kGreyColor,
                                    //       fontSize: 20,
                                    //     ),
                                    //     children: const <TextSpan>[
                                    //       TextSpan(
                                    //         text: " (cartItem.sizeWords)",
                                    //         style: TextStyle(
                                    //           fontWeight: FontWeight.normal,
                                    //           fontSize: 14,
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              //Price
                              // (cartItem.normalPrice == cartItem.discountedPrice) ?
                              MyText(
                                text: "\$${(((double.tryParse(orderItem.itemCost) ?? 0.0) * (double.tryParse(orderItem.itemQty) ?? 0.0)) - (double.tryParse(orderItem.sizePrice) ?? 0.0)).toPrecision(2).toStringAsFixed(2)}",
                                align: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                color: AppColors.kBlackColor,
                                fontSize: 18,
                              ),
                              // : Column(
                              //     children: [
                              //       const MyText(
                              //         text: "totalItemPriceBasedOnNormalPrice",
                              //         maxLines: 1,
                              //         overflow: TextOverflow.ellipsis,
                              //         color: AppColors.kGreyColor,
                              //         fontSize: 17,
                              //         decoration: TextDecoration.lineThrough,
                              //       ),
                              //       const SizedBox(width: 5),
                              //       MyText(
                              //         text: (totalItemPrice.toStringAsFixed(2)),
                              //         maxLines: 1,
                              //         overflow: TextOverflow.ellipsis,
                              //         color: AppColors.kRedColor,
                              //         fontSize: 17,
                              //       )
                              //     ],
                              //   )
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),
                    Row(
                      children: [
                        //+ decrease quantity
                        /* */
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          child: const MyText(
                            text: "Quantity: ",
                            style: TextStyle(
                              color: AppColors.kGreyColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        //+ Quantity text
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          child: MyText(
                            text: orderItem.itemQty,
                            color: AppColors.kBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            paddingLeft: 10,
                            paddingRight: 10,
                          ),
                        ),
                      ],
                    ),
                    // sizedBoxCustom(12),
                    const SizedBox(height: AppSizes.formsSizeBoxHeight / 2),

                    orderItem.sizeName.isNotEmpty
                        ? Row(
                            children: [
                              Expanded(
                                child: RichText(
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    text: "Option: ",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: orderItem.sizeName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // MyText(
                                //   text: 'Option: ${cartItem.options.first.optionName}',
                                //   align: TextAlign.left,
                                // ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    MyText(
                                      text: "+\$${((double.tryParse(orderItem.sizePrice) ?? 0.0) * (double.tryParse(orderItem.itemQty) ?? 0.0)).toPrecision(2).toStringAsFixed(2)}",
                                      align: TextAlign.left,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        : const SizedBox(),
                    // cartItem.orderNotes.isNotEmpty
                    Visibility(
                      visible: orderItem.specialInstruction.isNotEmpty,
                      child: Row(
                        children: [
                          Expanded(
                              child: RichText(
                            maxLines: 5,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: "Instructions: ",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 15,
                              ),
                              children: [
                                TextSpan(
                                  text: orderItem.specialInstruction.trim(),
                                  style: const TextStyle(
                                    // fontWeight: FontWeight.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          )
                              // MyText(
                              //   text: 'Instructions: ${cartItem.note}',
                              //   fontSize: 15,
                              //   align: TextAlign.left,
                              //   color: Colors.red,
                              //   fontWeight: FontWeight.w500,
                              // ),
                              ),
                        ],
                      ),
                    ),
                    // Add ons
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: myOrdersController.selectedOrderData.value.addons.where((addon) => addon.opId == orderItem.opId).length,
                      itemBuilder: (BuildContext context, int index) {
                        OrderAddon addon = myOrdersController.selectedOrderData.value.addons.where((addon) => addon.opId == orderItem.opId).toList()[index];
                        // List<String> subItem =
                        //     cartItem.subItem.values.map((e) => List<String>.from(e)).toList()[index];
                        // MenuItemAddon addon = cartItem.addons[index];
                        // List<String> addonQty = List<String>.from(cartItem.addonQty?[addonId] ?? []);
                        // List<String> subItemSeparated = subItem.split("|");
                        return Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              // const Icon(
                              //   Icons.circle,
                              //   size: 10,
                              //   color: Colors.grey,
                              // ),
                              // const SizedBox(
                              //   width: 9,
                              // ),
                              MyText(
                                text: addon.quantity,
                                color: AppColors.kGreyColor,
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                paddingLeft: 5,
                                paddingRight: 0,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Icon(
                                Icons.close,
                                size: 10,
                                color: AppColors.kGreyColor2,
                                // color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 0,
                              ),
                              // for(int addonQtyIndex =0; addonQtyIndex < addonQty.length; addonQtyIndex++)
                              Expanded(
                                flex: 2,
                                child: MyText(
                                  text: addon.addonName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  align: TextAlign.left,
                                ),
                              ),

                              //Addon price
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    MyText(
                                      text: "+\$${addon.finalCost}",
                                      // text: "+\$${addon.price}",
                                      align: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    // sizedBoxCustom(6),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              const Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MyText(
                      text: "Item total:",
                      align: TextAlign.right,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MyText(
                      text: "\$${totalItemPrice.toPrecision(2).toStringAsFixed(2)}",
                      align: TextAlign.right,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
