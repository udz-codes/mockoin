import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';

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
    required this.change
  }) : super(key: key);

  final String imageUrl;
  final String title;
  final String symbol;
  final String price;
  final String change;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () => print(title),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 42,
              child: Image.asset(imageUrl),
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
              "\$" + double.parse(price).toStringAsFixed(2),
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
                double.parse(change).toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 16,
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