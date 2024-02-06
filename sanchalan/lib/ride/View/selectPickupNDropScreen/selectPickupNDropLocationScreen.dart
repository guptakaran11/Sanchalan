// ignore_for_file: use_build_context_synchronously, file_names

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sanchalan/common/controller/provider/locationProvider.dart';
import 'package:sanchalan/common/controller/services/locationServices.dart';
import 'package:sanchalan/common/model/pickupNDropLocationModel.dart';
import 'package:sanchalan/common/model/searchedAddressModel.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/constant/utils/textstyle.dart';
import 'package:sanchalan/ride/View/bookARideScreen/bookARideScreen.dart';
import 'package:sanchalan/ride/controller/provider/tripProvider/rideRequestProvider.dart';
import 'package:sizer/sizer.dart';

class PickupAndDropLocationScreen extends StatefulWidget {
  const PickupAndDropLocationScreen({super.key});

  @override
  State<PickupAndDropLocationScreen> createState() =>
      _PickupAndDropLocationScreenState();
}

class _PickupAndDropLocationScreenState
    extends State<PickupAndDropLocationScreen> {
  TextEditingController pickupLocationController = TextEditingController();
  TextEditingController dropLocationController = TextEditingController();
  FocusNode dropLocationFocus = FocusNode();
  FocusNode pickupLocationFocus = FocusNode();
  String locationType = 'DROP';

  getCurrentAddress() async {
    LatLng currLocation = await LocationServices.getCurrentlocation();
    PickupNDropLocationModel currentLocationAddress =
        await LocationServices.getAddressFromLatLng(
      position: currLocation,
      context: context,
    );
    pickupLocationController.text = currentLocationAddress.name!;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentAddress();
      FocusScope.of(context).requestFocus(dropLocationFocus);
    });
  }

  navigateToBookRideScreen() {
    if (context.read<LocationProvider>().pickupLocation != null &&
        context.read<LocationProvider>().dropLocation != null) {
      Navigator.push(
          context,
          PageTransition(
            child: const BookARideScreen(),
            type: PageTransitionType.rightToLeft,
          ));
      PickupNDropLocationModel pickup =
          context.read<LocationProvider>().pickupLocation!;
      PickupNDropLocationModel drop =
          context.read<LocationProvider>().dropLocation!;
      context
          .read<RideRequestProvider>()
          .updateRidePickupAndDropLocation(pickup, drop);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(
            100.w,
            22.h,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 3.w,
              vertical: 1.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 4.h,
                    color: black,
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        child: Column(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 2.h,
                              color: black,
                            ),
                            Expanded(
                              child: Container(
                                width: 1.w,
                                color: black,
                                padding: EdgeInsets.symmetric(
                                  vertical: 0.5.h,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.square,
                              size: 2.h,
                              color: black,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextFormField(
                              controller: pickupLocationController,
                              focusNode: pickupLocationFocus,
                              cursorColor: black,
                              style: AppTextStyles.textFieldTextStyle,
                              keyboardType: TextInputType.name,
                              onChanged: (value) {
                                setState(() {
                                  locationType = 'PICKUP';
                                });
                                LocationServices.getSearchedAddress(
                                  placeName: value,
                                  context: context,
                                );
                              },
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () {
                                    pickupLocationController.clear();
                                  },
                                  child: Icon(
                                    CupertinoIcons.xmark,
                                    color: black38,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 2.w,
                                ),
                                hintText: 'Pickup Address',
                                hintStyle: AppTextStyles.textFieldHintTextStyle,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  borderSide: BorderSide(color: grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  borderSide: BorderSide(color: grey),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  borderSide: BorderSide(color: grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  borderSide: BorderSide(color: grey),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: dropLocationController,
                              focusNode: dropLocationFocus,
                              cursorColor: black,
                              style: AppTextStyles.textFieldTextStyle,
                              keyboardType: TextInputType.name,
                              onChanged: (value) {
                                setState(() {
                                  locationType = 'DROP';
                                });
                                LocationServices.getSearchedAddress(
                                  placeName: value,
                                  context: context,
                                );
                              },
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () {
                                    dropLocationController.clear();
                                  },
                                  child: Icon(
                                    CupertinoIcons.xmark,
                                    color: black38,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 2.w,
                                ),
                                hintText: 'Drop Address',
                                hintStyle: AppTextStyles.textFieldHintTextStyle,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  borderSide: BorderSide(color: grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  borderSide: BorderSide(color: grey),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  borderSide: BorderSide(color: grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  borderSide: BorderSide(color: grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Consumer<LocationProvider>(
          builder: (context, locationProvider, child) {
            if (locationProvider.searchedAddress.isEmpty) {
              return Center(
                child: Text(
                  'Search Address',
                  style: AppTextStyles.small12,
                ),
              );
            } else {
              return ListView.builder(
                itemCount: locationProvider.searchedAddress.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  SearchedAddressModel currentAddress =
                      locationProvider.searchedAddress[index];
                  return ListTile(
                    onTap: () async {
                      log(currentAddress.toMap().toString());
                      await LocationServices.getLatLngFromPlaceID(
                          currentAddress, context, locationType);
                      navigateToBookRideScreen();
                    },
                    leading: CircleAvatar(
                      backgroundColor: greyShade3,
                      radius: 3.h,
                      child: Icon(
                        Icons.location_on,
                        color: black,
                      ),
                    ),
                    title: Text(
                      currentAddress.mainName,
                      style: AppTextStyles.small12Bold,
                    ),
                    subtitle: Text(
                      currentAddress.mainName,
                      style: AppTextStyles.small10.copyWith(color: grey),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
