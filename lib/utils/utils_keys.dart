import 'package:flutter/material.dart';

class UtilsKeys {
  UtilsKeys();

  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static final navigatorKey = GlobalKey<NavigatorState>();

  static final bottomNavHeroKey = GlobalObjectKey('bottom-nav-hero-key');

  static final navRailHeroKey = GlobalObjectKey('nav-rail-hero-key');
}
