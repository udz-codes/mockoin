import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';

class TextInputBar extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final TextInputAction inputAction;
  final bool obscureText;

  TextInputBar({
    required this.placeholder,
    required this.controller,
    this.obscureText = false,
    this.inputAction = TextInputAction.next
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: inputAction,
      textAlign: TextAlign.center,
      cursorColor: kColorBlue,
      decoration: kTextFieldDecoration.copyWith(
        hintText: placeholder,
      ),
      style: const TextStyle(
        color: kColorBlue,
        fontSize: 18,
        fontWeight: FontWeight.w600
      ),
    );
  }
}
