import 'package:flutter/material.dart';

extension IsMobile on BuildContext {
  bool get isMobile {
    final double width = MediaQuery.sizeOf(this).width;
    if (width < 600) {
      return true;
    }
    return false;
  }

  double get visitItemDialogWidth => isMobile
      ? MediaQuery.sizeOf(this).width / 1.2
      : MediaQuery.sizeOf(this).width / 3;

  double get visitItemDialogHeight => isMobile
      ? MediaQuery.sizeOf(this).height / 2
      : MediaQuery.sizeOf(this).height / 3;
}
