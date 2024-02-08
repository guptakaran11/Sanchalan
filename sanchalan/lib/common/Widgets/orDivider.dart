// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/constant/utils/textstyle.dart';
import 'package:sizer/sizer.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: grey,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 2.w,
          ),
          child: Text(
            'Or',
            style: AppTextStyles.small12.copyWith(color: grey),
          ),
        ),
        Expanded(
          child: Divider(
            color: grey,
          ),
        ),
      ],
    );
  }
}
