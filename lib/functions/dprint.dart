import 'dart:convert';

import 'package:flutter/foundation.dart';

void dprint(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}

void prettyPrint(Object? object) {
  final _src = JsonEncoder.withIndent('  ').convert(object);
  dprint(_src);
}
