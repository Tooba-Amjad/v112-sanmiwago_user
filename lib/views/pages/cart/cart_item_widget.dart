import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/double_extensions.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/item_models/item_model.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/widgets/my_cached_network_image.dart';
import 'package:sanmiwago_user/views/widgets/my_dialog.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    Key? key,
    required this.index,
    required this.cartItem,
    required this.totalItemPrice,
  }) : super(key: key);

  final int index;
  final MenuItem cartItem;
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
              //image
              Visibility(
                visible: cartItem.itemImageName.isNotEmpty,
                child: MyCachedNetworkImage(
                  image: cartItem.itemImageName,
                  height: 59,
                  width: 59,
                ),
              ),
              Visibility(
                visible: cartItem.itemImageName.isNotEmpty,
                child: const SizedBox(width: 13),
              ),
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
                                      text: cartItem.itemName,
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
                                height: 6,
                              ),
                              //Price
                              // (cartItem.normalPrice == cartItem.discountedPrice) ?
                              MyText(
                                text: "\$${cartItem.itemCost}",
                                // text: totalItemPrice.toStringAsFixed(2),
                                align: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                color: AppColors.kBlackColor,
                                fontSize: 18,
                              )
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
                        //+ Delete button
                        InkWell(
                          onTap: () {
                            showMyAnimatedDialog(
                              context: context,
                              child: MyNewConfirmDialog(
                                title: "Remove Item?",
                                msg: "The item and all addons and options will be removed",
                                rightButtonText: "Remove",
                                leftButtonText: "Cancel",
                                rightButtonWidth: 110,
                                leftButtonWidth: 110,
                                yesOnPressed: () {
                                  orderController.deleteAnItem(
                                    index: index,
                                    onSuccess: () {
                                      showScaffoldMsg(
                                        context: context,
                                        msg: "Cart item deleted successfully.",
                                        isSuccess: true,
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                            margin: const EdgeInsets.only(left: 7),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.kPrimaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                  size: 29,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    //+ Increase decrease button
                    const SizedBox(height: AppSizes.formsSizeBoxHeight),
                    Row(
                      children: [
                        //+ decrease quantity
                        /* */
                        // Container(
                        //   alignment: Alignment.centerLeft,
                        //   margin: const EdgeInsets.symmetric(horizontal: 0),
                        //   child: const MyText(
                        //     text: "Quantity: ",
                        //     style: TextStyle(
                        //       color: AppColors.kGreyColor,
                        //       fontSize: 18,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                        InkWell(
                          onTap: () {
                            orderController.updateItemCount(
                              index: index,
                              isIncrement: false,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: AppColors.kLightestGreyColor,
                            ),
                            padding: const EdgeInsets.all(9),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.remove,
                              color: AppColors.kBlackColor,
                              size: 19,
                            ),
                          ),
                        ),
                        //+ Quantity text
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          child: MyText(
                            text: cartItem.itemCount.toString(),
                            color: AppColors.kBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            paddingLeft: 10,
                            paddingRight: 10,
                          ),
                        ),
                        //+ increase quantity
                        /* */
                        InkWell(
                          onTap: () {
                            orderController.updateItemCount(
                              index: index,
                              isIncrement: true,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: AppColors.kLightestGreyColor,
                            ),
                            padding: const EdgeInsets.all(9),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.add,
                              color: AppColors.kBlackColor,
                              size: 19,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // sizedBoxCustom(12),
                    const SizedBox(height: AppSizes.formsSizeBoxHeight),

                    cartItem.options.isNotEmpty
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
                                        text: cartItem.options.first.optionName,
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
                                      text: "+\$${cartItem.options.first.price}",
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
                      visible: cartItem.note.isNotEmpty,
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
                                  text: cartItem.note.trim(),
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
                      itemCount: cartItem.addons.length,
                      itemBuilder: (BuildContext context, int index) {
                        var addon = cartItem.addons[index];
                        // List<String> subItem =
                        //     cartItem.subItem.values.map((e) => List<String>.from(e)).toList()[index];
                        // MenuItemAddon addon = cartItem.addons[index];
                        // List<String> addonQty = List<String>.from(cartItem.addonQty?[addonId] ?? []);
                        // List<String> subItemSeparated = subItem.split("|");
                        return Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                size: 10,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 9,
                              ),
                              // for(int addonQtyIndex =0; addonQtyIndex < addonQty.length; addonQtyIndex++)
                              Expanded(
                                child: MyText(
                                  text: addon.addonName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  align: TextAlign.left,
                                ),
                              ),

                              //Addon price
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    MyText(
                                      text: "+\$${addon.price}",
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
                    const SizedBox(height: 6),
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
