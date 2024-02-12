// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sanchalan/common/controller/services/toastService.dart';
import 'package:sanchalan/common/model/rideRequestModel.dart';
import 'package:sanchalan/constant/constants.dart';

class RideRequestServicesDriver {
  static checkRideAvailability(BuildContext context, String rideID) async {
    DatabaseReference? tripRef =
        FirebaseDatabase.instance.ref().child('RideRequest/$rideID');
    final snapshot = await tripRef.get();
    if (snapshot.exists) {
      Stream<DatabaseEvent> stream = tripRef.onValue;
      stream.listen((event) async {
        final checkSnapshotExists = await tripRef.get();
        if (checkSnapshotExists.exists) {
          RideRequestModel rideRequestModel = RideRequestModel.fromMap(
              jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>);
          if (rideRequestModel.driverProfile != null) {
            audioPlayer.stop();
            Navigator.pop(context);
            ToastService.sendScaffoldAlert(
              msg: 'Opps! Trip Accepted by Someone',
              toastStatus: 'ERROR',
              context: context,
            );
          }
        } else {
          audioPlayer.stop();
          Navigator.pop(context);
          ToastService.sendScaffoldAlert(
            msg: 'Opps! Ride Was Cancelled',
            toastStatus: 'ERROR',
            context: context,
          );
        }
      });
    } else {
      Navigator.pop(context);
    }
  }

  static getRideRequestData(String rideID) async {
    DatabaseReference? tripRef =
        FirebaseDatabase.instance.ref().child('RideRequest/$rideID');
    final snapshot = await tripRef.get();
    if (snapshot.exists) {
      RideRequestModel rideRequestModel = RideRequestModel.fromMap(
          jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>);
      return rideRequestModel;
    }
  }

  static updateRideRequestStatus(String rideRequestStatus, String rideID) {
    DatabaseReference tripRef =
        FirebaseDatabase.instance.ref().child('RideRequest/$rideID/rideStatus');
    tripRef.set(rideRequestStatus);
  }

  static getRideStatus(int rideStatusNum) {
    switch (rideStatusNum) {
      case 0:
        return 'WAITING_FOR_RIDE_REQUEST';
      case 1:
        return 'WAITING_FOR_DRIVER_TO_ARRIVE';
      case 2:
        return 'MOVING_TOWARDS_DESTINATION';
      case 3:
        return 'RIDE_COMPLETED';
    }
  }

  static updateRideRequestID(String rideID) {
    DatabaseReference tripRef = FirebaseDatabase.instance
        .ref()
        .child('User/${auth.currentUser!.phoneNumber}/activeRideRequestID');
    tripRef.set(rideID);
  }
}
