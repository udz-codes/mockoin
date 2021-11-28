import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mockoin/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

import 'package:mockoin/services/transaction_service.dart';

import 'package:mockoin/components/touchable_tile.dart';

class TransactionsList extends StatefulWidget {
  const TransactionsList({ Key? key }) : super(key: key);

  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  TransactionService transactionService = TransactionService();
  List transactions = [];
  
  void callApi() async {
    if(mounted) {
      List data = await transactionService.getTransactions();
      if(data.isNotEmpty) {
        setState(() {
          transactions = data;
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
            itemCount: transactions.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(transactions[index]['action_type']),
                        Text(transactions[index]['crypto_id'] + "(${transactions[index]['crypto_value']})" ),
                        Text("₹" + transactions[index]['inr']),
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