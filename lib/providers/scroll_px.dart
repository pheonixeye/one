import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class PxScroll extends ChangeNotifier {
  final ItemScrollController _controller = ItemScrollController();
  ItemScrollController get controller => _controller;

  void scrollToIndex(int index) {
    _controller.scrollTo(
        index: index,
        duration: const Duration(seconds: 1),
        curve: Curves.easeIn);
  }
}
