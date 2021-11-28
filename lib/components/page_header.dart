import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    Key? key,
    required this.textPrimary,
    this.textSecondary = ''
  }) : super(key: key);

  final String textPrimary;
  final String textSecondary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(textPrimary, style: kHeadingStyleMd.copyWith(color: kColorGreen)),
              const SizedBox(height: 2),
              if (textSecondary.isNotEmpty) Text(textSecondary, style: kHeadingStyleSm.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w400
              )),
            ],
          ),
        ),
      ),
    );
  }
}