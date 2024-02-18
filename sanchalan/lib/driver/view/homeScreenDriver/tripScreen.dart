// ignore_for_file: file_names
import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sanchalan/common/model/rideRequestModel.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/constant/utils/textstyle.dart';
import 'package:sanchalan/driver/controller/provider/rideRequestProviderDriver.dart';
import 'package:sanchalan/driver/controller/services/rideRequestServices/rideRequestServices.dart';
import 'package:sizer/sizer.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  Completer<GoogleMapController> mapControllerDriver = Completer();
  GoogleMapController? mapController;
  String? rideID;
  DatabaseReference? ref;
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      rideID = context
          .read<RideRequestProviderDriver>()
          .rideRequestData!
          .riderProfile
          .mobileNumber!;
      ref = FirebaseDatabase.instance.ref().child('RideRequest/$rideID');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(100.w, 10.h),
        child: StreamBuilder(
          stream: ref!.onValue,
          builder: (context, event) {
            if (event.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: black,
                ),
              );
            }
            if (event.data != null) {
              RideRequestModel rideRequestData = RideRequestModel.fromMap(
                  jsonDecode(jsonEncode(event.data!.snapshot.value))
                      as Map<String, dynamic>);
              if (rideRequestData.rideStatus ==
                  RideRequestServicesDriver.getRideStatus(1)) {
                return PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  textStyle: AppTextStyles.body14,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10.sp),
                    fieldHeight: 50,
                    fieldWidth: 50,
                    activeFillColor: white,
                    inactiveColor: greyShade3,
                    inactiveFillColor: greyShade3,
                    selectedFillColor: white,
                    selectedColor: black,
                    activeColor: black,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: transparent,
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  controller: otpController,
                  onCompleted: (value) {},
                  onChanged: (value) {},
                  beforeTextPaste: (text) {
                    return true;
                  },
                );
              } else {
                return SwipeButton(
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
                        'End Ride',
                        style: AppTextStyles.body16Bold,
                      );
                    },
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: black,
                ),
              );
            }
          },
        ),
      ),
      body: Consumer<RideRequestProviderDriver>(
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
                markers: rideRequestProvider.driverMarker,
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
    );
  }
}
