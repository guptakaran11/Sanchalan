import 'package:flutter/material.dart';
import 'package:sanchalan/common/controller/services/mobileAuthServices.dart';
import 'package:sanchalan/constant/utils/colors.dart';

class SignInLogic extends StatefulWidget {
  const SignInLogic({super.key});

  @override
  State<SignInLogic> createState() => _SignInLogicState();
}

class _SignInLogicState extends State<SignInLogic> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MobileAuthServices.checkAuthenticateAndNavigate(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: black,
      body:const Center(
        child: Image(
          image: AssetImage(
            'assets/images/SanchalanLogo/sanchalanLogo.jpg',
          ),
        ),
      ),
    );
  }
}
