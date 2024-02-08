// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanchalan/common/controller/provider/profileDataProvider.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/constant/utils/textstyle.dart';
import 'package:sizer/sizer.dart';

class AccountScreenDriver extends StatefulWidget {
  const AccountScreenDriver({super.key});

  @override
  State<AccountScreenDriver> createState() => _AccountScreenDriverState();
}

class _AccountScreenDriverState extends State<AccountScreenDriver> {
  List accountTopButton = [
    [CupertinoIcons.shield_fill, 'Help'],
    [CupertinoIcons.creditcard_fill, 'Payment'],
    [CupertinoIcons.square_list_fill, 'Activity'],
  ];

  List accountButtons = [
    [
      CupertinoIcons.gift_fill,
      'Send a gift',
    ],
    [
      CupertinoIcons.gear_alt_fill,
      'Settings',
    ],
    [
      CupertinoIcons.envelope_fill,
      'Messages',
    ],
    [
      CupertinoIcons.money_dollar_circle_fill,
      'Earn by driving or delivering',
    ],
    [
      CupertinoIcons.briefcase_fill,
      'Business hub',
    ],
    [
      CupertinoIcons.person_2_fill,
      'Refer friends, unlock deals',
    ],
    [
      CupertinoIcons.person_fill,
      'Manage Account',
    ],
    [
      CupertinoIcons.power,
      'Logout',
    ],
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<ProfileDataProvider>().getProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Top Row
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 3.w,
                vertical: 1.h,
              ),
              children: [
                // Profile data
                Consumer<ProfileDataProvider>(
                  builder: (context, profileProvider, child) {
                    if (profileProvider.profileData == null) {
                      return Row(
                        children: [
                          SizedBox(
                            width: 70.w,
                            child: Text(
                              'User',
                              style: AppTextStyles.heading26Bold,
                            ),
                          ),
                          Container(
                            height: 16.w,
                            width: 16.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: black87,
                              ),
                              image: const DecorationImage(
                                image: AssetImage(
                                    'assets/images/SanchalanLogo/sanchalanSign.jpg'),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          SizedBox(
                            width: 70.w,
                            child: Text(
                              profileProvider.profileData!.name!,
                              style: AppTextStyles.heading26Bold,
                            ),
                          ),
                          Container(
                            height: 16.w,
                            width: 16.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: black87,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(profileProvider
                                    .profileData!.profilePicUrl!),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),

                SizedBox(
                  height: 3.h,
                ),
                // Top row button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: accountTopButton
                      .map((e) => Container(
                            height: 10.h,
                            width: 28.w,
                            decoration: BoxDecoration(
                              color: greyShade3,
                              borderRadius: BorderRadius.circular(8.sp),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  e[0],
                                  size: 4.h,
                                  color: black87,
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Text(
                                  e[1],
                                  style: AppTextStyles.small10,
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),

            Divider(
              color: greyShade2,
              thickness: 0.5.h,
            ),
            SizedBox(
              height: 2.h,
            ),
            ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: 3.w,
              ),
              itemCount: accountButtons.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Row(
                    children: [
                      Icon(
                        accountButtons[index][0],
                        color: black,
                        size: 3.h,
                      ),
                      SizedBox(
                        width: 7.w,
                      ),
                      Text(
                        accountButtons[index][1],
                        style: AppTextStyles.small12,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
