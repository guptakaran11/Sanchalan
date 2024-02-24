// ignore_for_file: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanchalan/common/controller/provider/authProvider.dart';
import 'package:sanchalan/common/controller/provider/locationProvider.dart';
import 'package:sanchalan/common/controller/provider/profileDataProvider.dart';
import 'package:sanchalan/common/view/authScreens/loginScreen.dart';
import 'package:sanchalan/common/view/registrationScreen/registrationScreen.dart';
import 'package:sanchalan/common/view/signInLogic/signInLogic.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/driver/controller/provider/rideRequestProviderDriver.dart';
import 'package:sanchalan/driver/controller/services/bottomNavBarDriverProvider.dart';
import 'package:sanchalan/driver/controller/services/mapsProviderDriver.dart';
import 'package:sanchalan/firebase_options.dart';
import 'package:sanchalan/rider/controller/provider/bottomNavbarRiderProvider/bottomNavBarRiderProvider.dart';
import 'package:sanchalan/rider/controller/provider/tripProvider/rideRequestProvider.dart';
import 'package:sizer/sizer.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Sanchalan());
}

class Sanchalan extends StatefulWidget {
  const Sanchalan({super.key});

  @override
  State<Sanchalan> createState() => _SanchalanState();
}

class _SanchalanState extends State<Sanchalan> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, _, __) {
        return MultiProvider(
          providers: [
            // ! Common Providers
            ChangeNotifierProvider<MobileAuthProvider>(
                create: (_) => MobileAuthProvider()),
            ChangeNotifierProvider<LocationProvider>(
                create: (_) => LocationProvider()),
            ChangeNotifierProvider<ProfileDataProvider>(
                create: (_) => ProfileDataProvider()),
            // ! Riders Providers
            ChangeNotifierProvider<BottomNavBarRiderProvider>(
                create: (_) => BottomNavBarRiderProvider()),
            ChangeNotifierProvider<RideRequestProvider>(
                create: (_) => RideRequestProvider()),
            // ! Driver Providers
            ChangeNotifierProvider<BottomNavBarDriverProvider>(
                create: (_) => BottomNavBarDriverProvider()),
            ChangeNotifierProvider<MapsProviderDriver>(
                create: (_) => MapsProviderDriver()),
                ChangeNotifierProvider<RideRequestProviderDriver>(
                create: (_) => RideRequestProviderDriver()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                color: white,
                elevation: 0,
              ),
            ),
            home: const SignInLogic(),
          ),
        );
      },
    );
  }
}
