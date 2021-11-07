import 'package:flutter/material.dart';

// THIS FILE CONTAINES STYLES AND COLORS FOR THE APPLICATION

// Colors
const Color kColorGreen = Color(0xff23cf6d);
const Color kColorGreenLight = Color(0xffd5eddf);
const Color kColorBlue = Color(0xff116479);
const Color kColorDark = Color(0xff2E2E2E);
const Color kColorLight = Color(0xfff1f1ef);

// Text Styles
const TextStyle kHeadingStyle = TextStyle(
  color: kColorBlue,
  fontSize: 34,
  fontWeight: FontWeight.w600,
);

const TextStyle kSmallTextStyle = TextStyle(
  color: kColorLight,
  fontSize: 14,
  fontWeight: FontWeight.w400,
);


// Input fields design
const kTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kColorGreenLight, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kColorGreen, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  hintStyle: TextStyle(
    color: kColorGreen,
    fontWeight: FontWeight.w400
  ),
  filled: true,
  fillColor: kColorGreenLight,
);