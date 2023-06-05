/*
 * Copyright - bsutton and MarkOSullivan94
 *
 * Taken from: https://stackoverflow.com/a/57519003
 */
import 'package:flutter/material.dart';

class GrayedOut extends StatelessWidget {
  final Widget child;
  final bool grayedOut;

  const GrayedOut(this.child, {super.key, this.grayedOut = true});

  @override
  Widget build(BuildContext context) {
    return grayedOut ? Opacity(opacity: 0.3, child: child) : child;
  }
}