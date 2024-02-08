// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/constant/utils/textstyle.dart';
import 'package:sanchalan/ride/controller/provider/tripProvider/rideRequestProvider.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BookARideScreen extends StatefulWidget {
  const BookARideScreen({super.key});

  @override
  State<BookARideScreen> createState() => _BookARideScreenState();
}

class _BookARideScreenState extends State<BookARideScreen> {
  Completer<GoogleMapController> mapControllerDriver = Completer();
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {}); //something is left
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

  getCarTypr(int carType) {
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
        controller: panelController,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.sp),
        ),
        panelBuilder: (controller) {
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
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
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
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 1.h),
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
                                    getCarTypr(index),
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
                                  getFare(index).toString(),
                                  style: AppTextStyles.body14Bold,
                                ),
                                Text(
                                  getFare(index).toString(),
                                  style: AppTextStyles.small12.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: grey,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
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
