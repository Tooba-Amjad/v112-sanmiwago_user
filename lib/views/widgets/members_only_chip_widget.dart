import 'package:flutter/material.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

class MembersOnlyChip extends StatelessWidget {
  const MembersOnlyChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      // padding: EdgeInsets.zero,
      // labelPadding: EdgeInsets.zero,
      label: MyText(
        text: 'Members Only',
        color: Colors.white,
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Colors.red,
    );
  }
}
