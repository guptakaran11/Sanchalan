import 'package:flutter/material.dart';

class MobileAuthProvider extends ChangeNotifier {
  String? phoneNumber;
  String? verificationCode;

  updatePhoneNumber(String number) {
    phoneNumber = number;
    notifyListeners();
  }

  updateVerificationCode(String code) {
    verificationCode = code;
    notifyListeners();
  }
}
