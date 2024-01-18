// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/constant/utils/textstyle.dart';
import 'package:sizer/sizer.dart';

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({super.key});

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  List suggestions = [
    ["assets/images/suggestions/trip.png", 'Trip'],
    ['assets/images/suggestions/rentals.png', 'Rentals'],
    ['assets/images/suggestions/reserve.png', 'Reserve'],
    ['assets/images/suggestions/intercity.png', 'InterCity'],
  ];

  List moreWaysToSanchalan = [
    ['assets/images/moreWaysSanchalan/sendAPackage.png',
    'Send a package',
    'On-demand delivery across town',
    ],
     ['assets/images/moreWaysSanchalan/premierTrips.png',
    'Premier Trips',
    'Top-rated drivers,newer cars',
    ],
     ['assets/images/moreWaysSanchalan/safetyToolKit.png',
    'Safety Toolkit',
    'On-trip help with safety issues',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sanchalan',
          style: AppTextStyles.heading20Bold,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 1.h,
        ),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          // where to button
          InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.h, vertical: 1.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.sp),
                color: greyShade3,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: black87,
                    size: 4.h,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    'where to ?',
                    style: AppTextStyles.body14Bold,
                  )
                ],
              ),
            ),
          ),
          //  previous trip records
          ListView.builder(
            itemCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: ((context, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 1.5.h),
                padding: EdgeInsets.symmetric(
                  vertical: 0.5.h,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 3.h,
                      backgroundColor: greyShade3,
                      child: Icon(
                        Icons.location_on,
                        color: black,
                      ),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Main Address',
                          style: AppTextStyles.body14Bold,
                        ),
                        Text(
                          'Main Address Description',
                          style: AppTextStyles.small10.copyWith(color: black38),
                        )
                      ],
                    )),
                    SizedBox(
                      width: 3.w,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: greyShade3,
                      size: 15.sp,
                    ),
                  ],
                ),
              );
            }),
          ),

          // suggestions
          SizedBox(height: 4.h),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Suggestions',
                    style: AppTextStyles.body14Bold,
                  ),
                  Text(
                    'See all',
                    style: AppTextStyles.small10.copyWith(color: black87),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: suggestions
                    .map((e) => SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 15.w,
                                width: 20.w,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  color: greyShadeButton,
                                ),
                                child: Image(
                                  image: AssetImage(
                                    e[0],
                                  ),
                                ),
                              ),
                              Text(
                                e[1],
                                style: AppTextStyles.small10Bold
                                    .copyWith(color: black87),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              )
            ],
          ),
          // Banner
          SizedBox(
            height: 2.h,
          ),
          const Image(
            image: AssetImage('assets/images/promotion/promo.png'),
          ),
          SizedBox(
            height: 4.h,
          ),
          Column(
            children: [
              Text(
                'More ways to use Sanchalan',
                style: AppTextStyles.body14Bold,
              ),
              SizedBox(
                height: 1.h,
              ),
              SizedBox(
                height: 20.h,
                child: ListView.builder(shrinkWrap: true,itemCount: ,itemBuilder: (context,index){}),
              ),
            ],
          )
        ],
      ),
    );
  }
}
