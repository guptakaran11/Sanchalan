
# Sanchalan: Your Ultimate Ride Booking App

Welcome to Sanchalan, a Flutter application designed for booking rides with multiple car types. This app provides a seamless experience for both riders and drivers. It utilizes Google API for maps and Geolocator for location services.


## Features

**Rider Section:**
- **Book a Ride:** Riders can effortlessly book rides to their desired destinations. Whether it’s a quick commute or a long trip, Sanchalan offers convenience at your fingertips.
- **Choose Car Type:** Explore available cars, view their features, and choose the one that suits your preferences. From economy cars to luxury sedans, Sanchalan caters to diverse needs.
- **Transparent Billing:** No surprises! Sanchalan provides upfront pricing, ensuring transparency in fare calculation. Riders can review costs before confirming their bookings.
- **Real-Time Tracking:** Track your ride in real time using the integrated map. Know exactly where your driver is and when they’ll arrive.
- **Secure Payments:** Make cashless payments through the app. Sanchalan supports various payment methods for hassle-free transactions.

**Driver Section:**
- **Driver Verification:** Safety first! Drivers undergo a thorough verification process. They must provide their car’s registration number (RC), driving license, and other necessary documents.
- **Accept Ride Requests:** Drivers receive ride requests based on their availability. Accept or decline requests as per your schedule.
- **Efficient Navigation:** Sanchalan uses Google Maps API for precise navigation. Drivers can find optimal routes and reach riders promptly.
- **Earnings and Payouts:** Drivers can track their earnings, view completed trips, and receive timely payouts.
- **Emergency Assistance:** In case of emergencies, drivers can quickly access support and assistance through the app.



## Installation
To get started with Sanchalan, follow these steps:

- Clone the repository to your local machine:

```bash
  git clone https://github.com/guptakaran11/Sanchalan.git
```
- Navigate to the project directory.

```bash
  cd Sanchalan
```
- Configure Google API:
- Obtain API keys for Google Maps from the Google Cloud Console and Replace the placeholder API keys in the project with your own keys..

- Install dependencies using Flutter's package manager, pub.

```bash
  flutter pub get
```

- Run the app on your preferred device (emulator/simulator or physical device).

```bash
  flutter run
```


## Tech Stack

**Flutter:** The UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.

**Provider:**  A state management library for Flutter that works seamlessly with Flutter's devtools and enables a reactive programming style.

**Google Maps API:**  Used for displaying maps and providing location-related services.

**HTTP Package:**  A composable, multi-platform, Future-based API for HTTP requests.

**Geolocator:**  A Flutter plugin for geolocation services.


## Contributing

Contributions are always welcome!

Feel free if you have any suggestions, bug reports, or feature requests, please open an issue or submit a pull request.

See `contributing.md` for ways to get started.

Please adhere to this project's `code of conduct`.

Please find the `RequirementFile.txt` in the project files to find out the dependencies requied to run this project. 


## API Reference

#### Get geocodeAPI

```bash
  GET 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapsPlatformcredential'
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `mapsPlatformcredential` | `string` | **Required**. Your API key |
| `latitude` | `string` | **Required**. Your Place latitude |
| `longitude` | `string` | **Required**. Your place longitude |

#### Get placesAPI

```bash
  GET 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapsPlatformcredential&sessiontoken=123254251&components=country:ind'
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `mapsPlatformcredential` | `string` | **Required**. Your API key |
| `placeName` | `string` | **Required**. Your placeName |

#### Get directionAPI

```bash
  GET 'https://maps.googleapis.com/maps/api/directions/json?origin=${pickup.latitude},${pickup.longitude}&destination=${drop.latitude},${drop.longitude}&mode=driving&key=$mapsPlatformcredential '
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `mapsPlatformcredential` | `string` | **Required**. Your API key |
| `latitude` | `string` | **Required**. Your Place latitude |
| `longitude` | `string` | **Required**. Your place longitude |

#### Get getLatLngFromPlaceIDAPI

```bash
  GET 'https://maps.googleapis.com/maps/api/place/details/json?placeid= $placeId&Key= $mapsPlatformcredential'
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `mapsPlatformcredential` | `string` | **Required**. Your API key |
| `placeId` | `string` | **Required**. Your placeId |




