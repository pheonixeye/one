import 'package:flutter/material.dart';
import 'package:one/models/doctor_items/pi_referral.dart';

class PiReferralCreateEditDialog extends StatefulWidget {
  const PiReferralCreateEditDialog({super.key, this.piReferral});
  final PiReferral? piReferral;
  @override
  State<PiReferralCreateEditDialog> createState() =>
      _PiReferralCreateEditDialogState();
}

class _PiReferralCreateEditDialogState
    extends State<PiReferralCreateEditDialog> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
