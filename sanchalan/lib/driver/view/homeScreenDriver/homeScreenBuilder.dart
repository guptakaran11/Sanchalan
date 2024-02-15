import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sanchalan/common/model/profileModelData.dart';
import 'package:sanchalan/constant/constants.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/driver/view/homeScreenDriver/driverHomeScreen.dart';
import 'package:sanchalan/driver/view/homeScreenDriver/tripScreen.dart';

class DriverHomeScreenBuilder extends StatefulWidget {
  const DriverHomeScreenBuilder({super.key});

  @override
  State<DriverHomeScreenBuilder> createState() =>
      _DriverHomeScreenBuilderState();
}

class _DriverHomeScreenBuilderState extends State<DriverHomeScreenBuilder> {
  DatabaseReference driverProfileRef = FirebaseDatabase.instance
      .ref()
      .child('User/${auth.currentUser!.phoneNumber}');
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: driverProfileRef.onValue,
        builder: (context, event) {
          if (event.connectionState == ConnectionState.waiting) {
            return const HomeScreenDriver();
          }
          if (event.data != null) {
            ProfileDataModel profileData = ProfileDataModel.fromMap(
                jsonDecode(jsonEncode(event.data!.snapshot.value))
                    as Map<String, dynamic>);
            if (profileData.activateRideRequestID != null) {
              return const TripScreen();
            } else {
              return const HomeScreenDriver();
            }
          } else {
            return const HomeScreenDriver();
          }
        });
  }
}
