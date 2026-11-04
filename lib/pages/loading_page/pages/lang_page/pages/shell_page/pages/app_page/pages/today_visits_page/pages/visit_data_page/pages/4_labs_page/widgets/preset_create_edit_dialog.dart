import 'package:flutter/material.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/models/doctor_items/pi_lab.dart';
import 'package:one/models/preset.dart';
import 'package:one/providers/px_presets.dart';
import 'package:one/providers/px_profile_items/px_pi_labs.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class PresetCreateEditDialog extends StatefulWidget {
  const PresetCreateEditDialog({
    super.key,
    required this.selectedLabs,
    required this.type,
  });
  final List<String> selectedLabs;
  final PresetType type;

  @override
  State<PresetCreateEditDialog> createState() => _PresetCreateEditDialogState();
}

class _PresetCreateEditDialogState extends State<PresetCreateEditDialog> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PxPiLabs, PxPresets>(
      builder: (context, l, p, _) {
        while (l.labs == null || p.result == null) {
          return const CentralLoading();
        }

        while (l.labs is ApiErrorResult || p.result is ApiErrorResult) {
          return CentralError(
            code: (p.result as ApiErrorResult).errorCode,
            toExecute: () async {
              l.retry();
              p.retry();
            },
          );
        }
        final _piLabs = (l.labs as ApiDataResult<List<PiLab>>).data;

        return AlertDialog();
      },
    );
  }
}
