import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mockoin/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

// Services
import 'package:mockoin/services/crypto_service.dart';

// Components
import 'package:mockoin/components/currency_tile.dart';
import 'package:mockoin/components/green_loader.dart';
import 'package:mockoin/screens/purchase_screen.dart';

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
      if(data.isNotEmpty) {
        setState(() {
          pricesData = data;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      callApi();
      timer = Timer.periodic(const Duration(seconds: 60), (Timer t) => callApi());
    });
  }
  
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLogged = context.watch<AuthProvider>().isLogged;

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
                    onTap: (){
                      isLogged ? Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => PurchaseScreen(id: pricesData[index]['id']))
                      ) : Navigator.pushNamed(context, '/login');
                    },
                    imageUrl: 'assets/icons/'+pricesData[index]['id']+'.png',
                    title: pricesData[index]['id'],
                    symbol: pricesData[index]['symbol'],
                    price: (double.parse(pricesData[index]['priceUsd']) * 74).toString(),
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