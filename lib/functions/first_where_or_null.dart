import 'package:one/functions/dprint.dart';

extension FirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } on StateError catch (e) {
      dprint('firstWhereOrNull($runtimeType-->${e.message})');
      return null;
    }
  }

  Iterable<T> whereOrEmpty(bool Function(T) test) {
    try {
      return where(test);
    } on StateError catch (e) {
      dprint('whereOrEmpty($runtimeType-->${e.message})');
      return [];
    }
  }
}
