import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mockoin/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

// Services
import 'package:mockoin/services/investment_service.dart';
import 'dart:async';
import 'package:mockoin/services/crypto_service.dart';

// Components
import 'package:mockoin/components/touchable_tile.dart';
import 'package:mockoin/components/investment_tile.dart';
import 'package:mockoin/components/green_loader.dart';



class InvestmentsList extends StatefulWidget {
  const InvestmentsList({ Key? key }) : super(key: key);

  @override
  _InvestmentsListState createState() => _InvestmentsListState();
}

class _InvestmentsListState extends State<InvestmentsList> {
  InvestmentService investmentService = InvestmentService();
  CryptoService cryptoService = CryptoService();
  bool loading = true;
  late Timer timer;
  List investments = [];
  List<dynamic> pricesData = [];
  
  void callApi() async {
    if(mounted) {
      List data = await investmentService.getInvestments();
      setState(() {
        if(data.isNotEmpty) {
          investments = data;
        }
        updateCurrentPrices().then((value) => loading = false);
      });
    }
  }

  Future<void> updateCurrentPrices() async {
    // TODO: A lot of loops, can be improved

    List cryptoIds = [];

    for (final i in investments) {
      cryptoIds.add(i['crypto_id']);
    }
    
    String cids = cryptoIds.join(',');

    if(mounted) {
      List data = await cryptoService.getMultiple(cids);
      List tempData = [];
      if(data.isNotEmpty) {

        for (final c in cryptoIds) {
          for(final d in data) {
            if(c == d['id']) {
              tempData.add(d);
            }
          }
        }

        setState(() {
          pricesData = tempData;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      callApi();
      timer = Timer.periodic(const Duration(seconds: 60), (Timer t) => updateCurrentPrices());
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
      child: isLogged ? 
      Expanded(
        child: (investments.isNotEmpty && pricesData.isNotEmpty) ? SizedBox(
          width: double.infinity,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: investments.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InvestmentTile(
                    title: investments[index]['crypto_id'],
                    quantity: investments[index]['total_quantity'],
                    invested: investments[index]['total_amount'],
                    current: (
                      (double.parse(pricesData[index]['priceUsd']) * 74) * double.parse(investments[index]['total_quantity'])
                    ).toStringAsFixed(2),
                  ),
                ],
              );
            }
          )
        ) : loading ? GreenLoader(
          color: Colors.grey,
          loading: true,
          child: Container(width: double.infinity)
        ) : const Center(child: Text('No Investments made'),)
      )
      : Center(
        child: TouchableTile(
          onClick: () => Navigator.pushNamed(context, '/login'),
          textPrimary: "Sign up or Login",
          textSecondary: "Create an account or login",
          icon: LineIcons.user,
        )
      )
    );
  }
}