import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';
import 'package:mockoin/components/logo_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorLight,
      appBar: AppBar(
        backgroundColor: kColorBlue,
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          LogoHeader(),
          SizedBox(
            height: 20,
          ),
          Text(
            'Login',
            style: kHeadingStyle,
          ),
        ],
      ),
    );
  }
}
