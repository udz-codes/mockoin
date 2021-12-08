import 'package:flutter/material.dart';
import 'package:mockoin/components/transactions_list.dart';
import 'package:mockoin/screens/purchase_screen.dart';
import 'package:mockoin/screens/sell_screen.dart';
import 'package:mockoin/string_extension.dart';
import 'package:mockoin/constants.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

// Services
import 'package:mockoin/services/crypto_service.dart';
import 'package:mockoin/services/user_service.dart';
import 'package:mockoin/services/investment_service.dart';
import 'package:mockoin/services/snackbar_service.dart';
import 'package:mockoin/components/investment_tile.dart';

// Components


class InvestmentActionScreen extends StatefulWidget {

  const InvestmentActionScreen({
    Key? key,
    required this.id
  }) : super(key: key);
  
  final String id;

  @override
  State<InvestmentActionScreen> createState() => _InvestmentActionScreenState();
}


class _InvestmentActionScreenState extends State<InvestmentActionScreen> {
  CryptoService cryptoService = CryptoService();
  InvestmentService investmentService = InvestmentService();

  late Timer timer;
  Map<dynamic,dynamic> investment = {};
  Map<dynamic, dynamic> priceData = {};

  void getInvestment() async {
    if(mounted) {
      Map data = await investmentService.getSingleInvestment(id: widget.id);
      setState(() {
        if(data.isNotEmpty) {
          investment = data;
        }
        getCrypto();
      });
    }
  }

  void getCrypto() async {
    if(mounted) {
      Map data = await cryptoService.getAssetPrices(widget.id);
      setState(() {
        if(data.isNotEmpty) {
          priceData = data;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getInvestment();
      timer = Timer.periodic(const Duration(seconds: 15), (Timer t) => getCrypto());
    });
  }
  
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kColorLight,

        appBar: AppBar(
          toolbarHeight: 100,
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_left_rounded,
              color: Colors.grey,
              size: 30,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          backgroundColor: kColorLight,
          title: Text(
            widget.id.capitalizeFirstofEach + "\nTransactions",
            textAlign: TextAlign.center,
            style: kHeadingStyleMd.copyWith(fontWeight: FontWeight.w300)
          ),
          centerTitle: true,
        ),

        body: Column(
          children: [
            Expanded(
              child: investment.isNotEmpty && priceData.isNotEmpty ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InvestmentTile(
                      invested: investment["total_amount"],
                      quantity: investment["total_quantity"],
                      title: widget.id,
                      current: (
                        (double.parse(priceData['priceUsd']) * 74) * double.parse(investment['total_quantity'])
                      ).toStringAsFixed(2),
                    ),
                  ),
                  TransactionsList(id: widget.id),
                ],
              ) : const Text('loading')
            ),
            Container(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => PurchaseScreen(id: widget.id))
                        ).then((value) => getInvestment());
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(14),
                        primary: kColorGreen
                      ),
                      child: const Text(
                        'BUY MORE',
                        style: TextStyle(
                          color: kColorGreenLight,
                          fontSize: 16
                        ),
                      )
                    )
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => SellScreen(id: widget.id))
                        ).then((value) => getInvestment());
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(14),
                        primary: kColorRed
                      ),
                      child: const Text(
                        'SELL',
                        style: TextStyle(
                          color: kColorRedLight,
                          fontSize: 16
                        ),
                      )
                    )
                  )
                ]
              ),
            )
          ],
        )
      ),
    );
  }
}