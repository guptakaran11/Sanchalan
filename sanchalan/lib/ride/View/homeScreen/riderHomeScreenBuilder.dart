import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:sanchalan/common/model/profileModelData.dart';
import 'package:sanchalan/constant/constants.dart';
import 'package:sanchalan/driver/view/homeScreenDriver/tripScreen.dart';
import 'package:sanchalan/ride/View/bookARideScreen/bookARideScreen.dart';
import 'package:sanchalan/ride/View/homeScreen/riderHomeSceen.dart';

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
