import 'package:flutter/material.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/dprint.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/information_overlay.dart';
import 'package:one/widgets/retry_overlay.dart';

///Shell function encapsulating loading & error handling logic in the UI
Future<void> shellFunction(
  BuildContext context, {
  required Function toExecute,
  String sucessMsg = '',
  Function? onCatch,
  Duration duration = const Duration(seconds: 5),
}) async {
  late BuildContext loadingContext;
  try {
    if (sucessMsg.isEmpty) {
      sucessMsg = context.loc.success;
    }
    if (context.mounted) {
      //todo: change to overlay logic
      showDialog(
        context: context,
        builder: (context) {
          loadingContext = context;
          return const CentralLoading();
        },
      );
    }
    await Future.delayed(const Duration(milliseconds: 500));
    await toExecute();
    if (loadingContext.mounted) {
      Navigator.pop(loadingContext);
    }
    if (context.mounted) {
      final _successOverlay = informationOverlayEntry(sucessMsg);

      Overlay.of(context).insert(_successOverlay);

      await Future.delayed(duration);
      if (_successOverlay.mounted) {
        _successOverlay.remove();
      }
    }
  } catch (e, s) {
    if (loadingContext.mounted) {
      Navigator.pop(loadingContext);
    }
    if (context.mounted) {
      dprint('error-overlay-init');
      final _errorOverlay = informationOverlayEntry(e.toString(), Colors.red);
      Overlay.of(context).insert(_errorOverlay);
      await Future.delayed(duration);
      if (_errorOverlay.mounted) {
        _errorOverlay.remove();
        dprint('error-overlay-dispose');
      }

      await Future.delayed(const Duration(milliseconds: 500));
      if (context.mounted) {
        dprint('retry-overlay-init');
        final _retryOverlay = retryOverlayEntry(() async {
          await shellFunction(context, toExecute: toExecute);
        });
        Overlay.of(context).insert(_retryOverlay);
      }

      debugPrint(s.toString());
      if (onCatch != null) {
        onCatch();
      }
    }
  }
}
