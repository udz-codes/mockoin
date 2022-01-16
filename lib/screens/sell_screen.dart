import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

// Services
import 'package:mockoin/services/crypto_service.dart';
import 'package:mockoin/services/user_service.dart';
import 'package:mockoin/services/investment_service.dart';
import 'package:mockoin/services/snackbar_service.dart';
import 'package:mockoin/string_extension.dart';


class SellScreen extends StatefulWidget {

  const SellScreen({
    Key? key,
    required this.id
  }) : super(key: key);
  
  final String id;

  @override
  State<SellScreen> createState() => _SellScreenState();
}


class _SellScreenState extends State<SellScreen> {
  CryptoService cryptoService = CryptoService();
  SnackbarService snackbarService = SnackbarService();
  UserService userService = UserService();
  InvestmentService investmentService = InvestmentService();

  late Timer timer;
  bool absorbing = false;
  Map<dynamic, dynamic> pricesData = {};
  Map<dynamic, dynamic> investmentData = {};


  void getCryptoPrice() async {
    if(mounted) {
      Map<dynamic, dynamic> _data = await cryptoService.getAssetPrices(widget.id);
      if(_data.isNotEmpty) {
        setState(() {
          pricesData = _data;
        });
      }
      checkValues();
    }
  }

  void getInvestmentPrice() async {
    if(mounted) {
      Map<dynamic, dynamic> _data = await investmentService.getSingleInvestment(id: widget.id);
      if(_data.isNotEmpty) {
        setState(() {
          investmentData = _data;
        });
      }
    }
  }

  void handleSale() async {
    await investmentService.sell(
      crypto: widget.id,
      amount: rupeeController.text,
      quantity: cryptoController.text
    ).then((value) {
      if(value) {
        snackbarService.successToast(
          context: context,
          text: "Sale Successful"
        );
        Navigator.pop(context);
      } else {
        snackbarService.failureToast(
          context: context,
          text: "Sale Failed"
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SellScreen(id: widget.id))
        );
      }
    });
  }

  void checkValues() {
    String value = rupeeController.text;
    
    if(value.isNotEmpty) {
      // double current = double.parse(((double.parse(pricesData['priceUsd']) * 74) * double.parse(investmentData['total_quantity'])).toStringAsFixed(3));
      var calc = 1/((double.parse(pricesData['priceUsd']) * 74)/double.parse(value));
      cryptoController.text = calc.toString();

      // if(
      //   double.parse(value) <= current
      //   && double.parse(value) > 50
      //   && double.parse(cryptoController.text) <= double.parse(investmentData['total_quantity'])
      // )  {
      //   setState(() {
      //     absorbing = false;
      //   });  
      // } else {
      //   setState(() {
      //     absorbing = true;
      //   });
      // }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getCryptoPrice();
      getInvestmentPrice();
      timer = Timer.periodic(const Duration(seconds: 15), (Timer t) => getCryptoPrice());
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
                        Text('Invested', style: kHeadingStyleSm.copyWith(
                          color: Colors.grey
                        )),
                        const SizedBox(height: 5),
                        Text(
                          investmentData.isNotEmpty ? f.format(double.parse(investmentData['total_amount'])) : '',
                          style: kHeadingStyleMd,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Text('Current', style: kHeadingStyleSm.copyWith(
                          color: Colors.grey
                        )),
                        const SizedBox(height: 5),
                        Text(
                          (pricesData.isNotEmpty && investmentData.isNotEmpty) ? "₹" + ((double.parse(pricesData['priceUsd']) * 74) * double.parse(investmentData['total_quantity'])).toStringAsFixed(3) : '',
                          style: kHeadingStyleMd,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        Text('How much do you want to sell?', style: kHeadingStyleSm.copyWith(
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
                                    checkValues();
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
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                enabled: false,
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  cryptoController.text = investmentData['total_quantity'];
                                  rupeeController.text = (
                                    (double.parse(pricesData['priceUsd']) * 74) * double.parse(investmentData['total_quantity'])
                                  ).toStringAsFixed(3);
                                  
                                  FocusScopeNode currentFocus = FocusScope.of(context);

                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                },
                                child: Text(
                                  (investmentData.isNotEmpty && pricesData.isNotEmpty) ? investmentData['total_quantity'] + " " + pricesData['symbol'] : '',
                                  style: const TextStyle(
                                    color: kColorBlue,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.grey
                                  )
                                ),
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
                      text: "Value must be at least 50 and less than Current value"
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: AbsorbPointer(
                    absorbing: absorbing,
                    child: SlideAction(
                      text: "Slide to Confirm Sale",
                      onSubmit: () {
                        handleSale();
                        // print('sold');
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