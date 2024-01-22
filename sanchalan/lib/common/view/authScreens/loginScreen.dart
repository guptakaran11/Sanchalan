import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:sanchalan/common/Widgets/assetGen.dart';
import 'package:sanchalan/common/Widgets/elevatedButtonCommon.dart';
import 'package:sanchalan/common/Widgets/orDivider.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/constant/utils/textstyle.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  String selectedCountryode = '+91';
  bool loginButtonPressed = false;
  List loginButtonData = [
    [const AssetGen().google.svg(height: 3.h), 'Google'],
    [const AssetGen().apple.svg(height: 3.h), 'Apple'],
    [const AssetGen().facebook.svg(height: 3.h), 'Facebook'],
    [const AssetGen().mail.svg(height: 3.h), 'Email'],
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
            vertical: 2.h,
          ),
          children: [
            SizedBox(
              height: 1.h,
            ),
            Text(
              'Enter your Phone Number',
              style: AppTextStyles.body18,
            ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    showCountryPicker(
                        context: context,
                        onSelect: (value) {
                          setState(() {
                            selectedCountryode = '+${value.phoneCode}';
                          });
                        });
                  },
                  child: Container(
                    height: 6.h,
                    width: 20.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.sp),
                      color: greyShade2,
                      border: Border.all(
                        color: grey,
                      ),
                    ),
                    child: Text(selectedCountryode),
                  ),
                ),
                SizedBox(
                  width: 70.w,
                  child: TextFormField(
                    controller: phoneNumberController,
                    cursorColor: black,
                    style: AppTextStyles.textFieldTextStyle,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 2.w,
                      ),
                      hintText: 'Phone Number',
                      hintStyle: AppTextStyles.textFieldHintTextStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.sp),
                        borderSide: BorderSide(color: grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.sp),
                        borderSide: BorderSide(color: grey),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.sp),
                        borderSide: BorderSide(color: grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.sp),
                        borderSide: BorderSide(color: grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            ElevatedButtonCommon(
              onPressed: () {},
              backgroundColor: black,
              height: 6.h,
              width: 94.w,
              child: loginButtonPressed == true
                  ? const CircularProgressIndicator()
                  : Text(
                      'Continue',
                      style: AppTextStyles.small12Bold.copyWith(
                        color: white,
                      ),
                    ),
            ),
            SizedBox(
              height: 2.h,
            ),
            const OrDivider(),
            SizedBox(
              height: 2.h,
            ),
            ListView.builder(
              itemCount: loginButtonData.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  height: 6.h,
                  width: 94.w,
                  margin: EdgeInsets.symmetric(
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.sp),
                    color: greyShade3,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loginButtonData[index][0],
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        'Continue with ${loginButtonData[index][1]}',
                      )
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: 2.h,
            ),
            const OrDivider(),
            SizedBox(
              height: 2.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  color: black,
                ),
                Text(
                  'Find My Account',
                  style: AppTextStyles.body14,
                ),
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            Text(
              'By proceeding, you consent to get calls, WhatsApp or SMS messages, including by automated means, from Sanchalan and its affiliates to the number provided .',
              style: AppTextStyles.small10.copyWith(
                color: grey,
              ),
            ),
            SizedBox(
              height: 13.h,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'This site is protected by reCAPTCHA and Google ',
                    style: AppTextStyles.small10.copyWith(color: grey),
                  ),
                  TextSpan(
                    text: 'Privacy Policy ',
                    style: AppTextStyles.small10
                        .copyWith(decoration: TextDecoration.underline),
                  ),
                  TextSpan(
                    text: 'and ',
                    style: AppTextStyles.small10.copyWith(color: grey),
                  ),
                  TextSpan(
                    text: 'Terms Of Service ',
                    style: AppTextStyles.small10
                        .copyWith(decoration: TextDecoration.underline),
                  ),
                  TextSpan(
                    text: ' apply',
                    style: AppTextStyles.small10.copyWith(color: grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
