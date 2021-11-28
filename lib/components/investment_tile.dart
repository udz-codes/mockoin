import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${substring(1)}';
  String get allInCaps => toUpperCase();
  String get capitalizeFirstofEach => "${this[0].toUpperCase()}${substring(1)}";
}

class InvestmentTile extends StatelessWidget {
  const InvestmentTile({
    Key? key,
    required this.title,
    required this.quantity,
    required this.invested,
    required this.current
  }) : super(key: key);

  final String title;
  final String quantity;
  final String invested;
  final String current;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 40,
                        child: Image.asset('assets/icons/' + title + ".png")
                      ),
                      const SizedBox(width: 10),
                      Text(title.capitalizeFirstofEach, style: kHeadingStyleSm.copyWith(
                        fontWeight: FontWeight.w500
                      )),
                    ],
                  ),
                  Text(quantity, style: kHeadingStyleSm.copyWith(
                    color: kColorGreen
                  )),
                ],
              ),
            ),
            const Divider(
              height: 0,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text("Returns"),
                      const SizedBox(height: 3),
                      (double.parse(current) - double.parse(invested)).isNegative ? 
                        Text(
                          "- ₹" + ((double.parse(current) - double.parse(invested)) * -1).toStringAsFixed(2),
                          style: kHeadingStyleSm.copyWith(
                            color: kColorRed
                          ),
                        )
                      : Text(
                          "+ ₹" + (double.parse(current) - double.parse(invested)).toStringAsFixed(2),
                          style: kHeadingStyleSm.copyWith(
                            color: kColorGreen
                          )
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Current"),
                      const SizedBox(height: 3),
                      Text("₹" + current, style: kHeadingStyleSm),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Invested"),
                      const SizedBox(height: 3),
                      Text("₹" + invested, style: kHeadingStyleSm),
                    ],
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