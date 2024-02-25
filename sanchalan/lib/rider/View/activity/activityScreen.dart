// ignore_for_file: file_names
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sanchalan/common/model/rideRequestModel.dart';
import 'package:sanchalan/constant/constants.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/constant/utils/textstyle.dart';
import 'package:sizer/sizer.dart';

class ActivityScreenRider extends StatefulWidget {
  const ActivityScreenRider({super.key});

  @override
  State<ActivityScreenRider> createState() => _ActivityScreenRiderState();
}

class _ActivityScreenRiderState extends State<ActivityScreenRider> {
  DatabaseReference tripHistoryRef = FirebaseDatabase.instance
      .ref()
      .child('RideHistoryRider/${auth.currentUser!.phoneNumber}');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sanchalan',
          style: AppTextStyles.heading20Bold,
        ),
      ),
      body: StreamBuilder(
        stream: tripHistoryRef.onValue,
        builder: (context, event) {
          if (event.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: black,
              ),
            );
          }
          if (event.data != null) {
            return FirebaseAnimatedList(
                query: tripHistoryRef,
                itemBuilder: (context, snapshot, animation, index) {
                  RideRequestModel currentRideData = RideRequestModel.fromMap(
                    jsonDecode(jsonEncode(snapshot.value))
                        as Map<String, dynamic>,
                  );
                  return Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 1.7.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: index == 9 ? transparent : greyShade3,
                        ),
                      ),
                    ),
                    height: 11.4.h,
                    width: 94.w,
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 0.5.h,
                            horizontal: 1.w,
                          ),
                          height: 8.h,
                          width: 8.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              8.sp,
                            ),
                            color: greyShadeButton,
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/vehicle/car.png',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '33, 2nd Cross Road',
                                style: AppTextStyles.small12Bold,
                                maxLines: 2,
                              ),
                              Text(
                                DateFormat('dd MMM, kk:mm a').format(
                                  DateTime.now(),
                                ),
                                style: AppTextStyles.small10.copyWith(
                                  color: black87,
                                ),
                              ),
                              Text(
                                '150:00',
                                style: AppTextStyles.small10.copyWith(
                                  color: black87,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                });
          }
          return Center(
            child: Text(
              'No Trips Made',
              style: AppTextStyles.body14Bold.copyWith(color: grey),
            ),
          );
        },
      ),
    );
  }
}
