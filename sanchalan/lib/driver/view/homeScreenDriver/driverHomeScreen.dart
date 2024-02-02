import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sanchalan/common/controller/services/locationServices.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/constant/utils/textstyle.dart';
import 'package:sanchalan/driver/controller/services/mapsProviderDriver.dart';
import 'package:sizer/sizer.dart';

class HomeScreenDriver extends StatefulWidget {
  const HomeScreenDriver({super.key});

  @override
  State<HomeScreenDriver> createState() => _HomeScreenDriverState();
}

class _HomeScreenDriverState extends State<HomeScreenDriver> {
  Completer<GoogleMapController> mapControllerDriver = Completer();
  GoogleMapController? mapController;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(100.w, 10.h),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 3.w,
              vertical: 1.h,
            ),
            child: SwipeButton(
              thumbPadding: EdgeInsets.all(1.w),
              thumb: Icon(
                Icons.chevron_right,
                color: white,
              ),
              inactiveThumbColor: black,
              inactiveTrackColor: greyShade3,
              activeThumbColor: black,
              activeTrackColor: greyShade3,
              elevationThumb: 2,
              elevationTrack: 2,
              onSwipe: () {
                log('Button is Swiped');
              },
              child: Builder(builder: (context) {
                return Text(
                  'Go Online',
                  style: AppTextStyles.body16Bold,
                );
              }),
            ),
          ),
        ),
        body: Stack(
          children: [
            Consumer<MapsProviderDriver>(
              builder: (context, mapProvider, child) {
                return GoogleMap(
                  initialCameraPosition: mapProvider.initialCameraPosition,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  onMapCreated: (GoogleMapController controller) async {
                    mapControllerDriver.complete(controller);
                    mapController = controller;
                    LatLng crrLocation =
                        await LocationServices.getCurrentlocation();
                    CameraPosition cameraPosition = CameraPosition(
                      target: crrLocation,
                      zoom: 14,
                    );
                    mapController!.animateCamera(
                        CameraUpdate.newCameraPosition(cameraPosition));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
