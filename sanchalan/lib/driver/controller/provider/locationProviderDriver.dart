// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProviderDriver extends ChangeNotifier {
  Position? position;

  updateDriverPosition(Position newPositon) {
    position = newPositon;
    notifyListeners();
  }
}
