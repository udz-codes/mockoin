import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';

class SnackbarService {
  late BuildContext _context;
  late String _snackText;
  final SnackBarBehavior _behavior = SnackBarBehavior.floating;

  void showToast({
    required Color backgroundColor,
    required Color textColor,
  }) {
    final scaffold = ScaffoldMessenger.of(_context);
    scaffold.showSnackBar(
      SnackBar(
        margin: const EdgeInsets.all(20),
        behavior: _behavior,
        backgroundColor: backgroundColor,
        duration: const Duration(milliseconds: 2500),
        content: Text(
          _snackText,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
    );
  }

  void successToast({
    required BuildContext context,
    required String text
  }) {
    _context = context;
    _snackText = text;

    showToast(backgroundColor: kColorGreenLight, textColor: kColorBlue);
  }

  void failureToast({
    required BuildContext context,
    required String text
  }) {
    _context = context;
    _snackText = text;

    showToast(backgroundColor: kColorRedLight, textColor: kColorRed);
  }
}