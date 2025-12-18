import 'dart:math';

import 'package:flutter/material.dart';
import 'package:one/functions/dprint.dart';

class RandomCurver {
  final List<Curve> _list = [
    Curves.bounceIn,
    Curves.bounceInOut,
    Curves.decelerate,
    Curves.linear,
    Curves.ease,
    Curves.easeIn,
    Curves.easeInOut,
    Curves.easeOut,
    Curves.fastEaseInToSlowEaseOut,
    Curves.fastOutSlowIn,
    Curves.elasticIn,
    Curves.elasticInOut,
    Curves.elasticOut,
    Curves.elasticIn,
  ];

  Curve _getRandomCurvedAnimation() {
    final _random = Random.secure().nextInt(_list.length - 1);
    final _c = _list[_random];
    dprint(_c.toString());
    return _c;
  }

  Curve get curve => _getRandomCurvedAnimation();
}
