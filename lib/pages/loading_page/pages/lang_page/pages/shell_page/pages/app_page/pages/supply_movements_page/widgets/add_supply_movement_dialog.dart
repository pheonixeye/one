import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/core/api/clinic_inventory_api.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/models/clinic/clinic.dart';
import 'package:one/models/doctor_items/doctor_supply_item.dart';
import 'package:one/models/supplies/clinic_inventory_item.dart';
import 'package:one/models/supplies/supply_movement.dart';
import 'package:one/models/supplies/supply_movement_dto.dart';
import 'package:one/models/supplies/supply_movement_type.dart';
import 'package:one/providers/px_auth.dart';
import 'package:one/providers/px_clinic_inventory.dart';
import 'package:one/providers/px_clinics.dart';
import 'package:one/providers/px_doctor_profile_items.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class AddSupplyMovementDialog extends StatefulWidget {
  const AddSupplyMovementDialog({super.key, this.supplyMovement});
  final SupplyMovement? supplyMovement;

  @override
  State<AddSupplyMovementDialog> createState() =>
      _AddSupplyMovementDialogState();
}

class _AddSupplyMovementDialogState extends State<AddSupplyMovementDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _movement_amount_controller;
  late final TextEditingController _reason_controller;
  DoctorSupplyItem? _supplyItem;
  Clinic? _sourceClinic;
  Clinic? _destinationClinic;
  double? _movement_amount;
  double? _movement_quantity;
  String? _movement_type;
  SupplyMovementType? _supplyMovementType;

  @override
  void initState() {
    super.initState();
    _supplyItem = widget.supplyMovement?.supply_item;
    _sourceClinic = widget.supplyMovement?.clinic;
    _movement_amount = widget.supplyMovement?.movement_amount;
    _movement_amount_controller = TextEditingController(
      text: _movement_amount?.toString() ?? '',
    );
    _reason_controller = TextEditingController(
      text: widget.supplyMovement?.reason ?? '',
    );
    _movement_quantity = widget.supplyMovement?.movement_quantity;
    _movement_type = widget.supplyMovement?.movement_type;
  }

  @override
  Widget build(BuildContext context) {
    //todo: Update to accomodate for adding supplies initially && inter-clinic supply transfer
    return Consumer3<
      PxClinics,
      PxDoctorProfileItems<DoctorSupplyItem>,
      PxLocale
    >(
      builder: (context, c, s, l, _) {
        while (c.result == null || s.data == null) {
          return const CentralLoading();
        }
        final _data = (s.data as ApiDataResult<List<DoctorSupplyItem>>).data;
        return AlertDialog(
          title: Row(
            children: [
              Expanded(
                child: widget.supplyMovement == null
                    ? Text(context.loc.newSupplyMovement)
                    : Text(context.loc.editSupplyMovement),
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
          scrollable: true,
          contentPadding: const EdgeInsets.all(8),
          insetPadding: const EdgeInsets.all(8),
          content: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: context.isMobile
                ? MediaQuery.sizeOf(context).width
                : MediaQuery.sizeOf(context).width / 2,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 150,

                    child: ListTile(
                      contentPadding: EdgeInsets.zero,

                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(context.loc.pickSupplyItem),
                      ),
                      subtitle: SizedBox(
                        height: 100,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<DoctorSupplyItem>(
                            items: _data.map((e) {
                              return DropdownMenuItem<DoctorSupplyItem>(
                                alignment: Alignment.center,
                                value: e,
                                child: Text(
                                  l.isEnglish ? e.name_en : e.name_ar,
                                ),
                              );
                            }).toList(),
                            alignment: Alignment.center,
                            onChanged: (val) {
                              setState(() {
                                _supplyItem = val;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150,

                    child: ListTile(
                      contentPadding: EdgeInsets.zero,

                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(context.loc.movementDirection),
                      ),
                      subtitle: SizedBox(
                        height: 100,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            items: SupplyMovementType.values.map((e) {
                              return DropdownMenuItem<String>(
                                alignment: Alignment.center,
                                value: e.en.toLowerCase(),
                                child: Text(
                                  l.isEnglish ? e.en.toUpperCase() : e.ar,
                                ),
                              );
                            }).toList(),
                            alignment: Alignment.center,
                            onChanged: (val) {
                              setState(() {
                                _supplyMovementType = SupplyMovementType.values
                                    .firstWhere((e) => e.en == val);
                                if (_supplyMovementType !=
                                    SupplyMovementType.IN_IN) {
                                  _destinationClinic = null;
                                }
                                _movement_type = val;
                                _movement_quantity = null;
                                _movement_amount = null;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  ...[
                    SizedBox(
                      height: 150,

                      child: ListTile(
                        contentPadding: EdgeInsets.zero,

                        title: _supplyMovementType == SupplyMovementType.IN_IN
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(context.loc.pickSourceClinic),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(context.loc.pickClinic),
                              ),
                        subtitle: SizedBox(
                          height: 100,

                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<Clinic>(
                              items: (c.result as ApiDataResult<List<Clinic>>)
                                  .data
                                  .map((e) {
                                    return DropdownMenuItem<Clinic>(
                                      alignment: Alignment.center,
                                      value: e,
                                      child: Text(
                                        l.isEnglish ? e.name_en : e.name_ar,
                                      ),
                                    );
                                  })
                                  .toList(),
                              alignment: Alignment.center,
                              initialValue: _sourceClinic,
                              onChanged: (val) {
                                setState(() {
                                  _sourceClinic = val;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_sourceClinic != null)
                      ChangeNotifierProvider(
                        key: UniqueKey(),
                        create: (context) => PxClinicInventory(
                          api: ClinicInventoryApi(clinic_id: _sourceClinic!.id),
                        ),
                        builder: (context, child) {
                          return Consumer<PxClinicInventory>(
                            builder: (context, i, _) {
                              while (i.result == null) {
                                return LinearProgressIndicator();
                              }
                              final _items =
                                  (i.result
                                          as ApiDataResult<
                                            List<ClinicInventoryItem>
                                          >)
                                      .data;
                              return SizedBox(
                                height: 150,

                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,

                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '(${l.isEnglish ? _sourceClinic?.name_en : _sourceClinic?.name_ar}) ${context.loc.availableSupplyItemsQuantities}',
                                    ),
                                  ),
                                  subtitle: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ..._items.map((e) {
                                        if (e.supply_item.id ==
                                            _supplyItem?.id) {
                                          return Row(
                                            spacing: 16,
                                            children: [
                                              Text(
                                                l.isEnglish
                                                    ? e.supply_item.name_en
                                                    : e.supply_item.name_ar,
                                              ),
                                              Text(
                                                '- ${e.available_quantity} -',
                                              ),
                                              Text(
                                                l.isEnglish
                                                    ? e.supply_item.unit_en
                                                    : e.supply_item.unit_ar,
                                              ),
                                            ],
                                          );
                                        }
                                        return const SizedBox();
                                      }),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    if (_supplyMovementType == SupplyMovementType.IN_IN)
                      SizedBox(
                        height: 150,

                        child: ListTile(
                          contentPadding: EdgeInsets.zero,

                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(context.loc.pickDestinationClinic),
                          ),
                          subtitle: SizedBox(
                            height: 100,

                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<Clinic>(
                                items: (c.result as ApiDataResult<List<Clinic>>)
                                    .data
                                    .map((e) {
                                      return DropdownMenuItem<Clinic>(
                                        alignment: Alignment.center,
                                        value: e,
                                        child: Text(
                                          l.isEnglish ? e.name_en : e.name_ar,
                                        ),
                                      );
                                    })
                                    .toList(),
                                alignment: Alignment.center,
                                initialValue: _destinationClinic,
                                onChanged: (val) {
                                  setState(() {
                                    _destinationClinic = val;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (_destinationClinic != null)
                      ChangeNotifierProvider(
                        key: UniqueKey(),
                        create: (context) => PxClinicInventory(
                          api: ClinicInventoryApi(
                            clinic_id: _destinationClinic!.id,
                          ),
                        ),
                        builder: (context, child) {
                          return Consumer<PxClinicInventory>(
                            builder: (context, i, _) {
                              while (i.result == null) {
                                return LinearProgressIndicator();
                              }
                              final _items =
                                  (i.result
                                          as ApiDataResult<
                                            List<ClinicInventoryItem>
                                          >)
                                      .data;
                              return SizedBox(
                                height: 150,

                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,

                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '(${l.isEnglish ? _destinationClinic?.name_en : _destinationClinic?.name_ar}) ${context.loc.availableSupplyItemsQuantities}',
                                    ),
                                  ),
                                  subtitle: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ..._items.map((e) {
                                        if (e.supply_item.id ==
                                            _supplyItem?.id) {
                                          return Row(
                                            spacing: 16,
                                            children: [
                                              Text(
                                                l.isEnglish
                                                    ? e.supply_item.name_en
                                                    : e.supply_item.name_ar,
                                              ),
                                              Text(
                                                '- ${e.available_quantity} -',
                                              ),
                                              Text(
                                                l.isEnglish
                                                    ? e.supply_item.unit_en
                                                    : e.supply_item.unit_ar,
                                              ),
                                            ],
                                          );
                                        }
                                        return const SizedBox();
                                      }),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                  ],
                  SizedBox(
                    height: 150,

                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(context.loc.movementReason),
                      ),
                      contentPadding: EdgeInsets.zero,
                      subtitle: TextFormField(
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: context.loc.enterMovementReason,
                        ),
                        controller: _reason_controller,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150,

                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(context.loc.movementQuantity),
                      ),
                      contentPadding: EdgeInsets.zero,

                      subtitle: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                hintText: context.loc.enterMovementQuantity,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) {
                                _movement_quantity = double.parse(value);
                                if (_supplyItem != null &&
                                    _movement_quantity != null) {
                                  _movement_amount_controller.text =
                                      switch (_supplyMovementType) {
                                        SupplyMovementType.IN_IN => '0',
                                        SupplyMovementType.IN_OUT =>
                                          (_supplyItem!.selling_price *
                                                  _movement_quantity!)
                                              .toString(),
                                        SupplyMovementType.OUT_IN =>
                                          (-_supplyItem!.buying_price *
                                                  _movement_quantity!)
                                              .toString(),
                                        _ => '',
                                      };
                                  _movement_amount = double.parse(
                                    _movement_amount_controller.text,
                                  );
                                }
                              },
                            ),
                          ),
                          if (_supplyItem != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                l.isEnglish
                                    ? _supplyItem!.unit_en
                                    : _supplyItem!.unit_ar,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(context.loc.movementAmount),
                      ),
                      contentPadding: EdgeInsets.zero,

                      subtitle: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _movement_amount_controller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                hintText: context.loc.enterMovementAmount,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              enabled: false,
                            ),
                          ),
                          if (_supplyItem != null && _movement_quantity != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(context.loc.egp),
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
                if (formKey.currentState!.validate()) {
                  SupplyMovementDto? _supplyMovementDestinationDto;
                  String? _src_reason;
                  String? _dest_reason;
                  if (_supplyMovementType == SupplyMovementType.IN_IN) {
                    _src_reason =
                        '${_reason_controller.text}__${context.loc.from}';
                    _dest_reason =
                        '${_reason_controller.text}__${context.loc.to}';
                  } else {
                    _src_reason = _reason_controller.text;
                    _dest_reason = _reason_controller.text;
                  }
                  final _supplyMovementSourceDto = SupplyMovementDto(
                    id: '',
                    clinic_id: _sourceClinic?.id ?? '',
                    supply_item_id: _supplyItem?.id ?? '',
                    movement_type: _movement_type ?? '',
                    related_visit_id: widget.supplyMovement?.visit_id ?? '',
                    reason: _src_reason,
                    added_by: context.read<PxAuth>().doc_id,
                    movement_amount: _movement_amount ?? 0.0,
                    movement_quantity: _movement_quantity ?? 0.0,
                    auto_add: false,
                    updated_by: '',
                    number_of_updates: 0,
                  );
                  if (_supplyMovementType == SupplyMovementType.IN_IN) {
                    _supplyMovementDestinationDto = SupplyMovementDto(
                      id: '',
                      clinic_id: _destinationClinic?.id ?? '',
                      supply_item_id: _supplyItem?.id ?? '',
                      movement_type: _movement_type ?? '',
                      related_visit_id: widget.supplyMovement?.visit_id ?? '',
                      reason: _dest_reason,
                      added_by: context.read<PxAuth>().doc_id,
                      movement_amount: _movement_amount ?? 0.0,
                      movement_quantity: _movement_quantity ?? 0.0,
                      auto_add: false,
                      updated_by: '',
                      number_of_updates: 0,
                    );
                  }
                  Navigator.pop(context, [
                    _supplyMovementSourceDto,
                    _supplyMovementDestinationDto,
                  ]);
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
      },
    );
  }
}
