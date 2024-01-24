import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sanchalan/constant/commonWidgets/elevatedButtonCommon.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/constant/utils/textstyle.dart';
import 'package:sizer/sizer.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController vehicleModelNameController = TextEditingController();
  TextEditingController vehicleBrandNameController = TextEditingController();
  TextEditingController vechileRegistrationNumberController =
      TextEditingController();
  TextEditingController driverLicenseNumberController = TextEditingController();

  String selectedVehicleType = 'Select Vehicle Type';
  List<String> vehicleTypes = [
    'Select Vehicle Type',
    'Mini',
    'Sedan',
    'SUV',
    'Bike',
  ];

  String userType = 'Customer';
  File? profilePic;
  bool registerButtonPressed = false;

  @override
  void initState() {
    super.initState();
    phoneController.text = '+911234567890';
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    vehicleBrandNameController.dispose();
    vehicleModelNameController.dispose();
    vechileRegistrationNumberController.dispose();
    driverLicenseNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
            vertical: 2.h,
          ),
          children: [
            SizedBox(
              height: 2.h,
            ),
            InkWell(
              onTap: () {},
              child: CircleAvatar(
                radius: 8.h,
                backgroundColor: greyShade3,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Builder(builder: (context) {
                    if (profilePic != null) {
                      return CircleAvatar(
                        radius: (8.h - 2),
                        backgroundColor: white,
                        backgroundImage: FileImage(profilePic!),
                      );
                    } else {
                      return CircleAvatar(
                        radius: (8.h - 2),
                        backgroundColor: white,
                        child: const Image(
                          image: AssetImage(
                            'assets/images/SanchalanLogo/sanchalanLogoNew.jpg',
                          ),
                        ),
                      );
                    }
                  }),
                ),
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            RegistrationScreenTextField(
              controller: nameController,
              hint: '',
              title: 'Name',
              keyBoardType: TextInputType.name,
              readOnly: false,
            ),
            SizedBox(
              height: 2.h,
            ),
            RegistrationScreenTextField(
              controller: phoneController,
              hint: '',
              title: 'Phone Number',
              keyBoardType: TextInputType.number,
              readOnly: true,
            ),
            SizedBox(
              height: 2.h,
            ),
            RegistrationScreenTextField(
              controller: emailController,
              hint: '',
              title: 'Email',
              keyBoardType: TextInputType.emailAddress,
              readOnly: false,
            ),
            SizedBox(
              height: 4.h,
            ),
            selectUserType('Customer'),
            SizedBox(
              height: 2.h,
            ),
            selectUserType('Driver'),
            SizedBox(height: 4.h),
            Builder(builder: (context) {
              if (userType == 'Driver') {
                return driver();
              } else {
                return customer();
              }
            })
          ],
        ),
      ),
    );
  }

  selectUserType(String updateUserType) {
    return InkWell(
      onTap: () {
        if (registerButtonPressed == false) {
          setState(() {
            userType = updateUserType;
          });
        }
      },
      child: Row(
        children: [
          Container(
            height: 2.5.h,
            width: 2.5.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.sp),
                border: Border.all(
                  color: userType == updateUserType ? black : grey,
                )),
            child: Icon(
              Icons.check,
              color: userType == updateUserType ? black : transparent,
              size: 2.h,
            ),
          ),
          SizedBox(
            width: 3.w,
          ),
          Text(
            'Continue as a $updateUserType',
            style: AppTextStyles.small10.copyWith(
              color: userType == updateUserType ? black : grey,
            ),
          )
        ],
      ),
    );
  }

  customer() {
    return Column(
      children: [
        SizedBox(
          height: 10.h,
        ),
        ElevatedButtonCommon(
          onPressed: () {},
          backgroundColor: black,
          height: 6.h,
          width: 94.w,
          child: registerButtonPressed == true
              ? CircularProgressIndicator(
                  color: white,
                )
              : Text(
                  'Continue',
                  style: AppTextStyles.small12Bold.copyWith(color: white),
                ),
        ),
      ],
    );
  }

  driver() {
    return Column(
      children: [
        RegistrationScreenTextField(
          controller: vehicleBrandNameController,
          hint: '',
          title: 'Vehicle Brand Name',
          keyBoardType: TextInputType.name,
          readOnly: false,
        ),
        SizedBox(
          height: 2.h,
        ),
        RegistrationScreenTextField(
          controller: vehicleModelNameController,
          hint: '',
          title: 'Vehicle Model ',
          keyBoardType: TextInputType.name,
          readOnly: false,
        ),
        SizedBox(
          height: 2.h,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vechile Type',
              style: AppTextStyles.body14Bold,
            ),
            SizedBox(
              height: 1.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.sp),
                border: Border.all(color: grey),
              ),
              child: DropdownButton(
                  isExpanded: true,
                  value: selectedVehicleType,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  underline: const SizedBox(),
                  items: vehicleTypes
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: AppTextStyles.small12,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedVehicleType = value!;
                    });
                  }),
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        RegistrationScreenTextField(
          controller: vechileRegistrationNumberController,
          hint: '',
          title: 'Vehicle Registration No. ',
          keyBoardType: TextInputType.name,
          readOnly: false,
        ),
        SizedBox(
          height: 2.h,
        ),
        RegistrationScreenTextField(
          controller: driverLicenseNumberController,
          hint: '',
          title: 'Driving License No.  ',
          keyBoardType: TextInputType.name,
          readOnly: false,
        ),
        SizedBox(
          height: 2.h,
        ),
        ElevatedButtonCommon(
            onPressed: () {},
            backgroundColor: black,
            height: 6.h,
            width: 94.w,
            child: registerButtonPressed == true
                ? CircularProgressIndicator(
                    color: white,
                  )
                : Text(
                    'Continue',
                    style: AppTextStyles.small12Bold.copyWith(color: white),
                  ))
      ],
    );
  }
}

class RegistrationScreenTextField extends StatefulWidget {
  const RegistrationScreenTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.title,
    required this.keyBoardType,
    required this.readOnly,
  });

  final TextEditingController controller;
  final String title;
  final String hint;
  final bool readOnly;
  final TextInputType keyBoardType;

  @override
  State<RegistrationScreenTextField> createState() =>
      _RegistrationScreenTextFieldState();
}

class _RegistrationScreenTextFieldState
    extends State<RegistrationScreenTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AppTextStyles.body14Bold,
        ),
        SizedBox(
          height: 1.h,
        ),
        TextFormField(
          controller: widget.controller,
          cursorColor: black,
          style: AppTextStyles.textFieldTextStyle,
          keyboardType: widget.keyBoardType,
          readOnly: widget.readOnly,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 2.w,
            ),
            hintText: widget.hint,
            hintStyle: AppTextStyles.textFieldHintTextStyle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: black),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: grey),
            ),
          ),
        ),
      ],
    );
  }
}
