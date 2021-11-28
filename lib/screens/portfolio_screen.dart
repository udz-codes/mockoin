import 'package:flutter/material.dart';
import 'package:mockoin/components/investments_list.dart';

// Components
import 'package:mockoin/components/page_header.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: const [
          PageHeader(
            textPrimary: "My Investments",
            textSecondary: "Current state of your investments",
          ),
          InvestmentsList()
        ]
      ),
    );
  }
}