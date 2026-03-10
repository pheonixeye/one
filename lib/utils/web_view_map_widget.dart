// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui;
import 'package:web/web.dart' as web;

void initWebView() {
  //todo: change location
  ui.platformViewRegistry.registerViewFactory(
    'map-view',
    (int viewId) => web.HTMLIFrameElement()
      ..width = '460'
      ..height = '360'
      ..src =
          'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d216.02111270119707!2d31.31616574690472!3d29.969720490630973!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x1458390e9ead28ab%3A0xf89cf2a24228b60a!2sProKliniK%20Software%20Solutions!5e0!3m2!1sen!2seg!4v1773174820559!5m2!1sen!2seg'
      ..style.border = 'none',
  );
}
