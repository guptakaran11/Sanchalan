import 'package:flutter/material.dart';
import 'package:sanchalan/constant/utils/colors.dart';
import 'package:sanchalan/constant/utils/textstyle.dart';
import 'package:sizer/sizer.dart';

class PickupAndDropLocationScreen extends StatefulWidget {
  const PickupAndDropLocationScreen({super.key});

  @override
  State<PickupAndDropLocationScreen> createState() =>
      _PickupAndDropLocationScreenState();
}

class _PickupAndDropLocationScreenState
    extends State<PickupAndDropLocationScreen> {
  TextEditingController pickupLocationController = TextEditingController();
  TextEditingController dropLocationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(
            100.w,
            22.h,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 3.w,
              vertical: 1.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 4.h,
                    color: black,
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        child: Column(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 2.h,
                              color: black,
                            ),
                            Expanded(
                              child: Container(
                                width: 1.w,
                                color: black,
                                padding: EdgeInsets.symmetric(
                                  vertical: 0.5.h,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.square,
                              size: 2.h,
                              color: black,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextFormField(
                              controller: pickupLocationController,
                              cursorColor: black,
                              style: AppTextStyles.textFieldTextStyle,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 2.w,
                                ),
                                hintText: 'Pickup Address',
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
                            TextFormField(
                              controller: dropLocationController,
                              cursorColor: black,
                              style: AppTextStyles.textFieldTextStyle,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 2.w,
                                ),
                                hintText: 'Drop Address',
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [],
        ),
      ),
    );
  }
}
