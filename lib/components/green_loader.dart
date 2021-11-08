import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';
import 'package:loading_overlay/loading_overlay.dart';

class GreenLoader extends StatelessWidget {

  final bool loading;
  final Widget child;

  GreenLoader({required this.child, required this.loading});

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      opacity: 0.7,
      color: kColorBlue,
        progressIndicator: const SizedBox(
          height: 70,
          width: 70,
          child: CircularProgressIndicator(
            color: kColorLight,
            strokeWidth: 2.0,
          ),
        ),
        isLoading: loading,
        child: child,
    );
  }
}