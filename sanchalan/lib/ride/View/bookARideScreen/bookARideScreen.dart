// ignore_for_file: file_names
import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sanchalan/common/controller/provider/profileDataProvider.dart';
import 'package:sanchalan/common/model/pickupNDropLocationModel.dart';
import 'package:sanchalan/common/model/rideRequestModel.dart';
import 'package:sanchalan/constant/commonWidgets/elevatedButtonCommon.dart';
import 'package:sanchalan/constant/constants.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/constant/utils/textstyle.dart';
import 'package:sanchalan/ride/controller/provider/tripProvider/rideRequestProvider.dart';
import 'package:sanchalan/ride/controller/services/nearByDriverServices/nearByDriverServices.dart';
import 'package:sanchalan/ride/controller/services/rideRequestServices/rideRequestServices.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math' as math;

class BookARideScreen extends StatefulWidget {
  const BookARideScreen({super.key});

  @override
  State<BookARideScreen> createState() => _BookARideScreenState();
}

class _BookARideScreenState extends State<BookARideScreen> {
  Completer<GoogleMapController> mapControllerDriver = Completer();
  GoogleMapController? mapController;
  int selectedCarType = 0;
  bool bookRideButtonPressed = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<RideRequestProvider>().updateFetchNearByDrivers(true);
      // context.read<RideRequestProvider>().updateUpdateMarkerBool(true);
      PickupNDropLocationModel pickupModel =
          context.read<RideRequestProvider>().pickupLocation!;
      LatLng pickupLocation =
          LatLng(pickupModel.latitude!, pickupModel.longitude!);
      await NearByDriverServices.getNearByDriver(pickupLocation, context);
    });
  }

  int getFare(
    int index,
  ) {
    if (index == 0) {
      return context.read<RideRequestProvider>().sanchalanGoFare;
    }
    if (index == 1) {
      return context.read<RideRequestProvider>().sanchalanGoSedanFare;
    }
    if (index == 2) {
      return context.read<RideRequestProvider>().sanchalanPremierFare;
    }
    if (index == 3) {
      return context.read<RideRequestProvider>().sanchalanXLFare;
    }
    return 0;
  }

  getCarType(int carType) {
    switch (carType) {
      case 0:
        return 'Sanchalan Go';
      case 1:
        return 'Sanchalan Go Sedan';
      case 2:
        return 'Sanchalan Premier';
      case 3:
        return 'Sanchalan XL';
      default:
        return 'Sanchalan Go';
    }
  }

  List rideList = [
    ['assets/images/vehicle/SanchalanGo.png', 'Sanchalan Go', '4'],
    ['assets/images/vehicle/SanchalanGoSedan.png', 'Sanchalan Go Sedan', '4'],
    ['assets/images/vehicle/SanchalanPremier.png', 'Sanchalan Premier', '4'],
    ['assets/images/vehicle/SanchalanXL.png', 'Sanchalan XL', '6'],
  ];
  final panelController = PanelController();
  DatabaseReference riderRideRequestRef = FirebaseDatabase.instance
      .ref()
      .child('RideRequest/${auth.currentUser!.phoneNumber}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: 9.h,
        controller: panelController,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            15.sp,
          ),
        ),
        panelBuilder: (controller) {
          return Consumer<RideRequestProvider>(
            builder: (context, rideRequestProvider, child) {
              if (rideRequestProvider.placedRideRequest == false) {
                return Builder(builder: (context) {
                  if (bookRideButtonPressed == true) {
                    return CancelRideRequest(
                      controller: controller,
                    );
                  } else {
                    return Consumer<RideRequestProvider>(
                        builder: (context, rideRequestProvider, child) {
                      if ((rideRequestProvider.sanchalanGoFare == 0) &&
                          (rideRequestProvider.sanchalanGoSedanFare == 0) &&
                          (rideRequestProvider.sanchalanPremierFare == 0) &&
                          (rideRequestProvider.sanchalanPremierFare == 0)) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: black,
                          ),
                        );
                      } else {
                        return ListView(
                          controller: controller,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 2.h),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 1.h,
                                  width: 20.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.sp),
                                    color: greyShade3,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            ListView.builder(
                              itemCount: rideList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedCarType = index;
                                    });
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(vertical: 0.5.h),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 1.h,
                                      horizontal: 3.w,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.sp),
                                      border: Border.all(
                                        color: index == selectedCarType
                                            ? black
                                            : transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 8.h,
                                          width: 8.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.sp),
                                            border: Border.all(color: black38),
                                            color: white,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                rideList[index][0],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 3.w,
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Text(
                                                getCarType(index),
                                                style: AppTextStyles.body14Bold,
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              Icon(
                                                Icons.person,
                                                color: black,
                                              ),
                                              Text(rideList[index][2]),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              '₹ ${getFare(index).toString()}',
                                              style: AppTextStyles.body14Bold,
                                            ),
                                            Text(
                                              (getFare(index) * 1.15)
                                                  .round()
                                                  .toString(),
                                              style: AppTextStyles.small12
                                                  .copyWith(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: grey,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            ElevatedButtonCommon(
                              onPressed: () {
                                context
                                    .read<RideRequestProvider>()
                                    .updatePlacedRideRequestStatus(true);
                                setState(() {
                                  bookRideButtonPressed = true;
                                });
                                RideRequestModel model = RideRequestModel(
                                  rideCreatTime: DateTime.now(),
                                  riderProfile: context
                                      .read<ProfileDataProvider>()
                                      .profileData!,
                                  pickupLocation: context
                                      .read<RideRequestProvider>()
                                      .pickupLocation!,
                                  dropLocation: context
                                      .read<RideRequestProvider>()
                                      .dropLocation!,
                                  fare: getFare(selectedCarType).toString(),
                                  carTrpe: getCarType(selectedCarType),
                                  rideStatus:
                                      RideRequestServices.getRideStatus(0),
                                  otp: math.Random().nextInt(9999).toString(),
                                );
                                RideRequestServices.createNewRideRequest(
                                    model, context);
                                context
                                    .read<RideRequestProvider>()
                                    .sendPushNotificationToNearByDrivers();
                              },
                              backgroundColor: black,
                              height: 6.h,
                              width: 94.w,
                              child: Builder(builder: (context) {
                                if (bookRideButtonPressed == true) {
                                  return CircularProgressIndicator(
                                    color: white,
                                  );
                                } else {
                                  return Text(
                                    'Continue',
                                    style: AppTextStyles.body16Bold
                                        .copyWith(color: white),
                                  );
                                }
                              }),
                            ),
                          ],
                        );
                      }
                    });
                  }
                });
              } else {
                return StreamBuilder(
                  stream: riderRideRequestRef.onValue,
                  builder: (context, event) {
                    if ((event.connectionState == ConnectionState.waiting) ||
                        (event.data == null)) {
                      return ListView(
                        shrinkWrap: true,
                        controller: controller,
                        children: [
                          Center(
                            child: CircularProgressIndicator(
                              color: black,
                            ),
                          ),
                        ],
                      );
                    }
                    if (event.data != null) {
                      RideRequestModel rideData = RideRequestModel.fromMap(
                          jsonDecode(jsonEncode(event.data!.snapshot.value))
                              as Map<String, dynamic>);
                      if (rideData.driverProfile == null) {
                        return CancelRideRequest(
                          controller: controller,
                        );
                      }
                      if (rideData.rideStatus ==
                          RideRequestServices.getRideStatus(0)) {
                        return RideData(
                          rideData: rideData,
                          controller: controller,
                        );
                      } else if (rideData.rideStatus ==
                          RideRequestServices.getRideStatus(1)) {
                        return RideData(
                          rideData: rideData,
                          controller: controller,
                        );
                      } else {
                        RideData(
                          rideData: rideData,
                          controller: controller,
                        );
                      }
                    }
                    return CancelRideRequest(
                      controller: controller,
                    );
                  },
                );
              }
            },
          );
        },
        body: Consumer<RideRequestProvider>(
          builder: (context, rideRequestProvider, child) {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition:
                      rideRequestProvider.initialCameraPosition,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  polylines: rideRequestProvider.polylineSet,
                  markers: rideRequestProvider.riderMarker,
                  onMapCreated: (GoogleMapController controller) async {
                    mapControllerDriver.complete(controller);
                    mapController = controller;
                    LatLng pickupLocation = LatLng(
                      rideRequestProvider.pickupLocation!.latitude!,
                      rideRequestProvider.pickupLocation!.longitude!,
                    );
                    CameraPosition cameraPosition = CameraPosition(
                      target: pickupLocation,
                      zoom: 14,
                    );
                    mapController!.animateCamera(
                        CameraUpdate.newCameraPosition(cameraPosition));
                  },
                ),
                Positioned(
                  top: 7.h,
                  left: 5.w,
                  child: InkWell(
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class RideData extends StatelessWidget {
  const RideData({
    super.key,
    required this.rideData,
    required this.controller,
  });

  final RideRequestModel rideData;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        horizontal: 3.w,
        vertical: 2.h,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 1.h,
              width: 20.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.sp),
                color: greyShade3,
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 70.w,
              child: Text(
                rideData.driverProfile!.name!,
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
                  image: NetworkImage(rideData.driverProfile!.profilePicUrl!),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'OTP\t\t',
                    style: AppTextStyles.body16Bold.copyWith(color: black87),
                  ),
                  TextSpan(
                    text: rideData.otp,
                    style: AppTextStyles.body18Bold,
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Fare\t\t',
                    style: AppTextStyles.body16Bold.copyWith(color: black87),
                  ),
                  TextSpan(
                    text: rideData.fare,
                    style: AppTextStyles.body18Bold,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
          ],
        ),
        SizedBox(
          height: 3.h,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pickup Location',
              style: AppTextStyles.body16Bold,
            ),
            Text(
              rideData.pickupLocation.name!,
              style: AppTextStyles.body14,
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              'Drop Location',
              style: AppTextStyles.body16Bold,
            ),
            Text(
              rideData.dropLocation.name!,
              style: AppTextStyles.body14,
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Row(
          children: [
            Text(
              'Car Type',
              style: AppTextStyles.body16,
            ),
            SizedBox(
              width: 3.w,
            ),
            Text(
              rideData.carTrpe,
              style: AppTextStyles.body16Bold,
            ),
            Builder(builder: (context) {
              if (rideData.carTrpe == 'Sanchalan Go') {
                return Image(
                  image:
                      const AssetImage('assets/images/vehicle/SanchalanGo.png'),
                  height: 5.h,
                );
              } else if (rideData.carTrpe == 'Sanchalan Go Sedan') {
                return Image(
                  image: const AssetImage(
                      'assets/images/vehicle/SanchalanGoSedan.png'),
                  height: 5.h,
                );
              } else if (rideData.carTrpe == 'Sanchalan Premier') {
                return Image(
                  image: const AssetImage(
                      'assets/images/vehicle/SanchalanPremier.png'),
                  height: 5.h,
                );
              } else {
                return Image(
                  image:
                      const AssetImage('assets/images/vehicle/SanchalanXL.png'),
                  height: 5.h,
                );
              }
            }),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          '${rideData.driverProfile!.vehicleBrandName} ${rideData.driverProfile!.vehicleModel}',
          style: AppTextStyles.body16Bold,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Registeration No. ',
                style: AppTextStyles.body16,
              ),
              TextSpan(
                text: rideData.driverProfile!.vehicleRegistrationNumber!,
                style: AppTextStyles.body16Bold,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CancelRideRequest extends StatelessWidget {
  const CancelRideRequest({
    super.key,
    required this.controller,
  });

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 5.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: black,
            ),
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        InkWell(
          onTap: () async {
            await RideRequestServices.cancelRideRequest(context);
          },
          child: Container(
            height: 8.h,
            width: 8.h,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: black38,
                  width: 2,
                ),
                color: white),
            child: Icon(
              CupertinoIcons.xmark,
              color: black,
              size: 6.h,
            ),
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Cancel Ride',
          textAlign: TextAlign.center,
          style: AppTextStyles.body16Bold,
        ),
      ],
    );
  }
}
