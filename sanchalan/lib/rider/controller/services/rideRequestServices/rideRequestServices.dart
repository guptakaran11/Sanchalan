// ignore_for_file: file_names
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:sanchalan/common/controller/services/toastService.dart';
import 'package:sanchalan/common/model/rideRequestModel.dart';
import 'package:sanchalan/constant/constants.dart';

class RideRequestServices {
  static createNewRideRequest(
      RideRequestModel rideRequestModel, BuildContext context) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child('RideRequest/${auth.currentUser!.phoneNumber}');
    await ref.set(rideRequestModel.toMap()).then((value) {
      ToastService.sendScaffoldAlert(
        msg: 'Ride Request Registered Successful',
        toastStatus: 'SUCCESS',
        context: context,
      );
    }).onError((error, stackTrace) {
      ToastService.sendScaffoldAlert(
        msg: 'ERROR! Creating new Ride Request ',
        toastStatus: 'ERROR',
        context: context,
      );
    });
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

  static cancelRideRequest(BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child('RideRequest/${auth.currentUser!.phoneNumber}')
        .remove()
        .then((value) {});
    Navigator.pop(context);
    
  }
}
