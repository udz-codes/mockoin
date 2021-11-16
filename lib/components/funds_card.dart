import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';

class FundsCard extends StatelessWidget {
  const FundsCard({
    Key? key,
    required this.amount
  }) : super(key: key);

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Funds available to invest",
                style: kHeadingStyleSm.copyWith(
                  fontWeight: FontWeight.w400
                )
              ),
              const SizedBox(height: 6),
              Text(
                "₹" + amount,
                style: kHeadingStyle.copyWith(color: kColorGreen)
              )
            ],
          ),
        )
      ),
    );
  }
}