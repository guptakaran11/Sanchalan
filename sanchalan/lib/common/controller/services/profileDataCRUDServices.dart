import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sanchalan/common/controller/services/toastService.dart';
import 'package:sanchalan/common/model/profileModelData.dart';
import 'package:sanchalan/common/view/signInLogic/signInLogic.dart';
import 'package:sanchalan/constant/constants.dart';

class ProfileDataCRUDServices {
  static getProfileDataFromRealTimeDatabase(String userID) async {
    try {
      final snapshot = await realTimeDatabaseRef.child('User/$userID').get();
      if (snapshot.exists) {
        ProfileDataModel userModel = ProfileDataModel.fromMap(
            jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>);
        return userModel;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<bool> checkForRegisteredUser(BuildContext context) async {
    try {
      final snapShot = await realTimeDatabaseRef
          .child('User/${auth.currentUser!.phoneNumber}')
          .get();
      if (snapShot.exists) {
        log('User Data found');
        return true;
      }
      log('User Data not found');
      return false;
    } catch (e) {
      throw Exception(e);
    }
  }

  static registerUserToDatabase({
    required ProfileDataModel profileData,
    required BuildContext context,
  }) {
    realTimeDatabaseRef
        .child('User/${auth.currentUser!.phoneNumber}')
        .set(profileData.toMap())
        .then((value) {
      ToastService.sendScaffoldAlert(
        msg: 'User Registered Successful',
        toastStatus: 'SUCCESS',
        context: context,
      );
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          child: const SignInLogic(),
          type: PageTransitionType.rightToLeft,
        ),
        (route) => false,
      );
    }).onError((error, stackTrace) {
      ToastService.sendScaffoldAlert(
        msg: 'Opps! Error Encountered',
        toastStatus: 'SUCCESS',
        context: context,
      );
    });
  }

  static Future<bool> userIsDriver(BuildContext context) async {
    try {
      DataSnapshot snapshot = await realTimeDatabaseRef
          .child('User/${auth.currentUser!.phoneNumber}')
          .get();

      if (snapshot.exists) {
        ProfileDataModel userModel = ProfileDataModel.fromMap(
            jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>);
        log('User Type is ${userModel.userType}');
        if (userModel.userType != 'CUSTOMER') {
          return true;
        }
      }
    } catch (e) {
      throw Exception(e);
    }
    return false;
  }
}
