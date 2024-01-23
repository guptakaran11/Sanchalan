import 'package:flutter/material.dart';

class PhoneAuthPovider extends ChangeNotifier {
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
