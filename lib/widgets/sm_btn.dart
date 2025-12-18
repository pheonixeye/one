import 'package:flutter/material.dart';

class SmBtn extends StatelessWidget {
  const SmBtn({
    super.key,
    this.onPressed,
    this.child,
    this.tooltip,
    this.backgroundColor,
  });
  final VoidCallback? onPressed;
  final Widget? child;
  final String? tooltip;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.0,
      height: 40.0,
      child: Tooltip(
        message: tooltip ?? '',
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            alignment: Alignment.center,
            disabledMouseCursor: SystemMouseCursors.basic,
            disabledBackgroundColor: backgroundColor ?? Colors.orange.shade300,
            foregroundColor: Colors.white,
            backgroundColor: backgroundColor ?? Colors.orange.shade300,
            elevation: 6.0,
            padding: EdgeInsets.zero,
          ),
          child: child ?? SizedBox(),
        ),
      ),
    );
  }
}
