import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';

class LogoHeader extends StatelessWidget {
  const LogoHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: kColorBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: const [
          SizedBox(
            width: 150,
            child: Image(
              image: AssetImage('assets/mockoinWhite.png'),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Risk-free Investment Simulator",
            style: kSmallTextStyle,
          )
        ],
      ),
    );
  }
}
