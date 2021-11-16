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
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 0.5,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0)
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 36,
              color: Colors.grey
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(textPrimary, style: kHeadingStyleMd),
                  if (textSecondary.isNotEmpty) Text(textSecondary, style: kHeadingStyleSm.copyWith(
                    color: Colors.grey
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
    );
  }
}