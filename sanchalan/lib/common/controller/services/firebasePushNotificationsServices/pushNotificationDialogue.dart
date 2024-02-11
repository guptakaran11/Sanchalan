import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:sanchalan/common/model/rideRequestModel.dart';
import 'package:sanchalan/constant/constants.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/constant/utils/textstyle.dart';
import 'package:sizer/sizer.dart';

class PushNotificationDialogue {
  static rideRequestDialogue(
      RideRequestModel rideRequestModel, BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          audioPlayer.setAsset('assets/sounds/alert.mp3');
          audioPlayer.play();
          return AlertDialog(
            content: SizedBox(
              height: 40.h,
              width: 90.w,
              child: Column(
                children: [
                  Builder(builder: (context) {
                    if (rideRequestModel.carTrpe == 'Sanchalan Go') {
                      return Image(
                        image: const AssetImage(
                            'assets/images/vehicle/SanchalanGo.png'),
                        height: 5.h,
                      );
                    } else if (rideRequestModel.carTrpe ==
                        'Sanchalan Go Sedan') {
                      return Image(
                        image: const AssetImage(
                            'assets/images/vehicle/SanchalanGoSedan.png'),
                        height: 5.h,
                      );
                    } else if (rideRequestModel.carTrpe ==
                        'Sanchalan Premier') {
                      return Image(
                        image: const AssetImage(
                            'assets/images/vehicle/SanchalanPremier.png'),
                        height: 5.h,
                      );
                    } else {
                      return Image(
                        image: const AssetImage(
                            'assets/images/vehicle/SanchalanXL.png'),
                        height: 5.h,
                      );
                    }
                  }),
                  SizedBox(
                    height: 3.w,
                  ),
                  Text(
                    'Ride Request',
                    style: AppTextStyles.body18Bold,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 4.h,
                        child: const Image(
                          image:
                              AssetImage('assets/images/icons/pickupPng.png'),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Expanded(
                        child: Text(
                          rideRequestModel.pickupLocation.name!,
                          maxLines: 2,
                          style: AppTextStyles.body16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 4.h,
                        child: const Image(
                          image: AssetImage('assets/images/icons/dropPng.png'),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Expanded(
                        child: Text(
                          rideRequestModel.dropLocation.name!,
                          maxLines: 2,
                          style: AppTextStyles.body16,
                        ),
                      ),
                    ],
                  ),
                  SwipeButton(
                    thumbPadding: EdgeInsets.all(1.w),
                    thumb: Icon(
                      Icons.chevron_right,
                      color: white,
                    ),
                    inactiveThumbColor: success,
                    activeThumbColor: success,
                    inactiveTrackColor: greyShade3,
                    activeTrackColor: greyShade3,
                    elevationThumb: 2,
                    elevationTrack: 2,
                    onSwipe: () {},
                    child: Builder(
                      builder: (context) {
                        return Text(
                          'Accept Ride Request',
                          style: AppTextStyles.body16Bold,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SwipeButton(
                    thumbPadding: EdgeInsets.all(1.w),
                    thumb: Icon(
                      Icons.chevron_right,
                      color: white,
                    ),
                    inactiveThumbColor: red,
                    activeThumbColor: red,
                    inactiveTrackColor: greyShade3,
                    activeTrackColor: greyShade3,
                    elevationThumb: 2,
                    elevationTrack: 2,
                    onSwipe: () {},
                    child: Builder(
                      builder: (context) {
                        return Text(
                          'Deny Ride Request',
                          style: AppTextStyles.body16Bold,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
