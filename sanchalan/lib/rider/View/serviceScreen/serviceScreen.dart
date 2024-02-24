// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/constant/utils/textstyle.dart';
import 'package:sizer/sizer.dart';

class ServiceScreenRider extends StatefulWidget {
  const ServiceScreenRider({super.key});

  @override
  State<ServiceScreenRider> createState() => _ServiceScreenRiderState();
}

class _ServiceScreenRiderState extends State<ServiceScreenRider> {
  List firstRow = [
    [
      'assets/images/services/trip.png',
      'Trip',
    ],
    [
      'assets/images/services/rentals.png',
      'Rentals',
    ],
  ];

  List secondRow = [
    [
      'assets/images/services/reserve.png',
      'Reserve',
    ],
    [
      'assets/images/services/intercity.png',
      'Inter city',
    ],
    [
      'assets/images/services/groupRide.png',
      'Group Ride',
    ],
    [
      'assets/images/services/package.png',
      'Package',
    ],
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Services',
          style: AppTextStyles.heading20Bold,
        ),
      ),
      body: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
            vertical: 2.h,
          ),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: 1.h,
            ),
            Text(
              'Go anywhere , get anything',
              style: AppTextStyles.body14Bold,
            ),
            SizedBox(
              height: 2.h,
            ),
            // First Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: firstRow
                  .map((e) => Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 1.h),
                        width: 44.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              8.sp,
                            ),
                            color: greyShadeButton),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              e[1],
                              style: AppTextStyles.small12,
                            ),
                            SizedBox(
                              height: 8.h,
                              width: 8.h,
                              child: Image(
                                image: AssetImage(e[0]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),

            // Second Row
            SizedBox(
              height: 2.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: secondRow
                  .map((e) => Column(
                        children: [
                          Container(
                            width: 20.w,
                            padding: EdgeInsets.symmetric(
                              vertical: 1.5.h,
                              horizontal: 2.w,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                8.sp,
                              ),
                              color: greyShadeButton,
                            ),
                            child: SizedBox(
                              height: 5.h,
                              width: 5.h,
                              child: Image(
                                image: AssetImage(e[0]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            e[1],
                            style: AppTextStyles.small10,
                          )
                        ],
                      ))
                  .toList(),
            )
          ]),
    );
  }
}
