import 'package:flutter/material.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sizer/sizer.dart';

import '../../../constant/utils/textstyle.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 5.h,
            width: 5.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: white,
            ),
            child: Icon(
              Icons.arrow_back,
              color: black,
              size: 4.h,
            ),
          ),
        ),
        title: Text(
          'Wallet',
          style: AppTextStyles.heading20Bold,
          
        ),
      ),
      body: const Center(
        child: Text("Payment Screen"),
      ),
    );
  }
}
