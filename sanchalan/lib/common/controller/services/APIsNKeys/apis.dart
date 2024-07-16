import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sanchalan/common/controller/services/APIsNKeys/keys.dart';

// class APIs {
//   static geoCodingAPI(LatLng position) =>
//       'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapsPlatformcredential';
//   static placesAPI(String placeName) =>
//       'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapsPlatformcredential&sessiontoken=123254251&components=country:ind';
//   static directionAPI(LatLng pickup, LatLng drop) =>
//       'https://maps.googleapis.com/maps/api/directions/json?origin=${pickup.latitude},${pickup.longitude}&destination=${drop.latitude},${drop.longitude}&mode=driving&key=$mapsPlatformcredential ';

//   static getLatLngFromPlaceIDAPI(String placeId) =>
//       'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$mapsPlatformcredential';

//   static pushNotificationAPI() =>
//       'https://fcm.googleapis.com/fcm/send'; // it is written same as in playlist so correct it form the post api v60
// }

class APIs {
  static geoCoadingAPI(LatLng position) =>
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapsPlatformcredential';

  static placesAPI(String placeName) =>
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapsPlatformcredential&sessiontoken=123254251&components=country:ind';

  static directionAPI(LatLng pickup, LatLng drop) =>
      'https://maps.googleapis.com/maps/api/directions/json?origin=${pickup.latitude},${pickup.longitude}&destination=${drop.latitude},${drop.longitude}&mode=driving&key=$mapsPlatformcredential';

  static getLatLngFromPlaceIDAPI(String placeID) =>
      'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeID&key=$mapsPlatformcredential';

  static pushNotificationAPI() => 'https://fcm.googleapis.com/fcm/send';
}
