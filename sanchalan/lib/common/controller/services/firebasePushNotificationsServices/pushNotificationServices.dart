import 'dart:convert';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sanchalan/common/model/profileModelData.dart';
import 'package:sanchalan/common/model/rideRequestModel.dart';
import 'package:sanchalan/constant/constants.dart';

class PushNotificationServices {
  // Initializing firebase  messaging instance
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static Future initializeFirebaseMessaging(
      ProfileDataModel profileData, BuildContext context) async {
    await firebaseMessaging.requestPermission();
    if (profileData.userType == 'DRIVER') {
      FirebaseMessaging.onBackgroundMessage(
          firebaseMessagingBackGroundHandlerDriver);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          firebaseMessagingForeGroundHandlerDriver(message);
        }
      });
    } else {
      FirebaseMessaging.onBackgroundMessage(
          firebaseMessagingBackGroundHandlerRider);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          firebaseMessagingForeGroundHandlerRider(message);
        }
      });
    }
  }

  static getRideRequestID(RemoteMessage message) {
    String rideID = message.data['rideRequestID'];
    log(rideID);
    return rideID;
  }

  // ! Rider Cloud messaging Functions

  static Future<void> firebaseMessagingBackGroundHandlerRider(
      RemoteMessage message) async {}

  static firebaseMessagingForeGroundHandlerRider(RemoteMessage message) async {}

  // ! Driver cloud messaging Functions

  static Future<void> firebaseMessagingBackGroundHandlerDriver(
      RemoteMessage message) async {
    String riderID = getRideRequestID(message);
  }

  static firebaseMessagingForeGroundHandlerDriver(RemoteMessage message) async {
    String riderID = getRideRequestID(message);
  }

  // ! ******************************************************

  static Future getToken(ProfileDataModel model) async {
    String? token = await firebaseMessaging.getToken();
    log('Cloud Messaging Token is : $token');
    DatabaseReference tokenRef = FirebaseDatabase.instance
        .ref()
        .child('User/${auth.currentUser!.phoneNumber}/cloudMessagingToken');
    tokenRef.set(token);
  }

  static fetchRideRequestInfo(String rideID, BuildContext context) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child('RideRequest/$rideID');
    ref.once().then((databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        RideRequestModel rideRequestModel = RideRequestModel.fromMap(jsonDecode(
          jsonEncode(databaseEvent.snapshot.value),
        ) as Map<String, dynamic>);
        log(rideRequestModel.toMap().toString());
        // show the dialog to accept the request
      }
    }).onError((error, stackTrace) {
      throw Exception(error);
    });
  }
}
