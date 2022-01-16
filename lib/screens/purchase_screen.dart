import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

// Services
import 'package:mockoin/services/crypto_service.dart';
import 'package:mockoin/services/user_service.dart';
import 'package:mockoin/services/investment_service.dart';
import 'package:mockoin/services/snackbar_service.dart';
import 'package:mockoin/string_extension.dart';


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
  SnackbarService snackbarService = SnackbarService();
  UserService userService = UserService();
  InvestmentService investmentService = InvestmentService();

  late Timer timer;
  bool absorbing = true;
  Map<dynamic, dynamic> pricesData = {};

  Map<dynamic, dynamic> userData = {
    "name": "...",
    "email": "...",
    "funds": "00.0"
  };

  void fetchUser() async {
    Map<dynamic, dynamic> _userData = await userService.fetchUser();
    setState(() {
      userData = _userData;
    });
  }

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

  void handlePurchase() async {
    await investmentService.purchase(
      crypto: widget.id,
      inr: rupeeController.text,
      quantity: cryptoController.text
    ).then((value) {
      if(value) {
        snackbarService.successToast(
          context: context,
          text: "Purchase Successful"
        );
        Navigator.pop(context);
      } else {
        snackbarService.failureToast(
          context: context,
          text: "Purchase Failed"
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PurchaseScreen(id: widget.id))
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      callApi();
      fetchUser();
      timer = Timer.periodic(const Duration(seconds: 15), (Timer t) => callApi());
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
              Icons.keyboard_arrow_left_rounded,
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
                                    double funds = double.parse(userData['funds']);
                                    var calc = 1/((double.parse(pricesData['priceUsd']) * 74)/double.parse(value));
                                    cryptoController.text = calc.toString();

                                    if(double.parse(value) < funds && double.parse(value) > 50) {
                                      setState(() {
                                        absorbing = false;
                                      });  
                                    } else {
                                      setState(() {
                                        absorbing = true;
                                      });
                                    }
                                  } else {
                                    cryptoController.text = '';
                                  }
                                },
                                controller: rupeeController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                cursorColor: kColorDark,
                                decoration: kTextFieldDecoration2.copyWith(
                                  labelText: 'In Rupees'
                                ),
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
                        ),
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          child: Row(
                            children: [
                              const Text(
                                'Funds: ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w300
                                )
                              ),
                              Text(
                                f.format(double.parse(userData["funds"])),
                                style: const TextStyle(
                                  color: kColorDark,
                                  fontWeight: FontWeight.w400
                                )
                              ),
                            ],
                          )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onHorizontalDragStart: (details){
                  if(absorbing) {
                    snackbarService.failureToast(
                      context: context,
                      text: "Value must be greater than 50 and less than ${userData['funds']}"
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: AbsorbPointer(
                    absorbing: absorbing,
                    child: SlideAction(
                      text: "Slide to Confirm Purchase",
                      onSubmit: () {
                        handlePurchase();
                      },
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: kColorBlue
                      ),
                      animationDuration: const Duration(milliseconds: 100),
                      sliderRotate: false,
                      elevation: 0,
                      innerColor: kColorBlue,
                      outerColor: kColorGreenLight,
                    ),
                  ),
                ),
              ),
            ],
          ) : const Text('Loading...')
        ),
      ),
    );
  }
}