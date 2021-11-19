import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';
import 'dart:async';
// Services
import 'package:mockoin/services/crypto_service.dart';

// Components
import 'package:mockoin/components/currency_tile.dart';
import 'package:mockoin/components/green_loader.dart';

class PricesScreen extends StatefulWidget {
  const PricesScreen({ Key? key }) : super(key: key);

  @override
  _PricesScreenState createState() => _PricesScreenState();
}

class _PricesScreenState extends State<PricesScreen> {
  CryptoService cryptoService = CryptoService();
  late Timer timer;
  List<dynamic> pricesData = [];

  void callApi() async {
    if(mounted) {
      List data = await cryptoService.getPrices();
      setState(() {
        if(data.isNotEmpty) pricesData = data;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      callApi();
      timer = Timer.periodic(const Duration(seconds: 15), (Timer t) => callApi());
    });
  }

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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    child: Row(
                      children: const [
                        Expanded(child: Text('COIN NAME', style: kGreySmTextStyle)),
                        Text('PRICE', style: kGreySmTextStyle),
                        SizedBox(width: 20),
                        Text('24H CHANGE', style: kGreySmTextStyle)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          pricesData.isNotEmpty ? Expanded(
            child: Container(
              width: double.infinity,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: pricesData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      CurrencyTile(
                        imageUrl: 'assets/icons/'+pricesData[index]['id']+'.png',
                        title: pricesData[index]['id'],
                        symbol: pricesData[index]['symbol'],
                        price: pricesData[index]['priceUsd'],
                        change: pricesData[index]['changePercent24Hr']
                      ),
                      const Divider(
                        height: 0,
                        color: Colors.grey,
                      )
                    ],
                  );
                }
              )
            ),
          ) : Expanded(
            child: GreenLoader(
              color: Colors.grey,
              loading: true,
              child: Container(width: double.infinity)
            )
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}