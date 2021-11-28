import 'package:flutter/material.dart';
import 'package:mockoin/components/page_header.dart';

import 'package:mockoin/components/transactions_list.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: const [
          PageHeader(
            textPrimary: "Orders",
            textSecondary: "Sale and Purchase transactions",
          ),
          TransactionsList()
        ]
      ),
    );
  }
}