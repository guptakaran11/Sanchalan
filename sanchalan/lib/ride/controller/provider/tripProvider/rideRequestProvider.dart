import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sanchalan/common/model/directionModel.dart';
import 'package:sanchalan/common/model/pickupNDropLocationModel.dart';
import 'package:sanchalan/constant/utils/colors.dart';

class RideRequestProvider extends ChangeNotifier {
  Set<Marker> riderMarker = <Marker>{};
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
    updateMarkerTool = newStatus;
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
}
