import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one/core/api/_api_result.dart';
import 'package:one/extensions/is_mobile_context.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/extensions/visit_ext.dart';
import 'package:one/models/app_constants/patient_progress_status.dart';
import 'package:one/models/app_constants/visit_status.dart';
import 'package:one/models/app_constants/visit_type.dart';
import 'package:one/models/notifications/clinic_call.dart';
import 'package:one/models/visits/visit.dart';
import 'package:one/providers/px_locale.dart';
import 'package:one/providers/px_visits.dart';
import 'package:one/widgets/central_error.dart';
import 'package:one/widgets/central_loading.dart';
import 'package:one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class VisitSelectFeesAmountDialog extends StatefulWidget {
  const VisitSelectFeesAmountDialog({super.key, required this.call});
  final ClinicCall call;

  @override
  State<VisitSelectFeesAmountDialog> createState() =>
      _VisitSelectFeesAmountDialogState();
}

class _VisitSelectFeesAmountDialogState
    extends State<VisitSelectFeesAmountDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _amountController = TextEditingController();

  VisitExpanded? _groupValue;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        return AlertDialog(
          title: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: context.loc.selectVisitAndAmount,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: '\n'),
                      TextSpan(
                        text:
                            '(${l.isEnglish ? widget.call.en : widget.call.ar})',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton.outlined(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                icon: const Icon(Icons.close),
              ),
              SizedBox(width: 10),
            ],
          ),
          contentPadding: const EdgeInsets.all(8),
          insetPadding: const EdgeInsets.all(8),
          scrollable: false,

          content: Consumer<PxLocale>(
            builder: (context, l, _) {
              return SizedBox(
                height: MediaQuery.heightOf(context) - 100,
                width: context.isMobile
                    ? MediaQuery.widthOf(context) - 50
                    : MediaQuery.widthOf(context) / 2,
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 8,
                    children: [
                      // visit selector
                      Expanded(
                        child: Consumer<PxVisits>(
                          builder: (context, v, _) {
                            while (v.visits == null) {
                              return const CentralLoading();
                            }
                            while (v.visits is ApiErrorResult) {
                              final _err = (v.visits as ApiErrorResult);
                              return CentralError(
                                code: _err.errorCode,
                                toExecute: v.retry,
                              );
                            }
                            final _visits =
                                (v.visits as ApiDataResult<List<VisitExpanded>>)
                                    .data;
                            if (_visits.isEmpty) {
                              return CentralNoItems(
                                message: context.loc.noVisitsFoundForToday,
                              );
                            }
                            return FormField<VisitExpanded>(
                              builder: (field) {
                                return RadioGroup<VisitExpanded>(
                                  onChanged: (val) {
                                    setState(() {
                                      if (val != null) {
                                        _groupValue = val;
                                      }
                                    });
                                  },
                                  groupValue: _groupValue,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: _visits.length,
                                          itemBuilder: (context, index) {
                                            final _item = _visits[index];
                                            return Card.outlined(
                                              elevation: 6,
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: RadioListTile<VisitExpanded>(
                                                  titleAlignment:
                                                      ListTileTitleAlignment
                                                          .top,
                                                  title: Builder(
                                                    builder: (context) {
                                                      final _type =
                                                          VisitTypeEnum.member(
                                                            _item.visit_type,
                                                          );
                                                      return Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      8.0,
                                                                ),
                                                            child: const Icon(
                                                              Icons.person,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      8.0,
                                                                ),
                                                            child: Text(
                                                              _item
                                                                  .patient
                                                                  .name,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                          ),
                                                          Card.outlined(
                                                            color: _type
                                                                .getCardColor,
                                                            elevation: 2,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.all(
                                                                    8.0,
                                                                  ),
                                                              child: Text(
                                                                l.isEnglish
                                                                    ? _type.en
                                                                    : _type.ar,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                  subtitle: Builder(
                                                    builder: (context) {
                                                      final _status =
                                                          VisitStatusEnum.member(
                                                            _item.visit_status,
                                                          );
                                                      final _progress =
                                                          PatientProgressStatusEnum.member(
                                                            _item
                                                                .patient_progress_status,
                                                          );

                                                      return Column(
                                                        spacing: 8,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                    ),
                                                                child: const Icon(
                                                                  Icons
                                                                      .wash_rounded,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                    ),
                                                                child: Text(
                                                                  context
                                                                      .loc
                                                                      .attendanceStatus,
                                                                ),
                                                              ),
                                                              Card.outlined(
                                                                color: _status
                                                                    .getCardColor,
                                                                elevation: 2,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                        8.0,
                                                                      ),
                                                                  child: Text(
                                                                    l.isEnglish
                                                                        ? _status
                                                                              .en
                                                                        : _status
                                                                              .ar,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                    ),
                                                                child: const Icon(
                                                                  Icons
                                                                      .add_task_outlined,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                    ),
                                                                child: Text(
                                                                  context
                                                                      .loc
                                                                      .progressStatus,
                                                                ),
                                                              ),
                                                              Card.outlined(
                                                                color: _progress
                                                                    .getCardColor,
                                                                elevation: 2,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                        8.0,
                                                                      ),
                                                                  child: Text(
                                                                    l.isEnglish
                                                                        ? _progress
                                                                              .en
                                                                        : _progress
                                                                              .ar,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                  value: _item,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      if (_groupValue == null)
                                        Text(
                                          context.loc.pickVisit,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      // fees entry field
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(context.loc.enterAmount),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: true,
                            controller: _amountController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText:
                                  context.loc.enterAmountForReturnOrCollection,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return context.loc.enterAmount;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.all(8),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                final _data = <String, String?>{};
                if (_formKey.currentState!.validate()) {
                  _data['name'] = _groupValue?.patient.name;
                  _data['fees'] = _amountController.text;
                  Navigator.pop(context, _data);
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
