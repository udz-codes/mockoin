import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';

class TouchableTile extends StatelessWidget {
  TouchableTile({
    required this.textPrimary,
    this.textSecondary = '',
    required this.icon,
    required this.onClick
  });

  final String textPrimary;
  final String textSecondary;
  final IconData icon;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(),
      child: Card(
        margin: const EdgeInsets.all(12),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 34,
                color: Colors.grey
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(textPrimary, style: kHeadingStyleMd.copyWith(fontSize: 22)),
                    if (textSecondary.isNotEmpty) Text(textSecondary, style: kHeadingStyleSm.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400
                    ),)
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.keyboard_arrow_right_rounded,
                size: 40,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}