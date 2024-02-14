// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:sanchalan/common/controller/services/firebasePushNotificationsServices/pushNotificationServices.dart';
import 'package:sanchalan/common/controller/services/profileDataCRUDServices.dart';
import 'package:sanchalan/common/model/profileModelData.dart';
import 'package:sanchalan/constant/constants.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/driver/controller/services/bottomNavBarDriverProvider.dart';
import 'package:sanchalan/driver/view/accountScreenDriver/accountScreenDriver.dart';
import 'package:sanchalan/driver/view/activityScreenDriver/activityScreen.dart';
import 'package:sanchalan/driver/view/homeScreenDriver/driverHomeScreen.dart';
import 'package:sizer/sizer.dart';

class BottomNavBarDriver extends StatefulWidget {
  const BottomNavBarDriver({super.key});

  @override
  State<BottomNavBarDriver> createState() => _BottomNavBarDriverState();
}

class _BottomNavBarDriverState extends State<BottomNavBarDriver> {
  List<Widget> screens = const [
    HomeScreenDriver(),
    ActivityScreenDriver(),
    AccountScreenDriver(),
  ];

  List<PersistentBottomNavBarItem> _navBarItems(int currentTab) {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(
            currentTab == 0 ? CupertinoIcons.house_fill : CupertinoIcons.house,
          ),
          title: 'Home',
          activeColorPrimary: black,
          inactiveColorPrimary: grey),
      // PersistentBottomNavBarItem(
      //     icon: Icon(
      //       currentTab == 0
      //           ? CupertinoIcons.circle_grid_3x3_fill
      //           : CupertinoIcons.circle_grid_3x3,
      //     ),
      //     title: 'Services',
      //     activeColorPrimary: black,
      //     inactiveColorPrimary: grey),
      PersistentBottomNavBarItem(
          icon: Icon(
            currentTab == 1
                ? CupertinoIcons.square_list_fill
                : CupertinoIcons.square_list,
          ),
          title: 'Activity',
          activeColorPrimary: black,
          inactiveColorPrimary: grey),
      PersistentBottomNavBarItem(
          icon: Icon(
            currentTab == 2
                ? CupertinoIcons.person_fill
                : CupertinoIcons.person,
          ),
          title: 'Account',
          activeColorPrimary: black,
          inactiveColorPrimary: grey)
    ];
  }

  PersistentTabController controller = PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ProfileDataModel profileData =
          await ProfileDataCRUDServices.getProfileDataFromRealTimeDatabase(
              auth.currentUser!.phoneNumber!);
      PushNotificationServices.initializeFirebaseMessagingForUsers(
          profileData, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavBarDriverProvider>(builder: (
      context,
      tabProvider,
      child,
    ) {
      return PersistentTabView(
        context,
        screens: screens,
        controller: controller,
        items: _navBarItems(tabProvider.currentTab),
        confineInSafeArea: true,
        onItemSelected: (value) {
          tabProvider.updateTab(value);
          log(value.toString());
        },
        backgroundColor: white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(8.sp),
          colorBehindNavBar: white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(
            microseconds: 200,
          ),
        ),
        navBarStyle: NavBarStyle.style6,
      );
    });
  }
}
