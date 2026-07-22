import 'package:flutter/material.dart';

class FieldsContainer extends StatelessWidget {
  const FieldsContainer({
    super.key,
    required this.children,
    this.horizontalPadding,
    this.verticalPadding,
  });

  final List<Widget> children;
  final double? horizontalPadding;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? 5,
        vertical: verticalPadding ?? 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
