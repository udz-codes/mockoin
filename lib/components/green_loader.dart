import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GreenLoader extends StatelessWidget {

  final bool loading;
  final Widget child;
  final Color color;
  final Color spinnerColor;

  const GreenLoader({
    Key? key,
    required this.child,
    required this.loading,
    this.color = kColorBlue,
    this.spinnerColor = kColorDark
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      opacity: 0.7,
      color: color,
        progressIndicator: SpinKitPulse(
          size: 70,
          // lineWidth: 3,
          color: spinnerColor,
        ),
        isLoading: loading,
        child: child,
    );
  }
}