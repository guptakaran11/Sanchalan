// ignore_for_file: use_build_context_synchronously, file_names,

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

//* Provider
import 'package:sanchalan/common/controller/provider/authProvider.dart';
import 'package:sanchalan/common/controller/provider/profileDataProvider.dart';
import 'package:sanchalan/common/controller/services/profileDataCRUDServices.dart';

//* Models
import 'package:sanchalan/common/model/profileModelData.dart';

//* Screens
import 'package:sanchalan/common/view/authScreens/loginScreen.dart';
import 'package:sanchalan/common/view/authScreens/otpScreen.dart';
import 'package:sanchalan/common/view/registrationScreen/registrationScreen.dart';
import 'package:sanchalan/common/view/signInLogic/signInLogic.dart';
import 'package:sanchalan/driver/view/bottomNavBarDriver/bottomNavBarDriver.dart';
import 'package:sanchalan/rider/View/bottomNavBar/bottomNavBarRider.dart';

//* Widgets
import 'package:sanchalan/constant/constants.dart';

class MobileAuthServices {
  static receiveOTP(
      {required BuildContext context, required String phoneNumber}) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          log(credential.toString());
        },
        verificationFailed: (FirebaseAuthException exception) {
          log(exception.toString());
        },
        codeSent: (String verificationCode, int? resendToken) {
          context
              .read<MobileAuthProvider>()
              .updateVerificationCode(verificationCode);
          Navigator.push(
            context,
            PageTransition(
              child: const OTPScreen(),
              type: PageTransitionType.rightToLeft,
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationID) {},
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  static verifyOTP({required BuildContext context, required String otp}) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: context.read<MobileAuthProvider>().verificationCode!,
          smsCode: otp);
      await auth.signInWithCredential(credential);
      Navigator.push(
        context,
        PageTransition(
          child: const SignInLogic(),
          type: PageTransitionType.rightToLeft,
        ),
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  static bool checkAuthentication() {
    User? user = auth.currentUser;
    if (user != null) {
      return true;
    }
    return false;
  }

  static checkAuthenticateAndNavigate({required BuildContext context}) {
    bool userIsAuthenticate = checkAuthentication();
    userIsAuthenticate
        ? checkUser(context)
        : Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              child: const LoginScreen(),
              type: PageTransitionType.rightToLeft,
            ),
            (route) => false,
          );
  }

  static checkUser(BuildContext context) async {
    bool userIsRegistered =
        await ProfileDataCRUDServices.checkForRegisteredUser(context);

    if (userIsRegistered == true) {
      ProfileDataModel profileData =
          await ProfileDataCRUDServices.getProfileDataFromRealTimeDatabase(
              auth.currentUser!.phoneNumber!);
      // PushNotificationServices.initializeFirebaseMessagingForUsers(
      //     profileData, context);
      bool userIsDriver = await ProfileDataCRUDServices.userIsDriver(context);

      if (userIsDriver == true) {
        // Navigator to Driver application
        context.read<ProfileDataProvider>().getProfileData();
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: const BottomNavBarDriver(),
                type: PageTransitionType.rightToLeft),
            (route) => false);
      } else {
        // Navigator to rider application
        context.read<ProfileDataProvider>().getProfileData();
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: const BottomNavBarRider(),
                type: PageTransitionType.rightToLeft),
            (route) => false);
      }
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            child: const RegistrationScreen(),
            type: PageTransitionType.rightToLeft,
          ),
          (route) => false);
    }
  }

  static signOut(BuildContext context) {
    auth.signOut();
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const SignInLogic();
        },
      ),
      (_) => false,
    );
  }
}
