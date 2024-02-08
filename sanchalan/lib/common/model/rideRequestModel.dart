// ignore_for_file: public_member_api_docs, sort_constructors_first, file_names
import 'dart:convert';
import 'package:sanchalan/common/model/pickupNDropLocationModel.dart';
import 'package:sanchalan/common/model/profileModelData.dart';

class RideRequestModel {
  DateTime rideCreatTime;
  ProfileDataModel riderProfile;
  ProfileDataModel? driverProfile;
  PickupNDropLocationModel pickupLocation;
  PickupNDropLocationModel dropLocation;
  String fare;
  String carTrpe;
  String rideStatus;
  String otp;
  RideRequestModel({
    required this.rideCreatTime,
    required this.riderProfile,
    this.driverProfile,
    required this.pickupLocation,
    required this.dropLocation,
    required this.fare,
    required this.carTrpe,
    required this.rideStatus,
    required this.otp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rideCreatTime': rideCreatTime.millisecondsSinceEpoch,
      'riderProfile': riderProfile.toMap(),
      'driverProfile': driverProfile?.toMap(),
      'pickupLocation': pickupLocation.toMap(),
      'dropLocation': dropLocation.toMap(),
      'fare': fare,
      'carTrpe': carTrpe,
      'rideStatus': rideStatus,
      'otp': otp,
    };
  }

  factory RideRequestModel.fromMap(Map<String, dynamic> map) {
    return RideRequestModel(
      rideCreatTime:
          DateTime.fromMillisecondsSinceEpoch(map['rideCreatTime'] as int),
      riderProfile:
          ProfileDataModel.fromMap(map['riderProfile'] as Map<String, dynamic>),
      driverProfile: map['driverProfile'] != null
          ? ProfileDataModel.fromMap(
              map['driverProfile'] as Map<String, dynamic>)
          : null,
      pickupLocation: PickupNDropLocationModel.fromMap(
          map['pickupLocation'] as Map<String, dynamic>),
      dropLocation: PickupNDropLocationModel.fromMap(
          map['dropLocation'] as Map<String, dynamic>),
      fare: map['fare'] as String,
      carTrpe: map['carTrpe'] as String,
      rideStatus: map['rideStatus'] as String,
      otp: map['otp'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RideRequestModel.fromJson(String source) =>
      RideRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
