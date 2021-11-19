import 'package:flutter/material.dart';
import 'package:mockoin/constants.dart';
import 'package:loading_overlay/loading_overlay.dart';

class GreenLoader extends StatelessWidget {

  final bool loading;
  final Widget child;
  final Color color;

  const GreenLoader({
    Key? key,
    required this.child,
    required this.loading,
    this.color = kColorBlue
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      opacity: 0.7,
      color: color,
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