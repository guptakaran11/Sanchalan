// ignore_for_file: file_names, unused_local_variable
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sanchalan/common/controller/services/APIsNKeys/apis.dart';
import 'package:sanchalan/common/controller/services/APIsNKeys/keys.dart';
import 'package:sanchalan/common/model/profileModelData.dart';
import 'package:sanchalan/common/model/rideRequestModel.dart';
import 'package:sanchalan/constant/constants.dart';
import 'package:http/http.dart' as http;

import 'pushNotificationDialogue.dart';

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
          firebaseMessagingForeGroundHandlerDriver(message, context);
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

  static firebaseMessagingForeGroundHandlerDriver(
      RemoteMessage message, BuildContext context) async {
    String rideID = getRideRequestID(message);
    fetchRideRequestInfo(rideID, context);
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

        PushNotificationDialogue.rideRequestDialogue(
          rideRequestModel,
          context,
        );
      }
    }).onError((error, stackTrace) {
      throw Exception(error);
    });
  }

  static subscribeToNotification(ProfileDataModel model) {
    if (model.userType == 'DRIVER') {
      firebaseMessaging.subscribeToTopic('DRIVER');
      firebaseMessaging.subscribeToTopic('USER');
    } else {
      firebaseMessaging.subscribeToTopic('RIDER');
      firebaseMessaging.subscribeToTopic('USER');
    }
  }

  static initializeFirebaseMessagingForUsers(
    ProfileDataModel profileData,
    BuildContext context,
  ) {
    initializeFirebaseMessaging(profileData, context);
    getToken(profileData);
    subscribeToNotification(profileData);
  }

  static sendRideRequestToNearByDrivers(String driveFCMToken) async {
    try {
      final api = Uri.parse(APIs.pushNotificationAPI());
      var body = jsonEncode({
        "to": driveFCMToken,
        "notification": {
          "body": "New Ride Request In your Location",
          "title": "Ride Request"
        },
        "data": {
          "rideRequestID": auth.currentUser!.phoneNumber!,
        }
      });
      var response = await http
          .post(api,
              headers: {
                'Content-Type': 'application/json',
                'Authorizatin': 'key=$fcmServerKey'
              },
              body: body)
          .then((value) {
        log('Successfully send Ride Request');
      }).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw TimeoutException('Connection Timed Out');
        },
      ).onError((error, stackTrace) {
        throw Exception(error);
      });
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
