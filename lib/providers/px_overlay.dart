import 'package:one/utils/utils_keys.dart';
import 'package:flutter/material.dart';

class PxOverlay {
  PxOverlay._();

  static final PxOverlay _instance = PxOverlay._();

  factory PxOverlay() {
    return _instance;
  }

  static final Map<String, OverlayEntry> _overlays = {};
  static Map<String, OverlayEntry> get overlays => _overlays;

  static void toggleOverlay({required String id, required Widget child}) {
    _overlays[id] != null
        ? removeOverlay(id)
        : _insertOverlay(id: id, child: child);
  }

  static void removeOverlay(String id) {
    _overlays[id]?.remove();
    _overlays.remove(id);
  }

  static void _insertOverlay({required String id, required Widget child}) {
    _overlays[id] = OverlayEntry(
      builder: (context) {
        return child;
      },
    );
    if (UtilsKeys.navigatorKey.currentContext != null) {
      Overlay.of(UtilsKeys.navigatorKey.currentContext!).insert(_overlays[id]!);
    }
  }
}
