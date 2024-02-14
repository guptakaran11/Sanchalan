// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:sanchalan/common/controller/services/firebasePushNotificationsServices/pushNotificationServices.dart';
import 'package:sanchalan/common/controller/services/profileDataCRUDServices.dart';
import 'package:sanchalan/common/model/profileModelData.dart';
import 'package:sanchalan/constant/constants.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/ride/controller/provider/bottomNavbarRiderProvider/bottomNavBarRiderProvider.dart';
import 'package:sanchalan/ride/View/account/accountScreenRider.dart';
import 'package:sanchalan/ride/View/activity/activityScreen.dart';
import 'package:sanchalan/ride/View/homeScreen/riderHomeSceen.dart';
import 'package:sanchalan/ride/View/serviceScreen/serviceScreen.dart';
import 'package:sizer/sizer.dart';

class BottomNavBarRider extends StatefulWidget {
  const BottomNavBarRider({super.key});

  @override
  State<BottomNavBarRider> createState() => _BottomNavBarRiderState();
}

class _BottomNavBarRiderState extends State<BottomNavBarRider> {
  List<Widget> screens = const [
    RiderHomeScreen(),
    ServiceScreenRider(),
    ActivityScreenRider(),
    AccountScreenRider(),
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
      PersistentBottomNavBarItem(
          icon: Icon(
            currentTab == 0
                ? CupertinoIcons.circle_grid_3x3_fill
                : CupertinoIcons.circle_grid_3x3,
          ),
          title: 'Services',
          activeColorPrimary: black,
          inactiveColorPrimary: grey),
      PersistentBottomNavBarItem(
          icon: Icon(
            currentTab == 0
                ? CupertinoIcons.square_list_fill
                : CupertinoIcons.square_list,
          ),
          title: 'Activity',
          activeColorPrimary: black,
          inactiveColorPrimary: grey),
      PersistentBottomNavBarItem(
          icon: Icon(
            currentTab == 0
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
    return Consumer<BottomNavBarRiderProvider>(builder: (
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
        onItemSelected: (value) {},
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
