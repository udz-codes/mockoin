import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';
import 'package:intl/intl.dart';

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => "${this[0].toUpperCase()}${this.substring(1)}";
}

class CurrencyTile extends StatelessWidget {
  
  const CurrencyTile({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.symbol,
    required this.price,
    required this.change,
    required this.onTap
  }) : super(key: key);

  final String imageUrl;
  final String title;
  final String symbol;
  final String price;
  final String change;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat.currency(locale: "HI", symbol: "₹");

    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              child: Image.asset(imageUrl),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.capitalizeFirstofEach,
                    style: kHeadingStyleSm.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18
                    )
                  ),
                  Text(symbol, style: kHeadingStyleSm),
                ],
              )
            ),
            Text(
              f.format(double.parse(price) * 74),
              style: kHeadingStyleSm.copyWith(
                color: kColorDark,
                fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(width: 20),
            Container(
              alignment: Alignment.center,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: double.parse(change).isNegative ? kColorRedLight : kColorGreenLight,
              ),
              padding: const EdgeInsets.all(7),
              child: Text(
                double.parse(change).isNegative ? double.parse(change).toStringAsFixed(2) + "%" : "+"+ double.parse(change).toStringAsFixed(2) + "%",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: double.parse(change).isNegative ? kColorRed : kColorGreen
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}