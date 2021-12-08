import 'package:flutter/material.dart';
import 'package:mockoin/string_extension.dart';
import 'package:mockoin/constants.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mockoin/providers/authentication_provider.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:mockoin/services/transaction_service.dart';

import 'package:mockoin/components/touchable_tile.dart';
import 'package:mockoin/components/green_loader.dart';

class TransactionsList extends StatefulWidget {
  
  const TransactionsList({
    Key? key,
    this.id = ''
  }) : super(key: key);

  final String id;

  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  TransactionService transactionService = TransactionService();
  List transactions = [];
  bool loading = true;
  
  void callApi() async {
    if(mounted) {
      List data = widget.id.isEmpty ? await transactionService.getTransactions() : await transactionService.getTransactions(cryptoId: widget.id);
      setState(() {
        if(data.isNotEmpty) {
          transactions = data;
        }
        loading = false;
      });
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
        child: transactions.isNotEmpty ? SizedBox(
          width: double.infinity,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: transactions.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: transactions[index]['action_type'] == "BUY" ? kColorGreenLight : kColorRedLight,
                          child: transactions[index]['action_type'] == "BUY" ? const Icon(
                            Icons.arrow_downward_rounded,
                            color: kColorGreen,
                          ) : const Icon(
                            Icons.arrow_upward_rounded,
                            color: kColorRed,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transactions[index]['action_type'],
                              style: kHeadingStyleSm.copyWith(
                                color: (transactions[index]['action_type'] == "BUY") ? kColorGreen : kColorRed
                              ),
                            ),
                            Text(transactions[index]['crypto_id'].toString().capitalizeFirstofEach, style: kHeadingStyleSm)
                          ],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("₹" + transactions[index]['inr'], style: kHeadingStyleSm.copyWith(
                                color: kColorDark
                              )),
                              Text("${transactions[index]['crypto_value']}", style: kHeadingStyleSm),
                            ]
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    height: 0,
                    color: Colors.grey,
                  )
                ],
              );
            }
          )
        ) : loading ? GreenLoader(
          color: Colors.grey,
          loading: true,
          child: Container(width: double.infinity)
        ) : const Center(child: Text('No orders made till now'))
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