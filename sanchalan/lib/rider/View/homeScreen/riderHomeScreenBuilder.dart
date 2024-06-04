// ignore_for_file: file_names

//* Packages
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

//* Widgets
import 'package:sanchalan/constant/constants.dart';

//* Screens
import 'package:sanchalan/rider/View/bookARideScreen/bookARideScreen.dart';
import 'package:sanchalan/rider/View/homeScreen/riderHomeSceen.dart';

class RiderHomeScreenBuilder extends StatefulWidget {
  const RiderHomeScreenBuilder({super.key});

  @override
  State<RiderHomeScreenBuilder> createState() => _RiderHomeScreenBuilderState();
}

class _RiderHomeScreenBuilderState extends State<RiderHomeScreenBuilder> {
  DatabaseReference riderRideRequestRef = FirebaseDatabase.instance
      .ref()
      .child('RideRequest/${auth.currentUser!.phoneNumber}');
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: riderRideRequestRef.onValue,
        builder: (context, event) {
          if (event.connectionState == ConnectionState.waiting) {
            return const RiderHomeScreen();
          }
          if (event.data!.snapshot.value != null) {
            log('The Data is');
            log(event.data!.snapshot.value.toString());
            return const BookARideScreen();
          } else {
            return const RiderHomeScreen();
          }
        });
  }
}
