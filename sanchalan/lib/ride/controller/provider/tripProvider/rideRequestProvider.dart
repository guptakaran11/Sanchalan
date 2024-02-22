// ignore_for_file: file_names

import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sanchalan/common/controller/services/firebasePushNotificationsServices/pushNotificationServices.dart';
import 'package:sanchalan/common/controller/services/profileDataCRUDServices.dart';
import 'package:sanchalan/common/model/directionModel.dart';
import 'package:sanchalan/common/model/pickupNDropLocationModel.dart';
import 'package:sanchalan/common/model/profileModelData.dart';
import 'package:sanchalan/constant/constants.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/ride/model/nearbyDriversModel.dart';

class RideRequestProvider extends ChangeNotifier {
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(37.4, -122),
    zoom: 14,
  );
  Set<Marker> riderMarker = Set<Marker>();
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
  int sanchalanGoFare = 0;
  int sanchalanGoSedanFare = 0;
  int sanchalanPremierFare = 0;
  int sanchalanXLFare = 0;
  // Fetch Nearby Drivers List
  bool fetchNearByDrivers = false;
  List<NearByDriversModel> nearbyDrivers = [];
  bool placedRideRequest = false;

  updatePlacedRideRequestStatus(bool newStatus) {
    placedRideRequest = newStatus;
    notifyListeners();
  }

  makeFareZero() {
    sanchalanGoFare = 0;
    sanchalanGoSedanFare = 0;
    sanchalanPremierFare = 0;
    sanchalanXLFare = 0;
    notifyListeners();
  }

  getFare() {
    int baseFare = 50;
    int sanchalanGoDistancePerKM = 12;
    int sanchalanGoSedanDistancePerKM = 15;
    int sanchalanPremierDistancePerKM = 17;
    int sanchalanXLDistancePerKM = 20;
    int sanchalanGoDurationPerMinute = 1;
    int sanchalanGoSedanDurationPerMinute = 2;
    double sanchalanPrimierDurationPerMinute = 2.5;
    int sanchalanXLDurationPerMinute = 3;

    sanchalanGoFare = (baseFare +
            sanchalanGoDistancePerKM *
                double.parse(
                    (directionDetails!.distanceInMeter / 1000).toString()) +
            (sanchalanGoDurationPerMinute * (directionDetails!.duration / 60)))
        .round();
    sanchalanGoSedanFare = (baseFare +
            sanchalanGoSedanDistancePerKM *
                double.parse(
                    (directionDetails!.distanceInMeter / 1000).toString()) +
            (sanchalanGoSedanDurationPerMinute *
                (directionDetails!.duration / 60)))
        .round();
    sanchalanPremierFare = (baseFare +
            sanchalanPremierDistancePerKM *
                double.parse(
                    (directionDetails!.distanceInMeter / 1000).toString()) +
            (sanchalanPrimierDurationPerMinute *
                (directionDetails!.duration / 60)))
        .round();
    sanchalanXLFare = (baseFare +
            sanchalanXLDistancePerKM *
                double.parse(
                    (directionDetails!.distanceInMeter / 1000).toString()) +
            (sanchalanXLDurationPerMinute * (directionDetails!.duration / 60)))
        .round();
    notifyListeners();
  }

  updateRidePickupAndDropLocation(
    PickupNDropLocationModel pickup,
    PickupNDropLocationModel drop,
  ) {
    pickupLocation = pickup;
    dropLocation = drop;
    notifyListeners();
    log('PICKUP and DROP LOCATION IS');
    log(pickupLocation!.toMap().toString());
    log(dropLocation!.toMap().toString());
  }

  updateUpdateMarkerBool(bool newStatus) {
    updateMarkerBool = newStatus;
    notifyListeners();
  }

  updateDirection(DirectionModel newDirection) {
    directionDetails = newDirection;
    notifyListeners();
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
    riderMarker.clear();
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
      icon: destinationIconForMap!,
    );
    if (fetchNearByDrivers == true) {
      math.Random random = math.Random();
      for (var driver in nearbyDrivers) {
        double rotation = random.nextInt(360).toDouble();
        Marker carMarker = Marker(
          markerId: MarkerId(driver.driverID),
          rotation: rotation,
          position: LatLng(
            driver.latitude,
            driver.longitude,
          ),
          icon: carIconForMap!,
        );
        riderMarker.add(carMarker);
      }
    }
    if (updateMarkerBool == true) {
      Marker carMarker = Marker(
        markerId: MarkerId(auth.currentUser!.phoneNumber!),
        position: LatLng(
          pickupLocation!.latitude!,
          pickupLocation!.longitude!,
        ),
        icon: carIconForMap!,
      );
      riderMarker.add(carMarker);
    }
    riderMarker.add(pickupMarker);
    riderMarker.add(destinationMarker);
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

// ! Nearby Drivers Functions
  sendPushNotificationToNearByDrivers() async {
    for (var driver in nearbyDrivers) {
      ProfileDataModel driverProfileData =
          await ProfileDataCRUDServices.getProfileDataFromRealTimeDatabase(
              driver.driverID);
      await PushNotificationServices.sendRideRequestToNearByDrivers(
          driverProfileData.cloudMessagingToken!);
    }
  }

  updateFetchNearByDrivers(bool newStatus) {
    fetchNearByDrivers == newStatus;
    notifyListeners();
  }

  addDriver(NearByDriversModel driver) {
    nearbyDrivers.add(driver);
    notifyListeners();
  }

  removeDriver(String driverID) {
    int index =
        nearbyDrivers.indexWhere((element) => element.driverID == driverID);
    nearbyDrivers.removeAt(index);
    notifyListeners();
  }

  updateNearByLocation(NearByDriversModel driver) {
    int index = nearbyDrivers
        .indexWhere((element) => element.driverID == driver.driverID);
    nearbyDrivers[index].longitude = driver.longitude;
    nearbyDrivers[index].latitude = driver.latitude;
    notifyListeners();
  }
}
