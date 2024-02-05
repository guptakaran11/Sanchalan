// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sanchalan/common/controller/provider/locationProvider.dart';
import 'package:sanchalan/common/controller/services/APIsNKeys/apis.dart';
import 'package:http/http.dart' as http;
import 'package:sanchalan/common/controller/services/toastService.dart';
import 'package:sanchalan/common/model/pickupNDropLocationModel.dart';
import 'package:sanchalan/common/model/searchedAddressModel.dart';

class LocationServices {
  static getCurrentlocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        getCurrentlocation();
      }
    }
    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    LatLng currentlocation = LatLng(
      currentPosition.latitude,
      currentPosition.longitude,
    );
    return currentlocation;
  }

  static Future getAddressFromLatLng({
    required LatLng position,
    required BuildContext context,
  }) async {
    final api = Uri.parse(APIs.geoCodingAPI(position));
    try {
      var response = await http
          .get(api, headers: {'Content-Type': 'application/json'}).timeout(
              const Duration(seconds: 60), onTimeout: () {
        ToastService.sendScaffoldAlert(
          msg: 'Opps! Connection Timed Out',
          toastStatus: 'ERROR',
          context: context,
        );
        throw TimeoutException('Connection Timed Out');
      });

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        PickupNDropLocationModel model = PickupNDropLocationModel(
          name: decodedResponse['results'][0][
              'formatted_address'], //this is wrong import these from the cloud console
          // description:,
          placeID: decodedResponse['results'][0][
              'place_id'], // same as in this it is wrong it import from the api
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString(),
        );
        return model;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future getSearchedAddress({
    required String placeName,
    required BuildContext context,
  }) async {
    List<SearchedAddressModel> address = [];
    final api = Uri.parse(APIs.placesAPI(placeName));
    try {
      var response = await http
          .get(api, headers: {'Content-Type': 'application/json'}).timeout(
              const Duration(seconds: 60), onTimeout: () {
        ToastService.sendScaffoldAlert(
          msg: 'Opps! Connection Timed Out',
          toastStatus: 'ERROR',
          context: context,
        );
        throw TimeoutException('Connection Timed Out');
      });

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        for (var data in decodedResponse['predictions']) {
          // in this it is wrote as in video in this we have to import from plces api then predictions form the console
          address.add(SearchedAddressModel(
            mainName: data['structured_formatting'][
                'main_text'], //these all three fields is written same as in the video so correct it from the console
            secondaryName: data['structured_formatting']['secondary_text'],
            placeId: data['place_id'],
          ));
        }
        context.read<LocationProvider>().updateSearchedAddress(address);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static getLatLngFromPlaceID(SearchedAddressModel address,
      BuildContext context, String locationtype) async {
    final api = Uri.parse(APIs.getLatLngFromPlaceIDAPI(address.placeId));

    try {
      var response = await http
          .get(api, headers: {'Content-Type': 'application/json'}).timeout(
              const Duration(seconds: 60), onTimeout: () {
        ToastService.sendScaffoldAlert(
          msg: 'Opps! Connection Timed Out',
          toastStatus: 'ERROR',
          context: context,
        );
        throw TimeoutException('Connection Timed Out');
      });
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        var locationLatLng = decodedResponse['result']['geometry']['location'];
        PickupNDropLocationModel model = PickupNDropLocationModel(
          name: address.mainName,
          description: address.secondaryName,
          placeID: address.placeId,
          latitude: locationLatLng['lat'],
          longitude: locationLatLng['lng'],
        );
        if (locationtype == 'DROP') {
          context.read<LocationProvider>().updateDropLocation(model);
        } else {}
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
