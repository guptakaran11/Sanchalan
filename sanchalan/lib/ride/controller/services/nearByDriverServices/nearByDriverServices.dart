import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sanchalan/ride/controller/provider/tripProvider/rideRequestProvider.dart';
import 'package:sanchalan/ride/model/nearbyDriversModel.dart';

class NearByDriverServices {
  static getNearByDriver(LatLng pickupLocation, BuildContext context) {
    Geofire.initialize('OnlineDrivers');
    Geofire.queryAtLocation(
      pickupLocation.latitude,
      pickupLocation.longitude,
      20,
    )!
        .listen((event) {
      if (event != null) {
        var callback = event['callback'];
        switch (callback) {
          case Geofire.onKeyEntered:
            NearByDriversModel model = NearByDriversModel(
              driverID: event['Key'],
              latitude: event['latitude'],
              longitude: event['longitude'],
            );
            context.read<RideRequestProvider>().addDriver(model);
            if (context.read<RideRequestProvider>().fetchNearByDrivers ==
                true) {
              context.read<RideRequestProvider>().updateMarker();
            }
            break;
          case Geofire.onKeyExited:
            context
                .read<RideRequestProvider>()
                .removeDriver(event['Key'].toString());
            context.read<RideRequestProvider>().updateMarker();
            log('Driver Removed ${event['Key']}');
            break;
          case Geofire.onKeyMoved:
            NearByDriversModel model = NearByDriversModel(
              driverID: event['Key'],
              latitude: event['latitude'],
              longitude: event['longitude'],
            );
            context.read<RideRequestProvider>().updateNearByLocation(model);
            context.read<RideRequestProvider>().updateMarker();
            break;
          case Geofire.onGeoQueryReady:
            log(context
                .read<RideRequestProvider>()
                .nearbyDrivers
                .length
                .toString());
            context.read<RideRequestProvider>().updateMarker();
            break;
        }
      }
    });
  }
}
