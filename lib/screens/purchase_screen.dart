import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:async';
import 'package:intl/intl.dart';

// Services
import 'package:mockoin/services/crypto_service.dart';

// Components
import 'package:mockoin/components/text_input_bar.dart';

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${substring(1)}';
  String get allInCaps => toUpperCase();
  String get capitalizeFirstofEach => "${this[0].toUpperCase()}${substring(1)}";
}


class PurchaseScreen extends StatefulWidget {

  const PurchaseScreen({
    Key? key,
    required this.id
  }) : super(key: key);
  
  final String id;

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}


class _PurchaseScreenState extends State<PurchaseScreen> {
  CryptoService cryptoService = CryptoService();
  late Timer timer;
  Map<dynamic, dynamic> pricesData = {};

  void callApi() async {
    if(mounted) {
      Map<dynamic, dynamic> data = await cryptoService.getAssetPrices(widget.id);
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
      timer = Timer.periodic(const Duration(seconds: 30), (Timer t) => callApi());
    });
  }
  
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  var f = NumberFormat.currency(locale: "HI", symbol: "₹");
  TextEditingController rupeeController = TextEditingController();
  TextEditingController cryptoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 100,
          leading: IconButton(
            icon: const Icon(
              LineIcons.alternateLongArrowLeft,
              color: Colors.grey,
              size: 30,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          backgroundColor: kColorLight,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                child: Image.asset('assets/icons/' + widget.id + '.png'),
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(height: 6),
              Text(widget.id.capitalizeFirstofEach, style: kHeadingStyleMd.copyWith(fontWeight: FontWeight.w300)),
            ],
          ),
          centerTitle: true,
        ),

        body: Center(
          child: pricesData.isNotEmpty ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Column(
                      children: [
                        Text('Current Price', style: kHeadingStyleSm.copyWith(
                          color: kColorDark
                        )),
                        const SizedBox(height: 5),
                        Text(
                          f.format(double.parse(pricesData['priceUsd']) * 74),
                          style: kHeadingStyleMd,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        Text('How much do you want to buy?', style: kHeadingStyleSm.copyWith(
                          color: kColorDark
                        )),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                onChanged: (value) {
                                  if(value.isNotEmpty) {
                                    var calc = 1/((double.parse(pricesData['priceUsd']) * 74)/double.parse(value));
                                    cryptoController.text = calc.toStringAsFixed(10);
                                  } else {
                                    cryptoController.text = '';
                                  }
                                },
                                controller: rupeeController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                cursorColor: kColorDark,
                                decoration: kTextFieldDecoration2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('=', style: kHeadingStyleMd.copyWith(
                                color: kColorGreen
                              )),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: cryptoController,
                                enabled: false,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                cursorColor: kColorDark,
                                decoration: kTextFieldDecoration2.copyWith(
                                  labelText: 'In ${pricesData['symbol']}'
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: const Text('Close BottomSheet'),
                  onPressed: () => Navigator.pop(context),
                ),
              )
            ],
          ) : const Text('Loading...')
        ),
      ),
    );
  }
}