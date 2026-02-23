import 'package:flutter/material.dart';

class PxPricing extends ChangeNotifier {
  bool _isMonthly = true;
  bool get isMonthly => _isMonthly;

  void swap() {
    _isMonthly = !_isMonthly;
    notifyListeners();
  }
}
