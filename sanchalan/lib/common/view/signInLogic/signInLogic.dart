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

class New extends StatefulWidget {
  const New({super.key});

  @override
  State<New> createState() => _NewState();
}

class _NewState extends State<New> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
