import 'package:flutter/material.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/ride/controller/model/view/activity/activityScreen.dart';
import 'package:sanchalan/ride/controller/model/view/homeScreen/riderHomeSceen.dart';
import 'package:sanchalan/ride/controller/model/view/serviceScreen/serviceScreen.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const Sanchalan());
}

class Sanchalan extends StatefulWidget {
  const Sanchalan({super.key});

  @override
  State<Sanchalan> createState() => _SanchalanState();
}

class _SanchalanState extends State<Sanchalan> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, _, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              color: white,
              elevation: 0,
            ),
          ),
          home: const ActivityScreenRider(),
        );
      },
    );
  }
}
