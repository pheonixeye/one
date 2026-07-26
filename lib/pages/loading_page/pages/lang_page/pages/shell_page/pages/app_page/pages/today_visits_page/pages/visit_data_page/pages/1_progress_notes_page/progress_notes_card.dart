import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:one/extensions/datetime_ext.dart';
import 'package:one/extensions/loc_ext.dart';
import 'package:one/functions/shell_function.dart';
import 'package:one/models/patient_progress_note.dart';
import 'package:one/providers/px_progress_notes.dart';
import 'package:one/widgets/prompt_dialog.dart';
import 'package:one/widgets/sm_btn.dart';
import 'package:one/widgets/snackbar_.dart';
import 'package:provider/provider.dart';

class ProgressNotesCard extends StatefulWidget {
  const ProgressNotesCard({
    super.key,
    required this.note,
    required this.index,
  });
  final PatientProgressNote note;
  final int index;

  @override
  State<ProgressNotesCard> createState() => _ProgressNotesCardState();
}

class _ProgressNotesCardState extends State<ProgressNotesCard> {
  late final TextEditingController _subjectiveController;
  late final TextEditingController _objectiveController;
  late final TextEditingController _assessmentController;
  late final TextEditingController _planController;

  final ValueNotifier<bool> _isEditing = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isExpanded = ValueNotifier<bool>(true);

  late final _isTodayVisit = widget.note.visit_date.isTheSameDate(
    DateTime.now().unTimed,
  );

  @override
  void initState() {
    super.initState();
    _subjectiveController = TextEditingController(text: widget.note.subjective);
    _objectiveController = TextEditingController(text: widget.note.objective);
    _assessmentController = TextEditingController(text: widget.note.assessment);
    _planController = TextEditingController(text: widget.note.plan);
  }

  @override
  void dispose() {
    _subjectiveController.dispose();
    _objectiveController.dispose();
    _assessmentController.dispose();
    _planController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PxProgressNotes>(
      builder: (context, pn, _) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card.outlined(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ValueListenableBuilder(
                  valueListenable: _isEditing,
                  builder: (context, value, child) {
                    return ExpansionTile(
                      onExpansionChanged: (value) {
                        _isExpanded.value = value;
                      },
                      initiallyExpanded: true,
                      showTrailingIcon: true,
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          spacing: 8,
                          children: [
                            SmBtn(
                              child: Text('${widget.index + 1}'),
                            ),
                            Card.outlined(
                              elevation: 6,
                              color: _isTodayVisit
                                  ? Colors.amber.shade50
                                  : Colors.blue.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  intl.DateFormat(
                                    'dd - MM - yyyy',
                                    'en',
                                  ).format(widget.note.visit_date),
                                ),
                              ),
                            ),
                            Text('  '),
                            Text(
                              intl.DateFormat.jmv(
                                'en',
                              ).format(widget.note.time_of_note),
                            ),
                          ],
                        ),
                      ),
                      subtitle: ValueListenableBuilder<bool>(
                        valueListenable: _isExpanded,
                        builder: (context, exp, child) {
                          if (exp == false) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 8,
                              children: [
                                if (_isEditing.value)
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      _isEditing.value = false;
                                    },
                                    label: Text(context.loc.back),
                                    icon: const Icon(Icons.refresh),
                                  ),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    if (_isEditing.value == true) {
                                      await shellFunction(
                                        context,
                                        toExecute: () async {
                                          await pn.updateNote(
                                            widget.note.id,
                                            {
                                              'subjective':
                                                  _subjectiveController.text,
                                              'objective':
                                                  _objectiveController.text,
                                              'assessment':
                                                  _assessmentController.text,
                                              'plan': _planController.text,
                                            },
                                          );
                                        },
                                        duration: const Duration(
                                          milliseconds: 260,
                                        ),
                                      );
                                    }
                                    _isEditing.value = !_isEditing.value;
                                  },
                                  label: Text(
                                    value
                                        ? context.loc.save
                                        : context.loc.editNote,
                                  ),
                                  icon: Icon(
                                    value ? Icons.save : Icons.edit,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () async {
                                    if (!_isTodayVisit) {
                                      showIsnackbar(
                                        context
                                            .loc
                                            .cannotDeleteAnOldProgressNote,
                                      );
                                      return;
                                    }
                                    final _toDelete = await showDialog<bool?>(
                                      context: context,
                                      builder: (context) => PromptDialog(
                                        message: context
                                            .loc
                                            .deleteProgressNotePrompt,
                                      ),
                                    );
                                    if (_toDelete == null ||
                                        _toDelete == false) {
                                      return;
                                    }
                                    if (context.mounted) {
                                      await shellFunction(
                                        context,
                                        toExecute: () async {
                                          await pn.deleteNote(
                                            widget.note.id,
                                          );
                                        },
                                      );
                                    }
                                  },
                                  label: Text(
                                    context.loc.deleteNote,
                                  ),
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      children: [
                        ListTile(
                          leading: const SizedBox(),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Subjective'),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: value
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _subjectiveController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            enabled: true,
                                          ),
                                          maxLines: 4,
                                          minLines: null,
                                          expands: false,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(widget.note.subjective),
                          ),
                        ),
                        ListTile(
                          leading: const SizedBox(),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Objective'),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: value
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _objectiveController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            enabled: true,
                                          ),
                                          maxLines: 4,
                                          minLines: null,
                                          expands: false,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(widget.note.objective),
                          ),
                        ),
                        ListTile(
                          leading: const SizedBox(),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Assessment'),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: value
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _assessmentController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            enabled: true,
                                          ),
                                          maxLines: 4,
                                          minLines: null,
                                          expands: false,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(widget.note.assessment),
                          ),
                        ),
                        ListTile(
                          leading: const SizedBox(),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Plan'),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: value
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _planController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            enabled: true,
                                          ),
                                          maxLines: 4,
                                          minLines: null,
                                          expands: false,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(widget.note.plan),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
