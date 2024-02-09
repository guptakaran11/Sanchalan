// ignore_for_file: file_names
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sanchalan/common/controller/provider/profileDataProvider.dart';
import 'package:sanchalan/common/model/pickupNDropLocationModel.dart';
import 'package:sanchalan/common/model/rideRequestModel.dart';
import 'package:sanchalan/constant/commonWidgets/elevatedButtonCommon.dart';
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
      context.read<RideRequestProvider>().updateUpdateMarkerBool(true);
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
        return 'Sanchlan Go';
      case 1:
        return 'Sanchlan Go Sedan';
      case 2:
        return 'Sanchlan Premier';
      case 3:
        return 'Sanchlan XL';
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
          return Builder(builder: (context) {
            if (bookRideButtonPressed == true) {
              return Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  CircularProgressIndicator(
                    color: black,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
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
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    'Cancel Ride',
                    style: AppTextStyles.body16Bold,
                  ),
                ],
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
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
                              margin: EdgeInsets.symmetric(vertical: 0.5.h),
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
                                      borderRadius: BorderRadius.circular(8.sp),
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
                                        style: AppTextStyles.small12.copyWith(
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
                            rideStatus: RideRequestServices.getRideStatus(0),
                            otp: math.Random().nextInt(9999).toString(),
                          );
                          RideRequestServices.createNewRideRequest(
                              model, context);
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
                      )
                    ],
                  );
                }
              });
            }
          });
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
                  top: 4.h,
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
                        Icons.arrow_back_ios,
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
