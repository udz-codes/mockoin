import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:mockoin/constants.dart';
import 'package:mockoin/string_extension.dart';


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
    return Card(
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
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    quantity.characters.take(16).toString(),
                    maxLines: 1,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    style: kHeadingStyleSm.copyWith(
                      color: kColorGreen,
                    )
                  ),
                ),
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
                        "- ???" + ((double.parse(current) - double.parse(invested)) * -1).toStringAsFixed(2),
                        style: kHeadingStyleSm.copyWith(
                          color: kColorRed
                        ),
                      )
                    : Text(
                        "+ ???" + (double.parse(current) - double.parse(invested)).toStringAsFixed(2),
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
                    Text("???" + current, style: kHeadingStyleSm),
                  ],
                ),
                Column(
                  children: [
                    const Text("Invested"),
                    const SizedBox(height: 3),
                    Text("???" + invested, style: kHeadingStyleSm),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}