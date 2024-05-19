import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sanchalan/common/model/rideRequestModel.dart';

class RideDetails {
  final String driverName;
  final String vehicleNumber;
  final String startLocation;
  final String endLocation;
  final DateTime rideDate;
  final double fare;

  RideDetails({
    required this.driverName,
    required this.vehicleNumber,
    required this.startLocation,
    required this.endLocation,
    required this.rideDate,
    required this.fare,
  });
}

class RideReceiptScreen extends StatelessWidget {
  // final RideDetails rideDetails;

  const RideReceiptScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    RideRequestModel currentRideData = RideRequestModel.fromMap(
      jsonDecode(jsonEncode(context)) as Map<String, dynamic>,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Receipt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Ride Receipt',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            buildRideDetail(
                'Driver Name:', currentRideData.driverProfile!.name!),
            buildRideDetail('Vehicle Number:',
                currentRideData.driverProfile!.vehicleRegistrationNumber!),
            buildRideDetail(
                'Start Location:', currentRideData.pickupLocation.name!),
            buildRideDetail(
                'End Location:', currentRideData.dropLocation.name!),
            buildRideDetail(
                'Ride Date:',
                DateFormat('yyyy-MM-dd – kk:mm')
                    .format(currentRideData.rideEndTime!)),
            buildRideDetail('Fare:', '₹ ${currentRideData.fare}'),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle action such as saving the receipt or sharing it
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Receipt action performed')));
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRideDetail(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(detail),
          ),
        ],
      ),
    );
  }
}
