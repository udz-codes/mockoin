import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mockoin/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

import 'package:mockoin/services/investment_service.dart';

import 'package:mockoin/components/touchable_tile.dart';

class InvestmentsList extends StatefulWidget {
  const InvestmentsList({ Key? key }) : super(key: key);

  @override
  _InvestmentsListState createState() => _InvestmentsListState();
}

class _InvestmentsListState extends State<InvestmentsList> {
  InvestmentService investmentService = InvestmentService();
  List investments = [];
  
  void callApi() async {
    if(mounted) {
      List data = await investmentService.getInvestments();
      if(data.isNotEmpty) {
        setState(() {
          investments = data;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => callApi());
  }

  @override
  Widget build(BuildContext context) {
    bool isLogged = context.watch<AuthProvider>().isLogged;

    return Container(
      child: isLogged ? Expanded(
        child: SizedBox(
          width: double.infinity,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: investments.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InvestmentTile(investments: investments[index]),
                ],
              );
            }
          )
        )
      ) : Center(
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

class InvestmentTile extends StatelessWidget {
  const InvestmentTile({
    Key? key,
    required this.investments,
  }) : super(key: key);

  final Map investments;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: Card(
        elevation: 8,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 40,
                        child: Image.asset('assets/icons/' + investments['crypto_id'] + ".png")
                      ),
                      const SizedBox(width: 10),
                      Text(investments['crypto_id']),
                    ],
                  ),
                  Text(investments['total_quantity']),
                ],
              ),
            ),
            const Divider(
              height: 0,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: const [
                      Text("Returns"),
                      Text("- 0.0"),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Current"),
                      Text("₹" + investments['total_amount']),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Invested"),
                      Text("₹" + investments['total_amount']),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}