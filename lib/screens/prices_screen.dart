import 'package:flutter/material.dart';
import 'package:mockoin/components/currency_list.dart';
import 'package:mockoin/components/currency_list_header.dart';
import 'package:mockoin/constants.dart';

class PricesScreen extends StatelessWidget {

  const PricesScreen({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 18),
                    child: Column(
                      children: [
                        Text('Prices', style: kHeadingStyleMd.copyWith(color: kColorGreen)),
                        const SizedBox(height: 2),
                        Text('Realtime prices of Cryptocurrencies', style: kHeadingStyleSm.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400
                        )),
                      ],
                    ),
                  ),
                  const CurrencyListHeader(),
                ],
              ),
            ),
          ),
          const CurrencyList()
        ],
      ),
    );
  }
}