import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:sanchalan/common/controller/services/profileDataCRUDServices.dart';
import 'package:sanchalan/common/model/profileModelData.dart';
import 'package:sanchalan/constant/constants.dart';

class ProfileDataProvider extends ChangeNotifier {
  ProfileDataModel? profileData;

  getProfileData() async {
    profileData =
        await ProfileDataCRUDServices.getProfileDataFromRealTimeDatabase(
            auth.currentUser!.phoneNumber!);
    log(profileData!.toMap().toString());
    notifyListeners();
  }
}
