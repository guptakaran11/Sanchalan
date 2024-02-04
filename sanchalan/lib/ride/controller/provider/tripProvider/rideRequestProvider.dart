import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sanchalan/common/model/directionModel.dart';

class RideRequestProvider extends ChangeNotifier {
  Set<Marker> riderMarker = <Marker>{};
  Set<Polyline> polylineSet = {};
  Polyline? polyline;
  List<LatLng> polylineCoordinatesList = [];
  DirectionModel? directionDetails;
  BitmapDescriptor? carIconForMap;
  BitmapDescriptor? destinationIconForMap;
  BitmapDescriptor? pickupIconForMap;

  updateDirection(DirectionModel newDirection) {
    directionDetails = newDirection;
    notifyListeners();
  }

  decodePolyLineAndUpdatePolyLineField() {
    PolylinePoints polylinePoints = PolylinePoints();
    polylineCoordinatesList.clear();
  }
}
