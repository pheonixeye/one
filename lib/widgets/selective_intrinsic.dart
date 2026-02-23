import 'package:flutter/material.dart';
import 'package:one/extensions/is_mobile_context.dart';

class SelectiveIntrinsic extends StatelessWidget {
  const SelectiveIntrinsic({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return IntrinsicHeight(
        child: child,
      );
    }
    return child;
  }
}
