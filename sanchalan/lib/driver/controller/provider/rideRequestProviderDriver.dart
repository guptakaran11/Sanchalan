import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sanchalan/common/model/directionModel.dart';
import 'package:sanchalan/common/model/pickupNDropLocationModel.dart';
import 'package:sanchalan/common/model/rideRequestModel.dart';
import 'package:sanchalan/constant/constants.dart';

class RideRequestProviderDriver extends ChangeNotifier {
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(37.4, -122),
    zoom: 14,
  );
  Set<Marker> driverMarker = Set<Marker>();
  Set<Polyline> polylineSet = {};
  Polyline? polyline;
  List<LatLng> polylineCoordinatesList = [];
  DirectionModel? directionDetails;
  BitmapDescriptor? carIconForMap;
  BitmapDescriptor? destinationIconForMap;
  BitmapDescriptor? pickupIconForMap;
  bool updateMarkerTool = false;
  PickupNDropLocationModel? dropLocation;
  PickupNDropLocationModel? pickupLocation;
  RideRequestModel? rideRequestData;

  updateRideRequestData(RideRequestModel data) {
    rideRequestData = data;
    notifyListeners();
  }

  createIcons(BuildContext context) {
    if (pickupIconForMap == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        'assets/images/icons/pickupPng.png',
      ).then((icon) {
        pickupIconForMap = icon;
        notifyListeners();
      });
      if (destinationIconForMap == null) {
        ImageConfiguration imageConfiguration =
            createLocalImageConfiguration(context, size: const Size(2, 2));
        BitmapDescriptor.fromAssetImage(
          imageConfiguration,
          'assets/images/icons/dropPng.png',
        ).then((icon) {
          destinationIconForMap = icon;
          notifyListeners();
        });
        if (carIconForMap == null) {
          ImageConfiguration imageConfiguration =
              createLocalImageConfiguration(context, size: const Size(2, 2));
          BitmapDescriptor.fromAssetImage(
            imageConfiguration,
            'assets/images/vehicle/mapCar.png',
          ).then((icon) {
            carIconForMap = icon;
            notifyListeners();
          });
        }
      }
    }
  }

  updateMarker() async {
    driverMarker.clear();
    Marker pickupMarker = Marker(
      markerId: const MarkerId('PickupMarker'),
      position: LatLng(
        pickupLocation!.latitude!,
        pickupLocation!.longitude!,
      ),
      icon: pickupIconForMap!,
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId('PickupMarker'),
      position: LatLng(
        dropLocation!.latitude!,
        dropLocation!.longitude!,
      ),
      icon: pickupIconForMap!,
    );
    if (updateMarkerTool == true) {
      Marker carMarker = Marker(
        markerId: MarkerId(auth.currentUser!.phoneNumber!),
        position: LatLng(
          pickupLocation!.latitude!,
          pickupLocation!.longitude!,
        ),
        icon: carIconForMap!,
      );
      driverMarker.add(carMarker);
    }
    driverMarker.add(pickupMarker);
    driverMarker.add(destinationMarker);
    notifyListeners();
    if (updateMarkerTool == true) {
      await Future.delayed(
        const Duration(
          seconds: 5,
        ),
        () async {
          await updateMarker();
        },
      );
    }
  }
}
