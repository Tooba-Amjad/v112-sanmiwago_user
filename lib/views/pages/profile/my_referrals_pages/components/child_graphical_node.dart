import 'package:flutter/material.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/views/pages/profile/my_referrals_pages/components/graphical_node.dart';

class ChildGraphicalNode extends StatelessWidget {
  const ChildGraphicalNode({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 60),
        const Icon(Icons.circle, size: 10, color: AppColors.kBlackColor),
        const SizedBox(width: 9),
        GraphicalNode(
          name: name,
        ),
      ],
    );
  }
}
