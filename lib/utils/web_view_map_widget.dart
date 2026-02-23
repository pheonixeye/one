// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui;
import 'package:web/web.dart' as web;

void initWebView() {
  //TODO: change location
  ui.platformViewRegistry.registerViewFactory(
    'map-view',
    (int viewId) => web.HTMLIFrameElement()
      ..width = '460'
      ..height = '360'
      ..src =
          'https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d6912.6642307828115!2d31.316038!3d29.969884!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x1458397cfe331491%3A0xf55e2d037185129b!2sCS%20Clinics!5e0!3m2!1sen!2seg!4v1719827725852!5m2!1sen!2seg'
      ..style.border = 'none',
  );
}
