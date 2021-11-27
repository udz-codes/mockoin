import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';
import 'package:intl/intl.dart';

class FundsCard extends StatelessWidget {
  
  FundsCard({
    Key? key,
    required this.amount
  }) : super(key: key);

  final String amount;
  var f = NumberFormat.currency(locale: "HI", symbol: "₹");

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      width: double.infinity,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        color: kColorGreen,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Funds available to invest",
                style: kHeadingStyleMd.copyWith(
                  fontWeight: FontWeight.w400,
                  color: kColorGreenLight
                )
              ),
              const SizedBox(height: 6),
              Text(
                f.format(double.parse(amount)),
                style: kHeadingStyleLg.copyWith(
                  color: kColorLight,
                  fontWeight: FontWeight.w900
                )
              )
            ],
          ),
        )
      ),
    );
  }
}