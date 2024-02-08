// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sanchalan/common/model/pickupNDropLocationModel.dart';
import 'package:sanchalan/common/model/searchedAddressModel.dart';

class LocationProvider extends ChangeNotifier {
  List<SearchedAddressModel> searchedAddress = [];
  PickupNDropLocationModel? dropLocation;
  PickupNDropLocationModel? pickupLocation;

  nullifyDropLocation() {
    dropLocation = null;
    notifyListeners();
  }

  nullifyPickupLocation() {
    pickupLocation = null;
    notifyListeners();
  }

  updateSearchedAddress(List<SearchedAddressModel> newAdddressList) {
    searchedAddress = newAdddressList;
    notifyListeners();
  }

  emptySearchedAddressList() {
    searchedAddress = [];
    notifyListeners();
  }

  updateDropLocation(PickupNDropLocationModel newAddress) {
    dropLocation = newAddress;
    notifyListeners();
  }

  updatePickupLocation(PickupNDropLocationModel newAddress) {
    pickupLocation = newAddress;
    notifyListeners();
  }
}
