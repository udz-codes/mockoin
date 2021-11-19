import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';

class CurrencyListHeader extends StatelessWidget {
  const CurrencyListHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      child: Row(
        children: const [
          Expanded(child: Text('COIN NAME', style: kGreySmTextStyle)),
          Text('PRICE', style: kGreySmTextStyle),
          SizedBox(width: 20),
          Text('24H CHANGE', style: kGreySmTextStyle)
        ],
      ),
    );
  }
}