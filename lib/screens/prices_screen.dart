import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';

// Services
import 'package:mockoin/services/crypto_service.dart';

class PricesScreen extends StatefulWidget {
  const PricesScreen({ Key? key }) : super(key: key);

  @override
  _PricesScreenState createState() => _PricesScreenState();
}

class _PricesScreenState extends State<PricesScreen> {
  CryptoService cryptoService = CryptoService();
  List<dynamic> pricesData = [];

  void callApi() async {
    Map<dynamic, dynamic> data = await cryptoService.getPrices();
    setState(() {
      pricesData = data['data'];
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => callApi());
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
              elevation: 3,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text('Prices', style: kHeadingStyleMd.copyWith(color: kColorGreen)),
              ),
            ),
          ),

          if(pricesData.isNotEmpty) Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: pricesData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(pricesData[index]['id'] + " : \$" + pricesData[index]['priceUsd']);
                }
              )
            ),
          ),

          TextButton(
            onPressed: () => callApi(),
            child: Text("Call")
          )
        ],
      ),
    );
  }
}