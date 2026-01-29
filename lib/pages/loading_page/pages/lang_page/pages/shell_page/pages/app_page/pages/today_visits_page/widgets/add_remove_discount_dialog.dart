import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/bookkeeping/bookkeeping_direction.dart';
import 'package:one/models/bookkeeping/bookkeeping_item.dart';
import 'package:one/models/bookkeeping/bookkeeping_name.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/patients_page/widgets/previous_visit_view_card.dart';
import 'package:one/providers/px_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddRemoveDiscountDialog extends StatefulWidget {
  const AddRemoveDiscountDialog({
    super.key,
    required this.visit,
    required this.direction,
  });
  final VisitExpanded visit;
  final BookkeepingDirection direction;

  @override
  State<AddRemoveDiscountDialog> createState() =>
      _AddRemoveDiscountDialogState();
}

class _AddRemoveDiscountDialogState extends State<AddRemoveDiscountDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(switch (widget.direction) {
              BookkeepingDirection.IN => context.loc.removeDiscount,
              BookkeepingDirection.OUT => context.loc.addDiscount,
              BookkeepingDirection.NONE => throw UnimplementedError(),
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton.outlined(
              onPressed: () {
                Navigator.pop(context, null);
              },
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
      scrollable: false,
      contentPadding: const EdgeInsets.all(8),
      insetPadding: const EdgeInsets.all(8),
      content: SizedBox(
        width: context.isMobile
            ? MediaQuery.sizeOf(context).width
            : MediaQuery.sizeOf(context).width / 2,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PreviousVisitViewCard(
                item: widget.visit,
                index: 0,
                showIndexNumber: false,
                showPatientName: true,
              ),
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(context.loc.discount),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: context.loc.discountInPounds,
                          ),
                          controller: _amountController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '${context.loc.enter} ${context.loc.amountInPounds}';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.all(8),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final _dto = BookkeepingItem(
                id: '',
                item_name: switch (widget.direction) {
                  BookkeepingDirection.IN =>
                    BookkeepingName.visit_remove_discount.name,
                  BookkeepingDirection.OUT =>
                    BookkeepingName.visit_add_discount.name,
                  BookkeepingDirection.NONE => '',
                },
                item_id: widget.visit.id,
                collection_id: 'visits',
                added_by: '${context.read<PxAuth>().user?.name}',
                updated_by: '',
                amount: switch (widget.direction) {
                  BookkeepingDirection.IN => double.parse(
                    _amountController.text,
                  ),
                  BookkeepingDirection.OUT => -double.parse(
                    _amountController.text,
                  ),
                  BookkeepingDirection.NONE => 0,
                },
                type: widget.direction,
                update_reason:
                    '${widget.visit.patient.name}/${widget.visit.visit_type}/${widget.direction.value}/${_amountController.text}',
                auto_add: false,
                created: DateTime.now(),
                visit_id: widget.visit.id,
                visit_date: widget.visit.visit_date,
                visit_data_id: '',
                patient_id: widget.visit.patient_id,
                procedure_id: '',
                supply_movement_id: '',
              );
              //pop with null to avoid an extra useless request

              Navigator.pop(context, _dto);
            }
          },
          label: Text(context.loc.confirm),
          icon: Icon(Icons.check, color: Colors.green.shade100),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context, null);
          },
          label: Text(context.loc.cancel),
          icon: const Icon(Icons.close, color: Colors.red),
        ),
      ],
    );
  }
}
