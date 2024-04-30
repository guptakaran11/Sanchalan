// ignore_for_file: file_names
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sanchalan/common/controller/services/locationServices.dart';
import 'package:sanchalan/common/model/directionModel.dart';
import 'package:sanchalan/common/model/pickupNDropLocationModel.dart';
import 'package:sanchalan/common/model/rideRequestModel.dart';
import 'package:sanchalan/constant/constants.dart';
import 'package:sanchalan/constant/utils/colors.dart';

class RideRequestProviderDriver extends ChangeNotifier {
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(37.4, -122),
    zoom: 14,
  );
  Set<Marker> driverMarker = <Marker>{};
  Set<Polyline> polylineSet = {};
  Polyline? polyline;
  List<LatLng> polylineCoordinatesList = [];
  DirectionModel? directionDetails;
  BitmapDescriptor? carIconForMap;
  BitmapDescriptor? destinationIconForMap;
  BitmapDescriptor? pickupIconForMap;
  bool updateMarkerBool = false;
  PickupNDropLocationModel? dropLocation;
  PickupNDropLocationModel? pickupLocation;
  RideRequestModel? rideRequestData;
  bool movingFromCurrentLocationTopickupLocation = false;
  LatLng? rideAcceptLocation;

  updateTripPickupAndDropLocation(
      PickupNDropLocationModel pickupData, PickupNDropLocationModel dropData) {
    pickupLocation = pickupData;
    dropLocation = dropData;
    notifyListeners();
  }

  updateMovingFromCurrentLocationToPickupLocationStatus(bool newStatus) {
    movingFromCurrentLocationTopickupLocation = newStatus;
    notifyListeners();
  }

  updateUpdateMarkerStatus(bool newStatus) {
    updateMarkerBool = newStatus;
    notifyListeners();
  }

  updateRideAcceptLocation(LatLng location) {
    rideAcceptLocation = location;
    notifyListeners();
  }

  updateDirection(DirectionModel newDirection) {
    directionDetails = newDirection;
    notifyListeners();
  }

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
    driverMarker = <Marker>{};
    log('Driver Marker Is Empty');
    log(driverMarker.toString());
    Marker pickupMarker = Marker(
      markerId: const MarkerId('PickupMarker'),
      position: movingFromCurrentLocationTopickupLocation
          ? rideAcceptLocation!
          : LatLng(
              pickupLocation!.latitude!,
              pickupLocation!.longitude!,
            ),
      icon: pickupIconForMap!,
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId('PickupMarker'),
      position: movingFromCurrentLocationTopickupLocation
          ? LatLng(pickupLocation!.latitude!, pickupLocation!.longitude!)
          : LatLng(dropLocation!.latitude!, dropLocation!.longitude!),
      icon: destinationIconForMap!,
    );
    if (updateMarkerBool == true) {
      LatLng currLocation = await LocationServices.getCurrentlocation();
      Marker carMarker = Marker(
        markerId: MarkerId(auth.currentUser!.phoneNumber!),
        position: LatLng(
          currLocation.latitude,
          currLocation.longitude,
        ),
        icon: carIconForMap!,
      );
      driverMarker.add(carMarker);
    }
    driverMarker.add(pickupMarker);
    driverMarker.add(destinationMarker);
    notifyListeners();
    if (updateMarkerBool == true) {
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

  decodePolyLineAndUpdatePolyLineField() {
    PolylinePoints polylinePoints = PolylinePoints();
    polylineCoordinatesList.clear();
    polylineSet.clear();
    List<PointLatLng> data =
        polylinePoints.decodePolyline(directionDetails!.polylinePoints);

    if (data.isEmpty) {
      for (var latLngPoints in data) {
        polylineCoordinatesList.add(LatLng(
          latLngPoints.latitude,
          latLngPoints.longitude,
        ));
      }
    }
    polyline = Polyline(
      polylineId: const PolylineId('TripPolyline'),
      color: black,
      points: polylineCoordinatesList,
      jointType: JointType.round,
      width: 3,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );
    polylineSet.add(polyline!);
    notifyListeners();
  }
}
