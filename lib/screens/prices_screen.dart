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
  Timer? timer;
  List<dynamic> pricesData = [];

  void callApi() async {
    List data = await cryptoService.getPrices();
    setState(() {
      pricesData = data;
    });
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 24),
                    child: Text('Prices', style: kHeadingStyleMd.copyWith(color: kColorGreen)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 14, right: 14),
                    child: Row(
                      children: const [
                        Expanded(child: Text('COIN NAME', style: TextStyle(color: Colors.grey))),
                        Text('PRICE', style: TextStyle(color: Colors.grey)),
                        SizedBox(width: 20),
                        Text('24H CHANGE', style: TextStyle(color: Colors.grey))
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
    timer?.cancel();
    super.dispose();
  }
}