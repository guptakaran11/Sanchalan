import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sanchalan/common/controller/services/APIsNKeys/keys.dart';

class APIs {
  static geoCodingAPI(LatLng position) =>
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapsPlatformcredential'; //  i wrote as it from the video in this we have to put the api for the location from the google cloud console

  static placesAPI(String placeName) =>
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapsPlatformcredential&sessiontoken=123254251&components=<Country>'; // I wrote as in video in this we have to use the places api from the cloud console
}

//  to  check the correction is in section 5 and 6th for location and apis