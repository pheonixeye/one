import 'package:flutter/material.dart';
import 'package:one/models/doctor_items/pi_document_type.dart';

class PiDocumentTypeCreateEditDialog extends StatefulWidget {
  const PiDocumentTypeCreateEditDialog({super.key, this.piDocumentType});
  final PiDocumentType? piDocumentType;
  @override
  State<PiDocumentTypeCreateEditDialog> createState() =>
      _PiDocumentTypeCreateEditDialogState();
}

class _PiDocumentTypeCreateEditDialogState
    extends State<PiDocumentTypeCreateEditDialog> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
