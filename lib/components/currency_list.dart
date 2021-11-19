import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

// Services
import 'package:mockoin/services/crypto_service.dart';

// Components
import 'package:mockoin/components/currency_tile.dart';
import 'package:mockoin/components/green_loader.dart';

class CurrencyList extends StatefulWidget {
  const CurrencyList({ Key? key }) : super(key: key);

  @override
  _CurrencyListState createState() => _CurrencyListState();
}

class _CurrencyListState extends State<CurrencyList> {
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
      timer = Timer.periodic(const Duration(seconds: 30), (Timer t) => callApi());
    });
  }
  
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: pricesData.isNotEmpty ? Expanded(
        child: SizedBox(
          width: double.infinity,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: pricesData.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  CurrencyTile(
                    onTap: () => log(pricesData[index]['id']),
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
      ),
    );
  }
}